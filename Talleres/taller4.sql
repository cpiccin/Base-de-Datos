--Parte a: Consultas de una tabla


-- 1. Devuelva todos los datos de las notas que no sean de la materia 75.1.
select * 
from notas n
where n.codigo <> 75 or n.numero <> 1
-- a condición con OR solo da FALSE cuando las dos partes son falsas al mismo tiempo, o sea cuando n.codigo <> 75 or n.numero <> 1 son falsas al mismo tiempo

-- 2. Devuelva para cada materia dos columnas: una llamada “codigo” que contenga una con-
--    catenaci ́on del c ́odigo de departamento, un punto y el n ́umero de materia, con el formato
--    “XX.YY” (ambos valores con dos d ́ıgitos, agregando ceros a la izquierda en caso de ser
--    necesario) y otra con el nombre de la materia.
SELECT 
  LPAD(CAST(codigo AS TEXT), 2, '0') || '.' || LPAD(CAST(numero AS TEXT), 2, '0') AS codigo,
  nombre
FROM materias;

--3. Para cada nota registrada, devuelva el padr ́on, c ́odigo de departamento, n ́umero de materia,
--	 fecha y nota expresada como un valor entre 1 y 100.
select padron, codigo, numero, fecha, nota*10
from notas;

--4. Idem al anterior pero mostrando los resultados paginados en p ́aginas de 5 resultados cada
--   una, devolviendo la segunda p ́agina.
select padron, codigo, numero, fecha, nota*10
from notas
offset 5 row
fetch first 5 rows only;

--5. Ejecute una consulta SQL que devuelva el padr ́on y nombre de los alumnos cuyo apellido
--   es “Molina”.
select padron, nombre, apellido
from alumnos
where apellido = 'Molina';

--6. Obtener el padr ́on de los alumnos que ingresaron a la facultad en el a ̃no 2010.
select padron
from alumnos
where extract(year from (fecha_ingreso)) = 2010;



--Parte B: Funciones de agregacion ́


--7. Obtener la mejor nota registrada en la materia 75.15.
select max(nota) as mejor_nota
from notas
where codigo = 75 and numero = 15;

--8. Obtener el promedio de notas de las materias del departamento de c ́odigo 75.
select coalesce(avg(nota),0) as Promedio_de_notas
from notas
where codigo = 75

--9. Obtener el promedio de nota de aprobaci ́on de las materias del departamento de c ́odigo 75.
select coalesce(avg(nota),0) as Promedio_de_notas
from notas
where codigo = 75 and nota >= 4

--10. Obtener la cantidad de alumnos que tienen al menos una nota.
select count(distinct padron) as Alumnos_con_nota
from notas
where nota is not null



--Parte C: Operadores de conjunto


--11. Devolver los padrones de los alumnos que no registran nota en materias.
select a.padron 
from notas n right outer join alumnos a on (n.padron = a.padron)
where n.nota is null;

	-- otra opcion: comparo la tabla de alumnos con la tabla de alumnos_con_nota y veo cual NO esta en alumnos -- 
select a.padron 
from alumnos a
where not exists(
	select 1
	from notas n
	where n.padron = a.padron
);

--12. Con el objetivo de traducir a otro idioma los nombres de materias y departamentos, devolver
--    en una  ́unica consulta los nombres de todas las materias y de todos los departamentos.
select d.nombre
from departamentos d 
union
select m.nombre
from materias m;



-- Parte D: Joins


--13. Devolver para cada materia su nombre y el nombre del departamento.
select m.nombre, d.nombre
from materias m join departamentos d on (m.codigo = d.codigo);

--14. Para cada 10 registrado, devuelva el padron y nombre del alumno y el nombre de la materia
--    correspondientes a dicha nota.
select a.padron, a.nombre, a.apellido, m.nombre
from alumnos a inner join notas n on (a.padron = n.padron)
	 inner join materias m on (n.codigo = m.codigo and n.numero = m.numero)
where n.nota = 10;

