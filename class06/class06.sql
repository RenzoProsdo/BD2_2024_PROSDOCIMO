USE sakila;

SELECT first_name,last_name FROM customer c1 
 WHERE EXISTS (
	SELECT * FROM customer c2 
		WHERE c1.last_name = c2.last_name AND c1.customer_id != c2.customer_id
			)ORDER BY c1.last_name;

SELECT ac.first_name, ac.last_name FROM actor ac
WHERE ac.actor_id NOT IN(SELECT fi_ac.actor_id FROM film_actor fi_ac);

SELECT c.first_name,c.last_name,count(r.customer_id) AS cant_compras FROM rental r 
INNER JOIN customer c ON c.customer_id=r.customer_id
GROUP BY r.customer_id HAVING 1=count(r.customer_id);

SELECT c.first_name,c.last_name,count(r.customer_id) AS cant_compras FROM rental r 
INNER JOIN customer c ON c.customer_id=r.customer_id
GROUP BY r.customer_id HAVING 1<count(r.customer_id);

SELECT ac.first_name, ac.last_name FROM film_actor fi_ac
INNER JOIN actor ac ON ac.actor_id = fi_ac.actor_id
INNER JOIN film f ON f.film_id=fi_ac.film_id
WHERE f.title in ('BETRAYED REAR','CATCH AMISTAD') GROUP BY ac.actor_id;

SELECT ac.first_name, ac.last_name 
FROM film_actor fi_ac
INNER JOIN actor ac ON ac.actor_id = fi_ac.actor_id
INNER JOIN film f ON f.film_id = fi_ac.film_id
WHERE f.title = 'BETRAYED REAR'
AND ac.actor_id NOT IN (
    SELECT actor_id 
    FROM film_actor fa
    INNER JOIN film fi ON fi.film_id = fa.film_id
    WHERE fi.title='CATCH AMISTAD'
);

SELECT ac.first_name, ac.last_name 
FROM film_actor fi_ac
INNER JOIN actor ac ON ac.actor_id = fi_ac.actor_id
INNER JOIN film f ON f.film_id = fi_ac.film_id
WHERE f.title = 'BETRAYED REAR'
AND ac.actor_id IN (
    SELECT actor_id 
    FROM film_actor fa
    INNER JOIN film fi ON fi.film_id = fa.film_id
    WHERE fi.title='CATCH AMISTAD'
);

SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN (
  SELECT f_a.actor_id FROM film_actor f_a
  INNER JOIN film f ON f_a.film_id = f.film_id
  WHERE f.title like '%BETRAYED REAR%'
)
and a.actor_id NOT IN (
  SELECT f_a.actor_id FROM film_actor f_a
  INNER JOIN film f ON f_a.film_id = f.film_id
  WHERE f.title LIKE '%CATCH AMISTAD%'
);