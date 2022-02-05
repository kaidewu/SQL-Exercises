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
