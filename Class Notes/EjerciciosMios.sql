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

/**/
SELECT * FROM cuentas;
USE practica;
DROP PROCEDURE IF EXISTS transaccion;
DELIMITER $$
CREATE PROCEDURE transaccion(origen VARCHAR(20), destino VARCHAR(20), dinero DECIMAL(10, 2))
BEGIN
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SHOW ERRORS;
        SELECT * FROM cuentas;
	END;
	START TRANSACTION;
		UPDATE cuentas SET saldo = saldo - dinero WHERE codigo = origen;
        SELECT SLEEP(20);
        UPDATE cuentas SET saldo = saldo + dinero WHERE codigo = destino;
    COMMIT;
END $$
DELIMITER ;
CALL transaccion('7M', '7L', 500.23);

