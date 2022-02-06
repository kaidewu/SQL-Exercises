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

/*Hacer un procedure que tenga 3 parametros donde vamos a meterle el nombre de una base de datos, y el nombre de la tabla y cuantas tablas quieres.
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
	ELSE
		SELECT('Porfavor contacte con tu administrador!!!');
    END IF;
END $$
DELIMITER ;
CALL test ('EjTest', 'test', 3);
DROP database ejtest;

/* Crear una base de datos con una tabla donde se guardara toda la informacion de las modificaciones hechas en Alumnos2. Y se almacena quien a modificado, fecha y hora, datos antes de la modificacion y despues de la modificacion. 
CREATE TRIGGER nombre_del_treigger
	TRIGGER_TIME* TRIGGER_EVENT* ON nombre_de_tabla
    FOR EACH ROW																									INSERT[new.cosas]
		[TRIGGER_ORDER*]																							UPDATE[new.cosas y old.cosas]
	TREIGGER_BODY																									DELETE[old.cosas]
*TIME = BEDORE|AFTER
*EVENT = INSERT|UPDATE|DELETE
*ORDER = FOLLOWS|PRECEDES*/
CREATE DATABASE log_completo;
DROP TABLE log_completo.logmodificados;
CREATE TABLE log_completo.logmodificados (id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
							 usuario VARCHAR(20) NOT NULL,
                             fecha DATETIME NOT NULL,
							 dni_Antiguo VARCHAR(20),
                             nombre_Antiguo VARCHAR(50),
                             nota_Antiguo INT,
                             dni_Nuevo VARCHAR(20),
                             nombre_Nuevo VARCHAR(50),
                             nota_Nuevo INT);
USE practica;
DELIMITER $$
DROP TRIGGER IF EXISTS logModificados$$
CREATE TRIGGER logModificados AFTER UPDATE ON alumnos2 FOR EACH ROW
BEGIN
	INSERT INTO log_completo.logmodificados (usuario, fecha, dni_Antiguo, nombre_Antiguo, nota_Antiguo, dni_Nuevo, nombre_Nuevo, nota_Nuevo) VALUES (user(), now(), old.dni, old.nombre, old.nota, new.dni, new.nombre, new.nota);
END $$
DROP TRIGGER IF EXISTS logInsertados$$
CREATE TRIGGER logInsertados BEFORE INSERT ON alumnos2 FOR EACH ROW
BEGIN
	INSERT INTO log_completo.logmodificados (usuario, fecha, dni_Nuevo, nombre_Nuevo, nota_Nuevo) VALUES (user(), now(), new.dni, new.nombre, new.nota);
END $$
DROP TRIGGER IF EXISTS logElimidos$$
CREATE TRIGGER logElimidos AFTER DELETE ON alumnos2 FOR EACH ROW
BEGIN
	INSERT INTO log_completo.logmodificados (usuario, fecha, dni_Antiguo, nombre_Antiguo, nota_Antiguo) VALUES (user(), now(), old.dni, old.nombre, old.nota);
END $$
DELIMITER ;

INSERT alumnos2 VALUES ('1289374F', 'Jose', 6);
INSERT alumnos2 VALUES ('9826355G', 'Maria', 5);
INSERT alumnos2 VALUES ('H4CK34DO', 'Hacker', 1234);
UPDATE alumnos2 SET nota = 8 WHERE nombre = 'Maria';
DELETE FROM alumnos2 WHERE nota > 10;
SELECT * FROM log_completo.logmodificados;