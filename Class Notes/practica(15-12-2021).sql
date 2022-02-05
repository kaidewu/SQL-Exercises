/*
Como crear procedimientos:
*(Si usamos aqui USE database tendremos que usar ;)
DELIMITER $$
*(Si usamos aqui USE database tendremos que usar $$)
CREATE PROCEDURE procedimiento_nombre()
	BEGIN
		sentencias;
    END $$
DELIMITER; #Muy importante recuperar el DELIMITER
*/
USE clase;
DELIMITER $$
DROP PROCEDURE IF EXISTS proc1 $$
CREATE PROCEDURE proc1()
	BEGIN
		SELECT "HOLA MUNDO";
        SELECT "ADIOS";
	END $$
DELIMITER ;
CALL proc1;
/*----------------------------*/
/*
IF condicion THEN
	accion;
ELSEIF condicion THEN
	accion;
ELSE
	accion;
END IF;
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS hora $$
CREATE PROCEDURE hora()
	BEGIN
		DECLARE nombre varchar(25);
        SET @nombre = 'Juan';
		SELECT concat('Hola ', @nombre) AS Salu2;
	END $$
DELIMITER ;
call hora;
/*----------------------------*/
DELIMITER $$
DROP PROCEDURE IF EXISTS nombre $$
CREATE PROCEDURE nombre(genero varchar(2), nom varchar(20))
	BEGIN
		SELECT concat('Hola ', genero, '. ',nom) AS Salu2;
	END $$
DELIMITER ;
call nombre('Sr','Walía');
/*----------------------------*/
USE practica;
DELIMITER $$
DROP PROCEDURE IF EXISTS alumnos $$
CREATE PROCEDURE alumnos(id INT)
	BEGIN
        IF NOT EXISTS (SELECT * FROM alumnos WHERE expdte = id) THEN
			SELECT 'No exite ese expendiente';
		ELSE
			SELECT concat('El expendiente ', expdte, ' se llama ', nombre) AS Alumno FROM alumnos WHERE expdte = id;
		END IF;
	END $$
DELIMITER ;
call alumnos('100');
/*----------------------------*/
USE practica;
DELIMITER $$
DROP PROCEDURE IF EXISTS transaccion $$
CREATE PROCEDURE transaccion(cuentaSal CHAR(2), cuentaEnt CHAR(2), importe INT)
	BEGIN
		START TRANSACTION;
			UPDATE cuentas SET saldo = saldo - importe WHERE codigo = cuentaSal;
			UPDATE cuentas SET saldo = saldo + importe WHERE codigo = cuentaEnt;
            SELECT * FROM cuentas;
		COMMIT;
    END $$
DELIMITER ;
call transaccion('7M', '7L', 200);