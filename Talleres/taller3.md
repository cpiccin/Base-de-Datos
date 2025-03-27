a) Mostrar los actores cuyo nombre sea Brad.

`σactors.first_name='Brad'(actors)`

b) Mostrar el nombre y apellido de directores catalogados como de 'Sci-Fi' (ciencia ficción) con una probabilidad mayor igual a 0.5.
```
GEN = σ(genre='Sci-Fi'∧prob>=0.5)(directors_genres)
DIR = GEN⨝directors.id=directors_genres.director_id directors
πfirst_name,last_name(DIR)
```

c) Mostrar los nombres de las pel ́ıculas filmadas por James(I) Cameron que figuren en la base.
```
JC = σfirst_name='James (I)'∧last_name='Cameron'(directors)
PELIS = JC⨝director_id=directors.id movies_directors
NOM = movies ⨝movies.id=movies_directors.movie_id PELIS
πname(NOM)
```

d) Mostrar los nombres y apellidos de las actrices que trabajaron en la pel ́ıcula ’Judgment at Nuremberg’
```
PEL = σname='Judgment at Nuremberg'(movies)
FEM = σgender='F'(actors)
CAST = PEL ⨝roles.movie_id=movies.id roles
ACTF = FEM ⨝actors.id=roles.actor_id CAST
πfirst_name,last_name(ACTF)
```

e) Muestre los actores que trabajaron en todas las pel ́ıculas de Woody Allen de la base. Cuantas pel ́ıculas de este director hay en la base?
```
WA = σdirectors.first_name='Woody'∧directors.last_name='Allen'(directors)
WA_MOV = WA ⨝directors.id=movies_directors.director_id movies_directors

MOV_NAME = WA_MOV ⨝movies.id=movies_directors.movie_id movies
CAST = πactor_id,movie_id(roles)
MOV_ID = πmovies.id(MOV_NAME)
ACT_ID = CAST÷MOV_ID

πfirst_name,last_name(ACT_ID ⨝actors.id=roles.actor_id actors)
```

f ) Directores que abarcaron, al menos, los mismos g ́eneros que Welles (generos en directores).
```
WELLES = σlast_name='Welles'(directors)
INFO_WELLES = WELLES ⨝directors.id=directors_genres.director_id directors_genres
GEN_WELLES = πdirectors_genres.genre(INFO_WELLES)

DIRS = πdirector_id,genre(directors_genres)

OPT = DIRS÷GEN_WELLES

πfirst_name,last_name(OPT ⨝director_id=directors.id directors)
```

g) Actores que filmaron m ́as de una pel ́ıcula en el mismo año, a partir de 1999
