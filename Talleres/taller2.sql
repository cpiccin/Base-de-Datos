/*
* Taller II: Restricciones de Integridad en SQL
*/


-- creo tabla de teams con team como PK
CREATE TABLE teams (
    team VARCHAR(20) constraint pk_teams primary key,
    players_used INT NOT NULL,
    avg_age FLOAT NOT NULL,
    possession FLOAT NOT NULL,
    games INT NOT NULL,
    goals INT NOT NULL,
    assists INT NOT NULL,
    cards_yellow INT NOT NULL,
    cards_red INT NOT NULL
);

-- copia info de un csv con ese formato a la tabla con formato coincidente
COPY teams(team, players_used, avg_age, possession, games, goals, assists, cards_yellow, cards_red)
from '/teams.csv'
delimiter ';'
encoding 'LATIN1'
csv header;


-- creo la tabla matches con la tupla (team1, team2, stage) como PK
CREATE TABLE matches (
    team1        VARCHAR(20),
    team2        VARCHAR(20),
    goals_team1  INT            NOT NULL,
    goals_team2  INT            NOT NULL,
    stage        VARCHAR(30),
    constraint pk_matches primary key (team1, team2, stage)
);

-- inserto values a la tabla matches a partir de un csv
copy matches (team1,team2,goals_team1,goals_team2,stage)
from '/matches.csv'
delimiter ';'
encoding 'LATIN1'
csv header;


drop table if exists teams;
drop table if exists matches;


-- Ordena los resultados por la segunda columna seleccionada, de forma descendente
select team, games from teams order by 2 asc ;

-- puedo borrar una columna de la tabla teams. Pierdo todos los datos
alter table teams drop column games;

-- la puedo reagregar pero se agrega todo con nulls
-- el tipo smallint ocupa 2 bytes, menos rango pero no necesito mas
alter table teams add column if not exists games smallint; 

-- le puedo cambiar el tipo de dato de una columna
alter table teams alter column games type smallint;


-- que pasa si quiero agregar un dato que ya esta? se cumple la unicidad?
insert into teams (team, players_used, avg_age, possession, games, goals, assists, cards_yellow, cards_red)
values 
	('ARGENTINA',24,28.4,57.4,7,15,8,17,0); -- falla!!!!!




