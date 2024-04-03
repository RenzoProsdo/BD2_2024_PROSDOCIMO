CREATE DATABASE IF NOT EXISTS BDclase2;
USE BDclase2;
CREATE TABLE IF NOT EXISTS film (
    film_id INT NOT NULL AUTO_INCREMENT,
    title VARCHAR(255),
    description TEXT,
    release_year INT,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT film_id_pk PRIMARY KEY (film_id)
);


CREATE TABLE IF NOT EXISTS actor (
    actor_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT actor_id_pk PRIMARY KEY (actor_id)
);


CREATE TABLE film_actor (
    actor_id INT NOT NULL,
    film_id INT NOT NULL,

    CONSTRAINT film_actor_pk PRIMARY KEY (actor_id, film_id), 
    CONSTRAINT film_actor_actor_fk FOREIGN KEY (actor_id) REFERENCES actor (actor_id),
    CONSTRAINT film_actor_film_fk FOREIGN KEY (film_id) REFERENCES film (film_id)
);


INSERT INTO film (title, description, release_year) VALUES
('Origen', 'Un ladrón que entra en los sueños de otros para robar sus secretos de su subconsciente.', 2010),
('Cadena perpetua', 'Dos hombres encarcelados establecen un vínculo a lo largo de varios años, encontrando consuelo y eventual redención a través de actos de decencia común.', 1994),
('El Caballero de la Noche', 'Cuando la amenaza conocida como el Joker siembra el caos en la gente de Gotham, Batman debe aceptar una de las pruebas psicológicas y físicas más grandes de su capacidad para luchar contra la injusticia.', 2008);


INSERT INTO actor (first_name, last_name) VALUES
('Leonardo', 'DiCaprio'),
('Morgan', 'Freeman'),
('Christian', 'Bale');


INSERT INTO film_actor (actor_id, film_id) VALUES
(1, 1),
(2, 2),
(3, 3);
