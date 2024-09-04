USE sakila;

-- Necesita la tabla employees (definida en la sección de triggers) creada y con datos.

CREATE TABLE `employee_data` (
  `empNumber` int(11) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `givenName` varchar(50) NOT NULL,
  `phone_ext` varchar(10) NOT NULL,
  `contactEmail` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `manager_id` int(11) DEFAULT NULL,
  `position` varchar(50) NOT NULL,
  PRIMARY KEY (`empNumber`)
);

INSERT INTO `employee_data`(`empNumber`,`surname`,`givenName`,`phone_ext`,`contactEmail`,`officeCode`,`manager_id`,`position`) VALUES 
(1002,'Murphy','Diane','x5800','dmurphy@classicmodelcars.com','1',NULL,'President'),
(1056,'Patterson','Mary','x4611','mpatterson@classicmodelcars.com','1',1002,'VP Sales'),
(1076,'Firrelli','Jeff','x9273','jfirrelli@classicmodelcars.com','1',1002,'VP Marketing');

-- CONSULTA 1
-- Inserta un nuevo empleado, pero sin correo electrónico. Explica lo que sucede.

INSERT INTO `employee_data`(`empNumber`,`surname`,`givenName`,`phone_ext`,`contactEmail`,`officeCode`,`manager_id`,`position`) VALUES
(3856,'Pedro','Leche','x0486',NULL,'1','1002','HR Manager');

/*
Esta consulta devuelve la siguiente respuesta: Error Code: 1048. Column 'contactEmail' cannot be null.
Esto sucede porque, al crear la tabla employee_data, se añadió una restricción NOT NULL al campo contactEmail para evitar que se inserten valores nulos.
Al intentar hacerlo, se genera el error y los valores no son insertados.
*/

-- CONSULTA 2
-- Ejecuta la primera consulta. ¿Qué sucedió? Explica. Luego ejecuta esta otra y explícalo también.

UPDATE employee_data SET empNumber = empNumber - 20;
UPDATE employee_data SET empNumber = empNumber + 20;

/*
Al ejecutar la primera consulta, cada instancia de empNumber en employee_data se reduce en 20. Por ejemplo, los valores de los empleados insertados eran (1002, 1056, 1076)
y se convirtieron en (982, 1036, 1056) después de la consulta.
Al ejecutar la segunda consulta, se genera el siguiente error: Error Code: 1062. Duplicate entry '1056' for key 'employee_data.PRIMARY'.
Esto sucede porque cada empNumber se incrementa en el orden en que fueron declarados, y la segunda instancia de empleado se establece en 1056, que ya existe, antes de que 
el empNumber existente con ese valor sea incrementado. Dado que no pueden existir dos valores iguales de clave primaria, se genera el error.
*/

-- CONSULTA 3
-- Agrega una columna de edad a la tabla employee_data que solo acepte valores entre 16 y 70 años.

ALTER TABLE employee_data ADD COLUMN age INT(3) CONSTRAINT CHECK (age >= 16 AND age <= 70);

-- CONSULTA 4
-- Describe la integridad referencial entre las tablas film, actor y film_actor en la base de datos sakila.

/*
Las tablas film y actor existen de manera independiente, cada una con su propia ID (film_id y actor_id respectivamente). 
Dado que una película puede tener múltiples actores y un actor puede aparecer en múltiples películas, se debería establecer una relación de muchos a muchos para conectarlas, 
pero esto no se recomienda debido a su complejidad.

En su lugar, se crea una tabla de detalle (también conocida como tabla intermedia) para conectarlas, que en este caso es la tabla film_actor. 
La tabla film_actor utiliza dos claves foráneas: una que referencia film_id de la tabla film y otra que referencia actor_id de la tabla actor. 
Estas claves foráneas deben hacer referencia a un registro existente y válido en sus respectivas tablas. Ambas claves juntas forman una clave primaria compuesta, 
que garantiza que cada entrada en film_actor sea única.
*/

-- CONSULTA 5
-- Crea una nueva columna llamada lastModified en la tabla employee_data y usa trigger(s) para mantener la fecha y hora actualizadas en las operaciones de inserción y actualización. 
-- Bonus: agrega una columna lastUpdatedByUser y el respectivo trigger(s) para especificar quién fue el último usuario de MySQL que cambió la fila 
-- (supón que varios usuarios, además de root, pueden conectarse a MySQL y cambiar esta tabla).

ALTER TABLE employee_data ADD COLUMN lastModified DATETIME, ADD COLUMN lastUpdatedByUser VARCHAR(100);
CREATE TRIGGER before_employee_data_update BEFORE UPDATE ON employee_data FOR EACH ROW 
SET NEW.lastModified = NOW(), NEW.lastUpdatedByUser = USER();

-- CONSULTA 6
-- Encuentra todos los triggers en la base de datos sakila relacionados con la carga de la tabla film_text. ¿Qué hacen? Explica cada uno de ellos usando su código fuente para la explicación.

/*
La tabla film_text tiene 3 triggers relacionados con su carga:

CREATE TRIGGER `ins_film` AFTER INSERT ON `film` FOR EACH ROW BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
  END;;

Este trigger realiza una inserción en la tabla film_text después de que se crea una película, tomando los valores de la película recién creada
para sus campos. Esto significa que después de que se inserta una película, los valores de su film_id, title y description también se usan para crear
una inserción en film_text. 

CREATE TRIGGER `upd_film` AFTER UPDATE ON `film` FOR EACH ROW BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
  END;;

*/
