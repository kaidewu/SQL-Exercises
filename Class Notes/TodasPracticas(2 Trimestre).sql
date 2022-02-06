/*Practica 01/12/2021*/
/*----------------------------*/
set @expdte = 115;
select nombre into @nombre from alumnos where expdte = @expdte;
select @nombre;
/*----------------------------*/
select nombre into @nombre from alumnos where expdte != 115;
select @nombre;
/*----------------------------*/
set @expdte = 125;
select lower(nombre), lower(apellidos) into @nombre, @apellidos from alumnos where expdte = @expdte;
select concat('El alumno ', @nombre, ' ', @apellidos, ' tiene el expendiente ', @expdte) as Alumno;
/*----------------------------*/
set @email = 'protonmail.com';
set @post = instr(@email, '.com');
set @servidor = left(@email, @post - 1);
select concat('El servidor es ', @servidor);
/*----------------------------*/
set @usu = 'usua1@192.168.1.10';
set @usuario = instr(@usu, '@');
set @us = length(@usu) - @usuario;
set @users = left(@usu, @usuario - 1);
set @host = right(@usu, @us);
select @users, @host;
/*----------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------*/
/*Practica 15/12/2021*/
/*
Como crear procedimientos:
*(Si usamos aqui USE database tendremos que usar ';')
DELIMITER $$
*(Si usamos aqui USE database tendremos que usar '$$')
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
/*----------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------*/
/*Practica 12/01/2022*/
/*Cuenta origen exista al igual el de destino y que los dos tenga dinero*/
USE practica;
DELIMITER $$
DROP PROCEDURE IF EXISTS transaccion $$
CREATE PROCEDURE transaccion (origen VARCHAR(25), destino VARCHAR(25), dinero INT)
	BEGIN
		IF NOT EXISTS (SELECT * FROM cuentas WHERE codigo = origen) THEN
			SELECT 'No existe la cuenta origen';
		ELSEIF NOT EXISTS (SELECT * FROM cuentas WHERE codigo = detino) THEN
			SELECT 'No existe la cuenta destino';
		ELSE
			IF (SELECT saldo FROM cuentas WHERE codigo = origen) != 0 THEN
				IF dinero <= (SELECT saldo FROM cuentas WHERE codigo = origen) THEN
					START TRANSACTION;
						UPDATE cuentas SET saldo = saldo - dinero WHERE codigo = origen;
						UPDATE cuentas SET saldo = saldo + dinero WHERE codigo = destino;
						SELECT * FROM cuentas;
					COMMIT;
				ELSE 
					SELECT 'No puedes pasar más dinero de lo que hay en la cuenta' as 'Error !';
				END IF;
			ELSE 
				SELECT 'La cuenta origen no tiene suficiente saldo' as 'ERROR!';
			END IF;
		END IF;
    END $$
DELIMITER ;

call transaccion('7M', '7L', 1000);
/*---------------------------------------------------------------------------------------*/

/*Bucles*/
/*REPEAT accion UNTIL condicion END REPEAT*/
/*WHILE condicion DO accion END WHILE*/
DELIMITER $$
DROP PROCEDURE IF EXISTS numero $$
CREATE PROCEDURE numero()
	BEGIN
		DECLARE x INT DEFAULT(1);
        DECLARE resultado VARCHAR(50);
        SET resultado = 1;
		WHILE x < 5 DO 
			SET x = x + 1;
            SET resultado = concat(resultado, ', ', x);
		END WHILE;
        SELECT resultado;
    END $$
DELIMITER ;
call numero();
/*---------------------------------------------------------------------------------------*/
DELIMITER $$
DROP PROCEDURE IF EXISTS listanum $$
CREATE PROCEDURE listanum(primero INT, segundo INT)
	BEGIN
        DECLARE resultado LONGTEXT;
        SET resultado = primero;
		WHILE primero < segundo DO
			SET primero = primero + 1;
            SET resultado = concat(resultado, ', ', primero);
		END WHILE;
        SELECT resultado;
    END $$
