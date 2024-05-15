SELECT co.country, count(*) AS amount_cities FROM city ci
INNER JOIN country co ON co.country_id = ci.country_id
GROUP BY co.country_id
ORDER BY co.country, co.country_id;

SELECT co.country, count(*) AS amount_cities FROM city ci
INNER JOIN country co ON co.country_id = ci.country_id
GROUP BY co.country_id
HAVING 5<amount_cities
ORDER BY amount_cities DESC;

SELECT first_name,last_name,a.*, 
(SELECT count(*) FROM rental r WHERE r.customer_id=c.customer_id) AS total_films_rented, 
(SELECT sum(amount) FROM payment p WHERE p.customer_id=c.customer_id) AS total_money_spent 
FROM customer c
INNER JOIN ADDRESS a ON c.address_id=a.address_id
ORDER BY total_money_spent DESC; 

SELECT c.name,avg(length) AS average_duration FROM category c
INNER JOIN film_category fc ON fc.category_id= c.category_id
INNER JOIN film f ON f.film_id=fc.film_id
GROUP BY c.name
ORDER BY average_duration DESC;

SELECT rating, concat(sum(p.amount), ' USD') AS sales FROM film f
INNER JOIN inventory i ON i.film_id = f.film_id
INNER JOIN rental r ON r.inventory_id= i.inventory_id
INNER JOIN payment p ON r.rental_id= p.rental_id
GROUP BY rating
ORDER BY sales DESC;