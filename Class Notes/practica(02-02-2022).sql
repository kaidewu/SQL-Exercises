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