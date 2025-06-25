## Nota: 8

### MongoDB (5/5)
Ejercicio 1
- Perfecto.
Ejercicio 2
- Perfecto.

### Neo4j (3/5)
Ejercicio 3
- Pudo haber ocurrido un gol en tiempo añadido (90+2) (minute_regulation=90, minute_stoppage=2) que sigue siendo del segundo tiempo.

Lo considero bien, la consulta está bien escrita.

Ejercicio 4

- La consulta pedía "Obtener, para cada mundial, los máximos goleadores."

- Se puede hacer esta consulta con la función collect, pero se vuelve un poco más enrevesada. Habría que pedir que todas las tuplas en el collect sean aquellas que son el valor máximo para dicho mundial.

- La manera más natural de hacer esta consulta es:
  1. Buscar para c/mundial el máximo de goles convertidos por un jugador (agrupar por WC, Player, COUNT(Goles) => agrupar esto por WC, MAX(count) => Buscar qué jugadores hicieron esa cantidad de goles en dicho mundial haciendo un nuevo MATCH.
  2. Buscar c/mundial los goles que hicieron los jugadores y pedir en una condición que no exista un jugador que haya hecho más goles (en ese mundial) que el que tenés.

- Hay una tercera alternativa que es con collect, buscar el listado de jugadores que hizo X cantidad de goles, ordenar por cantidad de goles, quedarte con el primer listado y hacer un UNWIND de esos jugadores para devolerlos.
