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