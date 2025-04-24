/* Aclaracion: considere que pide aquellos premios que incluyen al equipo o sea los premios colectivos,
 * no los premios de desempeño individual (premioindividual) porque no me parecio que tenga 
 * sentido adjudicarle a un equipo entero un premio individual
 */

select count(distinct pc.nombrepremio) as cant_premios, e.id as id_equipo, e.nombre as nombre_equipo
from premiocolectivo pc join equipo e on (e.id = pc.idequipo)
group by pc.idequipo, e.id
having count(distinct pc.nombrepremio) = (select count(distinct pc2.nombrepremio)
										  from premiocolectivo pc2)


/*
Resultados

cant_premios  id_equipo	  nombre_equipo
3			  1610612744  Warriors
*/