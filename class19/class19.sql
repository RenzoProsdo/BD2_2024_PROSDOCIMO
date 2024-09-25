CREATE USER analyst_data@'%' IDENTIFIED BY 'password123';

GRANT SELECT, DELETE, UPDATE ON sakila.* TO 'analyst_data'@'%';

CREATE TABLE IF NOT EXISTS test_table(
    test_id INT AUTO_INCREMENT PRIMARY KEY,
    test_name VARCHAR(255)
);
/*
ERROR 1142 (42000): CREATE command denied to user 'analyst_data'@'localhost' for table 'test_table'
*/

UPDATE film SET title = 'La naranja mecanica' WHERE film_id = 421;

REVOKE UPDATE ON sakila.* FROM 'analyst_data'@'%';

/*
ERROR 1142 (42000): UPDATE command denied to user 'analyst_data'@'localhost' for table 'film'
*/
