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