DELIMITER ;
call listanum();
/*---------------------------------------------------------------------------------------*/
DELIMITER $$
DROP PROCEDURE IF EXISTS sumar $$
CREATE PROCEDURE sumar()
	BEGIN
		DECLARE num INT DEFAULT(0);
        DECLARE total INT;
        SET total= 0;
		WHILE num < 10 DO
			SET num = num + 1;
			SET total = total + num;
		END WHILE;
        SELECT total;
    END $$
DELIMITER ;
call sumar();
/*---------------------------------------------------------------------------------------*/
DELIMITER $$
DROP PROCEDURE IF EXISTS sumaNum $$
CREATE PROCEDURE sumaNum(Xnum INT)
	BEGIN
		DECLARE num INT DEFAULT(0);
        DECLARE total INT;
        SET total= 0;
		WHILE num < Xnum DO
			SET num = num + 1;
			SET total = total + num;
		END WHILE;
        SELECT total;
    END $$
DELIMITER ;
call sumaNum();
/*---------------------------------------------------------------------------------------*/
DELIMITER $$
DROP PROCEDURE IF EXISTS multiplode5 $$
CREATE PROCEDURE multiplode5()
	BEGIN
		DECLARE num INT DEFAULT(5);
        DECLARE contador INT DEFAULT(1);
        DECLARE total LONGTEXT;
        SET total = num;
		WHILE contador < 10 DO
			SET contador = contador + 1;
			SET num = contador * 5;
			SET total = concat(total, ', ', num);
		END WHILE;
        SELECT total;
    END $$
DELIMITER ;
call multiplode5();
/*---------------------------------------------------------------------------------------*/
USE practica;
DELIMITER $$
DROP PROCEDURE IF EXISTS contadortablas $$
CREATE PROCEDURE contadortablas(nombretabla VARCHAR(50))
	BEGIN
		SELECT table_rows FROM information_schema.tables WHERE table_rows = nombretabla;
    END $$
DELIMITER ;
call contadortablas('alumnos');
/*----------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------*/
/*Practica 19/01/2022*/
USE practica;
DELIMITER $$
DROP PROCEDURE IF EXISTS contadortablas $$
CREATE PROCEDURE contadortablas(nombretabla VARCHAR(50))
	BEGIN
        SET @contador = CONCAT('SELECT CONCAT(''LA TABLA ',UPPER(nombretabla),' TIENE '',count(*), '' FILAS.'') as CuentaFilas FROM ', nombretabla, ';');
        PREPARE state FROM @contador;
        EXECUTE state;
        DEALLOCATE PREPARE state;
    END $$
DELIMITER ;
call contadortablas('alumnos');
/*---------------------------------------------------------------------------------------*/
USE practica;
DELIMITER $$
DROP PROCEDURE IF EXISTS contadortablas $$
CREATE PROCEDURE contadortablas(nombretabla VARCHAR(50))
	BEGIN
        SET @contador = CONCAT('SELECT count(*) INTO @count FROM ', nombretabla, ';');
        PREPARE state FROM @contador;
        EXECUTE state;
        DEALLOCATE PREPARE state;
        SELECT CONCAT('LA TABLA ',UPPER(nombretabla),' TIENE ',@count,' FILAS.') as '';
    END $$
DELIMITER ;
call contadortablas('alumnos');
/*---------------------------------------------------------------------------------------*/
/*Cuenta origen exista al igual el de destino y que los dos tenga dinero*/
USE practica;
DELIMITER $$
DROP PROCEDURE IF EXISTS transaccion $$
CREATE PROCEDURE transaccion (origen VARCHAR(25), destino VARCHAR(25), dinero INT)
	BEGIN
		START TRANSACTION;
			UPDATE cuentas SET saldo = saldo - dinero WHERE codigo = origen;
            INSERT INTO cuentas VALUES('7L', 1000);
			UPDATE cuentas SET saldo = saldo + dinero WHERE codigo = destino;
		COMMIT;
    END $$
