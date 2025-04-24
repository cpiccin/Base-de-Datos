select p.id, p.nombre, p.apellido, j.estatura
from juegapartido jp
join jugador j on (jp.idjugador = j.idpersona)
join persona p on (j.idpersona = p.id)
group by jp.idjugador, p.id, j.idpersona 
having sum(jp.puntos) > 150 and avg(jp.asistencias) >= 8

/*
Resultados

id		nombre  apellido 	estatura
1629027	Trae	Young		185.42
201935	James	Harden	 	195.58
201566	Russell	Westbrook	190.50
*/
