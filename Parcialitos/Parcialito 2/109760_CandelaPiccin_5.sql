/* Aclaracion: ya que pide **la fecha del partido** interpreté que pide los equipos que en todo 
 * el año 2018 tuvieron la menor cantidad de puntos como local en algun partido
 */

select p.fecha, e.nombre, p.puntoslocal
from partido p join equipo e on (p.idequipolocal = e.id)
where extract(year from (p.fecha)) = 2018
and p.puntoslocal = (select MIN(p.puntoslocal)
					 from partido p 
				     where extract(year from (p.fecha)) = 2018)	
				     
/*
Resultados

fecha	    mombre  puntoslocal
2018-12-08	Bulls	77
*/
				     