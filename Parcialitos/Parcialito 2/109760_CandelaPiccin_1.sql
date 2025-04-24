select p.apellido, p.nombre, avg(jp.porcentajetiroscampo) as Promedio_tiros_campo
from juegapartido jp 
	join jugador j on (jp.idjugador = j.idpersona)
	join persona p on (j.idpersona = p.id)
where jp.idjugador not in (select idjugador
						   from juegapartido jp
						   where jp.porcentajetiroscampo <= 0.3)	
group by p.id


/*
Resultados

apellido 	nombre  promedio_tiros_campo
Booth		Phil	0.41000000000000000000
Pargo		Jeremy	0.48333333333333333333
Rodriguez	Angel	0.50000000000000000000
Brown		Bryce	0.33000000000000000000
Ford		Jordan	0.50000000000000000000
/*
