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
