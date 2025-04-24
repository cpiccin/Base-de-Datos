/* Aclaración: interpreté que la consigna pide 
*  	- Todos los equipos que alcanzaron el máximo de entrenadores en su periodo (pueden ser varios por periodo), ordenados por periodo y luego por nombre del equipo
*   - Si hay menos de 10 equipos en total (con ese maximo correspondiente a cada periodo), devolverá menos de 10.
*  O sea todos los equipos que en cada periodo tienen la cantidad maxima de entrenadores registrada 
*/

select c.periodocompeticion, c.nombre, c.cant_entrenadores 
from (select e.periodocompeticion, e2.nombre, count(e.identrenador) as cant_entrenadores
 	  from entrenadorparticipacompeticion e 
  	  join equipo e2 on (e.idequipo = e2.id)
	  group by e.periodocompeticion, e2.nombre) as c -- tabla con cant de entrenadores por equipo por periodo
join (select periodocompeticion, max(cant_entrenadores) as max_entrenadores
      from (select e.periodocompeticion, e2.nombre, count(e.identrenador) as cant_entrenadores
	        from entrenadorparticipacompeticion e 
	        join equipo e2 on (e.idequipo = e2.id)
	        group by e.periodocompeticion, e2.nombre) as max_entrenadores
      group by periodocompeticion) as m -- tabla con el maximo numero de entrenadores por periodo
      on (c.periodocompeticion = m.periodocompeticion and c.cant_entrenadores = m.max_entrenadores)
order by c.periodocompeticion desc, c.nombre asc
offset 0 rows fetch first 10 rows only


/*
Resultados

periodocompeticion	nombre			cant_entrenadores
2021 - 2022			Kings			2
2020 - 2021			Hawks			2
2020 - 2021			Timberwolves	2
2019 - 2020			Cavaliers		2
2019 - 2020			Knicks			2
2019 - 2020			Nets			2
2018 - 2019			Bulls			2
2018 - 2019			Cavaliers		2
2018 - 2019			Timberwolves	2
*/