DELIMITER ;

call transaccion('7L', '7M', 100);
/*Controlador de Errores*/
/*DECLARE handler_accion:continue or exit HANDLER
		FOR condicion[condicion1,...]:SQLWARNING, NOT FOUND, SQLEXCEPTION,...
        accion:Varias acciones o una accion;*/
USE practica;
DELIMITER $$
DROP PROCEDURE IF EXISTS transaccion $$
CREATE PROCEDURE transaccion (origen VARCHAR(25), destino VARCHAR(25), dinero INT)
	BEGIN
		DECLARE EXIT HANDLER 
			FOR SQLEXCEPTION
				BEGIN
					SHOW ERRORS;
					ROLLBACK;
				END;
		START TRANSACTION;
			UPDATE cuentas SET saldo = saldo - dinero WHERE codigo = origen;
            INSERT INTO cuentas VALUES('7L', 1000);
			UPDATE cuentas SET saldo = saldo + dinero WHERE codigo = destino;
		COMMIT;
    END $$
DELIMITER ;
select * from cuentas;
call transaccion('7L', '7M', 100);
/*Procediemiento pasar un nombre de usuario con formato "usuario@maquina" "contraseña". 
Si no existe el usuario que cree el usuario, si existe el usuario existe que le cambie la contraseña.*/
USE mysql;
DELIMITER $$
DROP PROCEDURE IF EXISTS buscarusuario $$
CREATE PROCEDURE buscarusuario (usuario VARCHAR(50), contrasena VARCHAR(50))
	BEGIN
        SET @usu = instr(usuario, '@');
        SET @usua = left(usuario, @usu - 1);
        SET @NumUsuario = length(usuario);
        SET @NumHost = @NumUsuario - @usu;
        SET @_host = right(usuario, @NumHost);
        IF NOT EXISTS (SELECT user, host FROM mysql.user WHERE user = @usua and host = @_host) THEN
			SET @usersql = CONCAT('CREATE USER ''', @usua,'''@''',@_host, ''' IDENTIFIED BY ''', contrasena);
			PREPARE comando FROM @usersql;
			EXECUTE comando;
		ELSE
			SET @usersql = CONCAT('ALTER USER ', @usua,'@',@_host, ''' IDENTIFIED BY ''', contrasena);
			PREPARE comando FROM @usersql;
			EXECUTE comando;
        END IF;
    END $$
DELIMITER ;
call buscarusuario ('usua1@localhost', 'Ba66age');
/*----------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------*/
/*Practica 26/01/2022*/
/*Triggers
CREATE TRIGGER nombre_del_treigger
	TRIGGER_TIME* TRIGGER_EVENT* ON nombre_de_tabla
    FOR EACH ROW																									INSERT[new.cosas]
		[TRIGGER_ORDER*]																							UPDATE[new.cosas y old.cosas]
	TREIGGER_BODY																									DELETE[old.cosas]
*TIME = BEDORE|AFTER
*EVENT = INSERT|UPDATE|DELETE
*ORDER = FOLLOWS|PRECEDES*/
USE practica;
DELIMITER $$
DROP TRIGGER IF EXISTS notas_i $$
CREATE TRIGGER notas_i BEFORE INSERT ON alumnos2 FOR EACH ROW
	BEGIN
		IF new.nota > 10 THEN
			SET new.nota = 10;
		ELSEIF new.nota < 0 THEN
			SET new.nota = 0;
		END IF;
    END $$
DELIMITER ;

/*Lo mismo con lo anterior pero con UPDATE*/
USE practica;
DELIMITER $$
DROP TRIGGER IF EXISTS notas_i $$
CREATE TRIGGER notas_i BEFORE UPDATE ON alumnos2 FOR EACH ROW
	BEGIN
		IF new.nota < old.nota THEN
			SET new.nota = old.nota;
		END IF;
    END $$
DELIMITER ;