--15. Listar para cada carrera su nombre y el padr ́on de los alumnos que est ́en anotados en ella.
--    Incluir tambi ́en las carreras sin alumnos inscriptos.
select c.nombre, i.padron
from carreras c left outer join inscripto_en i on (c.codigo = i.codigo);

--16. Listar para cada carrera su nombre y el padrón de los alumnos con padrón mayor a 75000 que 
--    estén anotados en ella. Incluir también las carreras sin alumnos inscriptos con padrón mayor a 75000.
select c.nombre, ie.padron 
from carreras c left outer join inscripto_en ie on (c.codigo = ie.codigo and ie.padron > 75000);

--17. Listar el padr ́on de aquellos alumnos que tengan m ́as de una nota en la materia 75.15.
select a.padron
from alumnos a inner join notas n on (n.padron = a.padron and n.codigo = 75 and n.numero = 15)
group by a.padron 
having count(n.nota);

--18. Obtenga el padr ́on y nombre de los alumnos que aprobaron la materia 71.14 y no aprobaron
--    la materia 71.15
select a.padron, a.nombre, a.apellido
from alumnos a inner join notas n1 on (a.padron = n1.padron and n1.codigo = 71 and n1.numero = 14 and n1.nota >= 4)
     inner join notas n2 on (a.padron = n2.padron and n2.codigo = 71 and n2.numero = 15 and n2.nota < 4);

--19. Obtener, sin repeticiones, todos los pares de padrones de alumnos tales que ambos alumnos
--    rindieron la misma materia el mismo d ́ıa. Devuelva tambi ́en la fecha y el c ́odigo y n ́umero
--    de la materia
select n1.padron, n2.padron, n1.fecha, n1.codigo, n1.numero
from notas n1 inner join notas n2 on (n1.padron < n2.padron and n1.codigo = n2.codigo and n1.numero = n2.numero and n1.fecha = n2.fecha)



-- Parte E: Agrupamiento


--20. Para cada departamento, devuelva su c ́odigo, nombre, la cantidad de materias que tiene y la
--    cantidad total de notas registradas en materias del departamento. Ordene por la cantidad
--    de materias descendente.
select d.codigo, count(n.nota) as cant_notas, count(distinct m.numero) as cant_materias
from departamentos d left outer join materias m on (d.codigo = m.codigo)
     left outer join notas n on (n.codigo = m.codigo and n.numero = m.numero)
group by d.codigo, d.nombre
order by count(distinct m.numero) desc;

--21. Para cada carrera devuelva su nombre y la cantidad de alumnos inscriptos. Incluya las
--    carreras sin alumnos.
select c.nombre, count(ie.padron) as alumnos_inscriptos
from carreras c left join inscripto_en ie on (c.codigo = ie.codigo)
group by c.codigo;

--22. Para cada alumno con al menos tres notas, devuelva su padr ́on, nombre, promedio de notas
--    y mejor nota registrada.
select a.padron, a.nombre, a.apellido, avg(n.nota) as promedio, max(n.nota) mejor_nota
from alumnos a join notas n on (a.padron = n.padron)
group by a.padron 
having count(n.nota) >= 3



-- Parte F: Consultas avanzadas


--23. Obtener el c ́odigo y n ́umero de la o las materias con mayor cantidad de notas registradas.
with cant_de_notas as (select n.codigo, n.numero, count(n.nota) as cant_notas
							  from notas n
							  group by n.codigo, n.numero)
select codigo, numero
from cant_de_notas
where cant_notas = (select max(cant_notas) from cant_de_notas)

--24. Obtener el padr ́on de los alumnos que tienen nota en todas las materias.
select n.padron 
from notas n
group by n.padron
having count(distinct (n.codigo, n.numero)) = (select count(*) from materias)
-- si el motor no acepta el count(distinct(col1, col2)) uso count(distinct concat(n.codigo, '.', n.numero))

--25. Obtener el promedio general de notas por alumno (cuantas notas tiene en promedio un
--    alumno), considerando  ́unicamente alumnos con al menos una nota
with cantidad_de_notas_por_alumno as (select count(n.nota) as cant_notas
						   from notas n
						   group by n.padron)
select avg(cant_notas)
from cantidad_de_notas_por_alumno


