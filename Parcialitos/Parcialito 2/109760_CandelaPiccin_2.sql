/* ACLARACION: considere los jugadores que:
 * 		- Jugaron tanto en la temporada 2018 - 2019 como en la 2020 - 2021
 * 		- No jugaron en alguna de las temporadas: (2019-2020, 2021-2022)
 */						 
						 
select jp.idjugador
from partido p join juegapartido jp on (p.id = jp.idpartido) 
where p.periodocompeticion in ('2018 - 2019', '2020 - 2021')
group by jp.idjugador
having count(distinct p.periodocompeticion) = 2 
and jp.idjugador not in (select jp.idjugador
						 from partido p join juegapartido jp on (p.id = jp.idpartido)
						 where p.periodocompeticion in ('2019 - 2020', '2021 - 2022'))		
						 
						 
/*
Resultados

idjugador					 
203263
1628387
1628959
1629053
*/