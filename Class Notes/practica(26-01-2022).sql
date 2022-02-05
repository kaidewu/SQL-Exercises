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