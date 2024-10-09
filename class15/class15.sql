USE sakila;

-- CONSULTA 1
-- Crear una vista llamada customer_overview que debe contener las siguientes columnas:
--    ID del cliente
--    Nombre completo del cliente
--    Dirección
--    Código postal
--    Número de contacto
--    Ciudad
--    País
--    Estado del cliente (cuando la columna active sea 1, mostrar 'active', de lo contrario 'inactive')
--    Referencia de la tienda

CREATE VIEW customer_overview AS 
	SELECT cus.customer_id AS 'ID', CONCAT(cus.first_name, ' ', cus.last_name) AS 'Nombre Completo',
    a.address AS 'Dirección', a.postal_code AS 'Código Postal', a.phone AS 'Número de Contacto', ci.city AS 'Ciudad', co.country AS 'País',
    CASE WHEN cus.active = 1 THEN 'active' ELSE 'inactive' END AS 'Estado', cus.store_id AS 'Referencia de Tienda' 
    FROM customer cus 
    JOIN address a ON cus.address_id = a.address_id 
    JOIN city ci ON a.city_id = ci.city_id 
    JOIN country co ON ci.country_id = co.country_id;
    
SELECT * FROM customer_overview;

-- CONSULTA 2
-- Crear una vista llamada detailed_film_info que debe contener las siguientes columnas:
-- ID de la película, título, descripción, categoría, precio de alquiler, duración, clasificación, y actores (como una cadena separada por comas).
-- Usa GROUP_CONCAT para concatenar los nombres de los actores.

CREATE VIEW detailed_film_info AS
	SELECT f.film_id AS 'ID Película', f.title AS 'Título', f.description AS 'Descripción', cat.name AS 'Categoría', f.rental_rate AS 'Precio Alquiler',
    f.length AS 'Duración', f.rating AS 'Clasificación', GROUP_CONCAT(CONCAT(' ', a.first_name, ' ', a.last_name)) AS 'Actores'
    FROM film f 
    JOIN film_category fc ON f.film_id = fc.film_id 
    JOIN category cat ON fc.category_id = cat.category_id 
    JOIN film_actor fa ON f.film_id = fa.film_id 
    JOIN actor a ON fa.actor_id = a.actor_id 
    GROUP BY f.film_id, cat.name;

SELECT * FROM detailed_film_info;

-- CONSULTA 3
-- Crear una vista llamada film_sales_summary, que debe devolver las columnas 'categoría' y 'total de alquileres'.

CREATE VIEW film_sales_summary AS
	SELECT c.name AS 'Categoría de Película', COUNT(r.rental_id) AS 'Total de Alquileres' 
    FROM category c 
    JOIN film_category fc ON c.category_id = fc.category_id 
    JOIN film f ON fc.film_id = f.film_id 
    JOIN inventory i ON f.film_id = i.film_id 
    JOIN rental r ON i.inventory_id = r.inventory_id 
    GROUP BY c.name;
    
SELECT * FROM film_sales_summary;

-- CONSULTA 4
-- Crear una vista llamada actor_participation que devuelva el ID del actor, nombre, apellido y el número de películas en las que actuó.

CREATE VIEW actor_participation AS
	SELECT a.actor_id AS 'ID Actor', a.first_name AS 'Nombre', a.last_name AS 'Apellido', COUNT(fa.film_id) AS 'Películas Participadas'
    FROM actor a 
    JOIN film_actor fa ON a.actor_id = fa.actor_id 
    GROUP BY a.actor_id;
    
SELECT * FROM actor_participation;

-- CONSULTA 5
-- Analizar la vista actor_information y explicar cómo funciona la consulta y, en particular, cómo funciona la subconsulta.

SELECT * FROM actor_info;
/*
La vista actor_info recupera datos para cada actor y las películas en las que participó, agrupadas por categoría de película. Muestra el ID del actor, nombre y apellido,
y un campo llamado 'film_info', que concatena cada categoría con una lista de películas en las que el actor participó. La subconsulta usa GROUP_CONCAT 
para unir los títulos de las películas en cada categoría.
La consulta principal utiliza un LEFT JOIN desde la tabla actor hacia las tablas film_actor, film_category y category para reunir datos relevantes de las películas, 
asegurando que los actores sin películas también sean listados.
*/

-- CONSULTA 6
-- Vistas materializadas: Una descripción de su funcionalidad, casos de uso, alternativas y sistemas de gestión de bases de datos que las soportan.

-- Explicación teórica proporcionada sin cambios.
