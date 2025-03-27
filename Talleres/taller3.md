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
```
PEL1999 = σyear>=1999(movies)
CAST1999 = PEL1999 ⨝roles.movie_id=movies.id roles

R1 = ρR1(πroles.actor_id,movies.name,movies.year(CAST1999))
R2 = ρR2(πroles.actor_id,movies.name,movies.year(CAST1999))

/* todas las posibles combinaciones entre peliculas, anios y actores: AUTOJOIN*/
COMP = R1 ⨝(R1.actor_id=R2.actor_id) R2
/*filtra para que el actor_id se el mismo, el anio tambien y que el nombre de la peli sea distinto*/
REQ_ACTORS = σ(R1.year=R2.year∧R1.actor_id=R2.actor_id∧R1.name<R2.name)(COMP)

INFO_ACT = REQ_ACTORS ⨝R1.actor_id=actors.id actors

πfirst_name,last_name(INFO_ACT)
```

h) Listar las pel ́ıculas del  ́ultimo a ̃no.
```

R1 = ρR1(movies)
R2 = ρR2(movies)

/*cada película "más nueva" (de R1) se relaciona con todas las películas "más antiguas" (de R2).*/
COMP = R1 ⨝(R1.year>R2.year) R2

/*al restar las películas de R2 de todas las películas, se obtienen las del año más reciente.*/
πname,year(movies) - πR2.name,R2.year(COMP)
```

i) Pel ́ıculas del director Spielberg en las que actu ́o Harrison (I) Ford.
```
/* i) Pel ́ıculas del director Spielberg en las que actu ́o Harrison (I) Ford.*/
HF = σactors.first_name='Harrison (I)'∧actors.last_name='Ford'(actors)
SS = σdirectors.last_name='Spielberg'(directors)

SS_M = SS ⨝directors.id=movies_directors.director_id movies_directors

HF_M = HF ⨝roles.actor_id=actors.id roles

PELIS = πmovie_id(SS_M) ⨝movies_directors.movie_id=roles.movie_id πmovie_id(HF_M)

NOMBRES = movies ⨝movies.id=movies_directors.movie_id PELIS
πname(NOMBRES)
```

j) Pel ́ıculas del director Spielberg en las que no actu ́o Harrison (I) Ford.
```
/* j) Pel ́ıculas del director Spielberg en las que no actu ́o Harrison (I) Ford.*/
HF = σactors.first_name='Harrison (I)'∧actors.last_name='Ford'(actors)
SS = σdirectors.last_name='Spielberg'(directors)

SS_M = SS ⨝directors.id=movies_directors.director_id movies_directors

HF_M = HF ⨝roles.actor_id=actors.id roles

PELIS = πmovie_id(SS_M) - πmovie_id(HF_M)

NOMBRES = movies ⨝movies.id=movies_directors.movie_id PELIS
πname(NOMBRES)
```

k) Pel ́ıculas en las que actu ́o Harrison (I) Ford que no dirigi ́o Spielberg.
```
HF = σactors.first_name='Harrison (I)'∧actors.last_name='Ford'(actors)
SS = σdirectors.last_name='Spielberg'(directors)

HF_M = HF ⨝roles.actor_id=actors.id roles

PELIS_NSS = movies_directors ⨝directors.id<>movies_directors.director_id SS

CAST = roles ⨝actors.id=roles.actor_id HF

DIF = PELIS_NSS ⨝roles.movie_id=movies_directors.movie_id CAST

πname(DIF ⨝roles.movie_id=movies.id movies)
```

l) Directores que filmaron pel ́ıculas de m ́as de tres g ́eneros distintos, uno de los cuales sea
’Film-Noir’.
```
/*l) Directores que filmaron pel ́ıculas de m ́as de tres g ́eneros distintos, uno de los cuales sea ’Film-Noir’..*/

DIR_FN = ρDIR_FN(σgenre='Film-Noir'(directors_genres))
/* todas las pelis de aquellos que tienen alguna en Film-Noir*/
ALL_GENRES = directors_genres ⨝directors_genres.director_id=DIR_FN.director_id DIR_FN
UNIQUE_GEN = πdirectors_genres.director_id,directors_genres.genre(ALL_GENRES)

πfirst_name,last_name(UNIQUE_GEN ⨝directors_genres.director_id=directors.id directors)
CONTINUA
```