/*Hacer una papelera de alumnos*/
USE practica;
DROP TABLE IF EXISTS log_borrados;
CREATE TABLE IF NOT EXISTS log_borrados(
		orden INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
        dni VARCHAR(20) NOT NULL,
        nombre VARCHAR(50) NOT NULL,
        nota INT NOT NULL,
        fecha DATE,
        hora TIME,
        usua VARCHAR(20));
DELIMITER $$
DROP TRIGGER IF EXISTS papelera $$
CREATE TRIGGER papelera AFTER DELETE ON alumnos2 FOR EACH ROW
	BEGIN
		INSERT INTO log_borrados (dni, nombre, nota, fecha, hora, usua) VALUES (old.dni, old.nombre, old.nota, current_date(), curtime(), user()); 
    END $$
DELIMITER ;
/*----------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------*/
/*Practica 02/02/2022*/
/*CREATE [UNIQUE] INDEX nombre oN nombretabla*/
show index from empleados;
select count(*) from empleados where nombre = 'Carlos';
CREATE INDEX I_EMPLEADOS ON empleados(nombre);
SHOW INDEX FROM empleados;
/*No fuciona este comando*/
CREATE UNIQUE INDEX I_EMPLEADOS ON empleados(nombre);
/*Borrar un indice*/
DROP INDEX I_EMPLEADOS ON empleados;

/*PLan de ejecucion*/
EXPLAIN SELECT * FROM empleados WHERE nombre = 11000;
EXPLAIN SELECT * FROM empleados WHERE apellidos = 'García';
SHOW WARNINGS;

SELECT * FROM empleados IGNORE INDEX(I_EMPLEADOS);

/*Procedimiento sacar por pantalla los atributos que me pasen con parametros*/
DELIMITER $$
DROP PROCEDURE IF EXISTS mostrar$$
CREATE PROCEDURE mostrar(var1 VARCHAR(20), var2 VARCHAR(20))
BEGIN
	SET @comando = CONCAT('SELECT ', var1, ', ', var2, ' FROM alumnos;');
	PREPARE ejecucion FROM @comando;
    EXECUTE ejecucion;
    DEALLOCATE PREPARE ejecucion;
END$$
DELIMITER ;
CALL mostrar('nombre', 'nick');

/*Controlador de Error*/
DELIMITER $$
DROP PROCEDURE IF EXISTS error$$
CREATE PROCEDURE error()
BEGIN
	DECLARE CONTINUE HANDLER 
		FOR SQLEXCEPTION
			SHOW ERRORS;
	SELECT pepe FROM alumnos;
END$$
DELIMITER ;
CALL error();
/*----------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------------------------------------*/
/*EjercicioUsuario*/
/*Procediemiento pasar un nombre de usuario con formato "usuario@maquina" "contraseña". 
Si no existe el usuario que cree el usuario, si existe el usuario existe que le cambie la contraseña.*/
USE mysql;
DELIMITER $$
DROP PROCEDURE IF EXISTS buscarusuario $$
CREATE PROCEDURE buscarusuario (usuario VARCHAR(50), contrasena VARCHAR(50))
	BEGIN
        SET @usu = instr(usuario, '@');
        SET @usua = left(usuario, @usu - 1);
        SET @NumUsuario = length(usuario);
        SET @NumHost = @NumUsuario - @usu;
        SET @_host = right(usuario, @NumHost);
        IF NOT EXISTS (SELECT user, host FROM mysql.user WHERE user = @usua and host = @_host) THEN
			SET @usersql = CONCAT('CREATE USER ', @usua,'@',@_host, ' IDENTIFIED BY ', contrasena);
			PREPARE comando FROM @usersql;
			EXECUTE comando;
		ELSE
			SET @usersql = CONCAT('ALTER USER ', @usua,'@',@_host, ' IDENTIFIED BY ', contrasena);
			PREPARE comando FROM @usersql;
			EXECUTE comando;
        END IF;
    END $$
DELIMITER ;
call buscarusuario ('usua1@localhost', 'Ba66age');