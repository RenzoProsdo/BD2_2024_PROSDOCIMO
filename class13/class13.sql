USE sakila;

-- Consulta 1: Agregar un nuevo cliente
--   A la tienda 1
--   Para la dirección, usa una dirección existente. La que tiene el mayor address_id en 'United States'

INSERT INTO customer (store_id, first_name, last_name, email, address_id, create_date) VALUES
(1, 'Carlos', 'Rodriguez', 'carlosrod@gmail.com', 
(SELECT address_id FROM address 
WHERE address_id = (SELECT MAX(a.address_id) FROM address a 
INNER JOIN city c ON a.city_id = c.city_id 
INNER JOIN country co ON c.country_id = co.country_id
WHERE co.country = 'United States')), 
CURRENT_TIMESTAMP());
-- Created ID: 601

-- Consulta 2: Agregar un alquiler
--   Haz fácil seleccionar cualquier título de película. Es decir, debería poder poner 'título de la película' en el where, y no el id.
--   No verifiques si la película ya está alquilada, solo usa cualquiera del inventario, p.ej. el que tiene el id más alto.
--   Selecciona cualquier staff_id de la Tienda 2.

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update) VALUES
(CURRENT_TIMESTAMP(), 
(SELECT MAX(i.inventory_id) FROM inventory i 
JOIN film f ON i.film_id = f.film_id 
WHERE i.store_id = 2
AND f.title = 'MODEL FISH'), -- Ingresa el título de la película que quieras rentar
(SELECT customer_id FROM customer 
WHERE first_name = 'Carlos' AND last_name = 'Rodriguez' AND email = 'carlosrod@gmail.com'), -- Cliente es el que se creó anteriormente
DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL 30 DAY), -- Fecha de devolución es un mes después de la fecha de renta
(SELECT s.staff_id FROM staff s WHERE s.store_id = 2 ORDER BY RAND() LIMIT 1), -- Selecciona un staff aleatorio de la tienda 2
CURRENT_TIMESTAMP());
-- Created ID: 16051

-- Consulta 3: Actualizar el año de la película basado en la calificación
--   Por ejemplo, si la calificación es 'G' la fecha de lanzamiento será '2001'
--   Puedes elegir el mapeo entre calificación y año.
--   Escribe tantas declaraciones como sea necesario.

UPDATE film 
SET release_year = 2002 
WHERE rating = 'G';

UPDATE film 
SET release_year = 2006 
WHERE rating = 'PG';

UPDATE film 
SET release_year = 2013 
WHERE rating = 'PG-13';

UPDATE film 
SET release_year = 2018 
WHERE rating = 'R';

UPDATE film 
SET release_year = 2021 
WHERE rating = 'NC-17';

-- Consulta 4: Devolver una película
--   Escribe las declaraciones y consultas necesarias para los siguientes pasos.
--   Encuentra una película que aún no se haya devuelto. Y usa ese id de alquiler. Elige el último que fue alquilado, por ejemplo.
--   Usa el id para devolver la película.

UPDATE rental 
SET return_date = CURRENT_TIMESTAMP() 
WHERE rental_id = (SELECT MAX(rental_id) 
FROM rental 
WHERE return_date IS NULL);
-- Updated ID: 15967

-- Consulta 5: Intentar eliminar una película
--   Verifica qué pasa, describe qué hacer.
--   Escribe todas las declaraciones de eliminación necesarias para eliminar completamente la película de la base de datos.

DELETE FROM film 
WHERE film_id = 1001;
/* Respuesta: Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails 
(`sakila`.`film_actor`, CONSTRAINT `fk_film_actor_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE) */

-- NUEVO ORDEN: Se pueden borrar las filas de la tabla film_actor y film_category que tienen como film_id 1001 (o el id de la tabla que queremos borrar)
DELETE FROM film_actor 
WHERE film_id = 1001;

DELETE FROM film_category 
WHERE film_id = 1001;

-- Después tenemos que borrar inventory, pero para ello debemos borrar todas las rentas que dependen de los inventarios de las películas seleccionadas
DELETE FROM rental 
WHERE inventory_id IN (SELECT inventory_id FROM inventory WHERE film_id = 1001);

DELETE FROM inventory 
WHERE film_id = 1001;

-- Finalmente, podemos borrar la película
DELETE FROM film 
WHERE film_id = 1001;

-- Consulta 6: Rentar una película
--   Encuentra un id de inventario que esté disponible para rentar (disponible en la tienda) selecciona cualquier película. Guarda este id en algún lugar.
--   Agrega una entrada de alquiler
--   Agrega una entrada de pago
--   Usa subconsultas para todo, excepto para el id de inventario que se puede usar directamente en las consultas.

SELECT * FROM inventory 
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id 
WHERE rental.rental_id IS NULL 
LIMIT 1;

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update) VALUES
(CURRENT_TIMESTAMP(), 6, (SELECT customer_id FROM customer ORDER BY RAND() LIMIT 1), DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL 30 DAY),
(SELECT staff_id FROM staff WHERE store_id = (SELECT store_id FROM inventory WHERE inventory_id = 6) ORDER BY RAND() LIMIT 1), CURRENT_TIMESTAMP());

INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date, last_update) VALUES
((SELECT customer_id FROM rental WHERE inventory_id = 6), (SELECT staff_id FROM rental WHERE inventory_id = 6), (SELECT rental_id FROM rental WHERE inventory_id = 6),
4.99, DATE_ADD((SELECT rental_date FROM rental WHERE inventory_id = 6), INTERVAL 1 DAY), CURRENT_TIMESTAMP());

SELECT * FROM rental WHERE inventory_id = 6;
SELECT * FROM payment WHERE rental_id = 16051;
