USE sakila;

-- CONSULTA 1
-- Crear una consulta que obtenga todos los clientes que viven en Argentina. Mostrar el nombre completo en una columna, la dirección y la ciudad.

SELECT CONCAT_WS(' ', c.first_name, c.last_name) AS 'Cliente', 
CONCAT_WS(', ', a.address, a.district) AS 'Dirección', 
CONCAT_WS(', ', ci.city, co.country) AS 'Ciudad'
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Argentina';

-- CONSULTA 2
-- Crear una consulta que muestre el título de la película, el idioma y la clasificación. La clasificación debe mostrarse como texto completo según el sistema de calificación de contenido de películas.

SELECT f.title AS 'Título', l.name AS 'Idioma', 
CASE 
    WHEN f.rating = 'G' THEN 'G (General Audiences) – Apto para todo público.'
    WHEN f.rating = 'PG' THEN 'PG (Parental Guidance Suggested) – Se recomienda la supervisión de un adulto.'
    WHEN f.rating = 'PG-13' THEN 'PG-13 (Parents Strongly Cautioned) – No apto para menores de 13 años.'
    WHEN f.rating = 'R' THEN 'R (Restricted) – Menores de 17 años requieren la supervisión de un adulto.'
    WHEN f.rating = 'NC-17' THEN 'NC-17 (Adults Only) – No apto para menores de 17 años.'
    ELSE 'Clasificación desconocida'
END AS 'Clasificación'
FROM film f
JOIN language l ON f.language_id = l.language_id;

-- CONSULTA 3
-- Crear una consulta que muestre todas las películas (título y año de lanzamiento) en las que un actor ha participado.
-- Suponiendo que el nombre del actor se ingresa manualmente en una página web.

SELECT CONCAT_WS(' ', a.first_name, a.last_name) AS 'Actor', 
GROUP_CONCAT(DISTINCT CONCAT(f.title, ' (', f.release_year, ')') ORDER BY f.release_year SEPARATOR '; ') AS 'Películas'
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE CONCAT_WS(' ', a.first_name, a.last_name) LIKE '%%' -- <- Colocar aquí el nombre del actor entre %
GROUP BY a.actor_id;

-- CONSULTA 4
-- Encontrar todos los alquileres realizados en los meses de mayo y junio. Mostrar el título de la película, el nombre del cliente y si fue devuelto o no.
-- Debe haber una columna "Devuelto" con dos posibles valores: 'Sí' y 'No'.

SELECT f.title AS 'Título', 
DATE_FORMAT(r.rental_date, '%d-%m-%Y') AS 'Fecha de Alquiler', 
CONCAT_WS(' ', c.first_name, c.last_name) AS 'Cliente', 
IF(r.return_date IS NOT NULL, 'Sí', 'No') AS 'Devuelto'
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN customer c ON r.customer_id = c.customer_id
JOIN film f ON i.film_id = f.film_id
WHERE MONTH(r.rental_date) IN (5, 6);

-- CONSULTA 5
-- Investigar las funciones CAST y CONVERT. Explicar las diferencias, si las hay, y escribir ejemplos basados en la base de datos sakila.

-- En MySQL, las funciones CAST y CONVERT tienen una diferencia mínima en la sintaxis:
-- CAST(expresión AS tipo) 
-- CONVERT(expresión, tipo)
-- En SQL Server, CONVERT permite un parámetro adicional para el estilo de formato. Además, en MySQL, CONVERT puede usarse también para cambiar el conjunto de caracteres.
-- En general, CAST es preferible cuando se desea un código más portable, mientras que CONVERT puede ofrecer más opciones según el dialecto SQL.
-- Ejemplos:
SELECT CAST(rental_date AS DATE) AS 'Fecha con CAST' FROM rental; -- Convierte la fecha y hora en solo fecha.
SELECT CONVERT(rental_date, DATE) AS 'Fecha con CONVERT' FROM rental; -- Funciona igual que CAST en MySQL.

-- CONSULTA 6
-- Investigar las funciones NVL, ISNULL, IFNULL, COALESCE, etc. Explicar para qué sirven y cuáles no están disponibles en MySQL, con ejemplos de uso.

-- La función NVL verifica si un valor es NULL y lo reemplaza con un valor especificado, pero NO está disponible en MySQL (es usada en Oracle).
-- Sintaxis: NVL(campo, valor_reemplazo), Ejemplo: NVL(rental_date, '2005-05-24') <- Reemplazaría rental_date con la fecha dada si fuera NULL.
-- IFNULL realiza la misma función que NVL, pero sí está disponible en MySQL.
-- Sintaxis: IFNULL(campo, valor_reemplazo).
-- ISNULL es diferente en MySQL; devuelve 1 si el valor es NULL y 0 si no lo es.
-- Sintaxis: ISNULL(valor).
-- COALESCE devuelve el primer valor no nulo en una lista de expresiones. Si todos son nulos, devuelve NULL.
-- Sintaxis: COALESCE(valor1, valor2, valor3, ...).
-- NULLIF compara dos valores y devuelve NULL si son iguales; si no, devuelve el primer valor.
-- Sintaxis: NULLIF(valor1, valor2).

-- Ejemplos:
SELECT address AS 'Dirección', IFNULL(address2, 'No tiene segunda dirección') FROM address; -- Reemplaza dirección2 si es NULL.
SELECT address AS 'Dirección', ISNULL(address2) AS '¿Alguna dirección nula?' FROM address;
SELECT COALESCE(address2, address) AS 'Dirección' FROM address; -- Devuelve dirección si dirección2 es NULL, por el orden de la sintaxis.
SELECT NULLIF(c.first_name, s.first_name) AS 'Nombre Cliente' -- Devuelve el nombre del cliente si el cliente y el empleado no tienen el mismo nombre.
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN staff s ON r.staff_id = s.staff_id;
