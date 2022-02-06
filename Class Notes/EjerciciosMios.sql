/*SET @url = 'https://www.google.es/';
SELECT instr(@url, '/') INTO @posicion;
First way
SET @dominio1 = right(@url, length(@url) - @posicion - 1);
SELECT substring(@url, 9, length(@url) - 6);
Or Second way
SELECT substring_index('https://www.google.es/', '/', -2);*/

/*
USE practica;
DELIMITER $$
DROP PROCEDURE IF EXISTS exercise $$
CREATE PROCEDURE exercise()
BEGIN
    SELECT user(), current_date();
END $$
DELIMITER ;
CALL exercise();*/

/*Contador de un numero hasta otro numero
USE practica;
DELIMITER $$
DROP PROCEDURE IF EXISTS contador $$
CREATE PROCEDURE contador(num1 INT, num2 INT)
BEGIN
    DECLARE total LONGTEXT;
    DECLARE contador INT DEFAULT(num1);
    SET total = num1;
    WHILE contador < num2 DO
		SET contador = contador + 1;
		SET total = concat(total, ', ', contador);
	END WHILE;
    SELECT total;
END $$
DELIMITER ;
CALL contador(10, 15);*/

/*Escribe el nombre de la tabla y te dice cuanto filas tiene: 
USE practica;
DELIMITER $$
DROP PROCEDURE IF EXISTS contadortablas $$
CREATE PROCEDURE contadortablas(nombretabla VARCHAR(20))
BEGIN
	SELECT CONCAT('La tabla ', nombretabla, ' tiene ', table_rows) AS 'Numero de Filas' FROM information_schema.tables WHERE table_name = nombretabla;
END $$
DELIMITER ;
CALL contadortablas('salarios');
----------------------------------------------------------------------------------------------
Otro forma de hacer este ejercicio
USE practica;
DELIMITER $$
DROP PROCEDURE IF EXISTS contadortablas $$
CREATE PROCEDURE contadortablas(nombretabla VARCHAR(20))
BEGIN
    SET @numtablas = CONCAT('SELECT COUNT(*) INTO @tablas FROM practica.', nombretabla,';');
    PREPARE ejecucion FROM @numtablas;
    EXECUTE ejecucion;
    DEALLOCATE PREPARE ejecucion;
    SELECT CONCAT('LA TABLA ',UPPER(nombretabla), ' TIENE ',@tablas, ' FILAS.');
END $$
DELIMITER ;
CALL contadortablas('salarios');*/

/* Ejercicio de Transaccion
USE practica;
DELIMITER $$
DROP PROCEDURE IF EXISTS ejTrans $$
CREATE PROCEDURE ejTrans (origen VARCHAR(20), destino VARCHAR(20), dinero DECIMAL(5,2))
BEGIN
	DECLARE EXIT HANDLER
		FOR SQLEXCEPTION
			BEGIN
				SHOW ERRORS;
				ROLLBACK;
			END;
	START TRANSACTION;
		UPDATE cuentas SET saldo = saldo - dinero WHERE codigo = origen;
        KILL [numero del proceso];
        UPDATE cuentas SET saldo = saldo + dinero WHERE codigo = destino;
    COMMIT;
    SELECT * FROM cuentas;
END $$
DELIMITER ;
show full processlist; Para ver que procesos hay en ese momento
CALL ejTrans('7L', '7M', 300);*/

/*Hacer un procedure que tenga 4 parametros donde vamos a meterle el nombre de una base de datos, y los nombres  de las tablas.
Tenemos que crear esa base de datos si existe, si no tenemos que anadir las tablas en la base de datos. 
Si somos root que nos deje crear todo lo anterior pero si no somos root que nos salga un mensaje de que no podemos crear nada*/
USE practica;
DELIMITER $$
DROP PROCEDURE IF EXISTS test $$
CREATE PROCEDURE test (nameDB VARCHAR(20), tabla VARCHAR(20), numTablas INT)
BEGIN
	DECLARE usuario VARCHAR(20);
    DECLARE contador INT DEFAULT(0);
    DECLARE nomT VARCHAR(20);
    SET usuario = SUBSTRING_INDEX(user(), '@', 1);
    IF (SELECT user FROM mysql.user WHERE user = 'root') = usuario THEN
		IF NOT EXISTS (SELECT schema_name FROM information_schema.schemata WHERE schema_name = nameDB) THEN
			SET @nombreDB = CONCAT('CREATE DATABASE ', nameDB,';');
            PREPARE ejecucion FROM @nombreDB;
            EXECUTE ejecucion;
            DEALLOCATE PREPARE ejecucion;
            WHILE contador < numTablas DO
				SET contador = contador + 1;
				SET nomT = CONCAT(tabla, contador);
				SET @nombreTabla = CONCAT('CREATE TABLE ', nameDB,'.', nomT, ' (id INT, nombre VARCHAR(20));');
				PREPARE ejecucion FROM @nombreTabla;
                EXECUTE ejecucion;
                DEALLOCATE PREPARE ejecucion;
            END WHILE;
		ELSE
			WHILE contador < numTablas DO
				SET contador = contador + 1;
				SET nomT = CONCAT(tabla, contador);
				IF NOT EXISTS (SELECT table_name FROM information_schema.tables WHERE table_schema = nameDB AND table_name = nomT) THEN
					SET @nombreTabla = CONCAT('CREATE TABLE ', nameDB,'.', nomT, ' (id INT, nombre VARCHAR(20));');
					PREPARE ejecucion FROM @nombreTabla;
					EXECUTE ejecucion;
					DEALLOCATE PREPARE ejecucion;
				END IF;
            END WHILE;
		END IF;
    END IF;
END $$
DELIMITER ;
CALL test ('EjTest', 'test', 3);
DROP database ejtest;

/*Trigger de cuando no seas root que te diga un mensaje de que te de los permisos necesarios o que lo haga el root.*/
