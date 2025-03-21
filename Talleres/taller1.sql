
/*
 * Taller I: Definicion de Datos en SQL
 */

-- creo tabla de teams
CREATE TABLE teams (
    team VARCHAR(20) NOT NULL,
    players_used INT NOT NULL,
    avg_age FLOAT NOT NULL,
    possession FLOAT NOT NULL,
    games INT NOT NULL,
    goals INT NOT NULL,
    assists INT NOT NULL,
    cards_yellow INT NOT NULL,
    cards_red INT NOT NULL
);

-- borra la tabla
drop table teams;

-- copia info de un csv con ese formato a la tabla con formato coincidente
COPY teams(team, players_used, avg_age, possession, games, goals, assists, cards_yellow, cards_red)
from '/teams.csv'
delimiter ';'
encoding 'LATIN1'
csv header;

-- selecciono todas las columnas de teams donde team='CROATIA'
select * from teams where team='CROATIA';
-- selecciono las columnas team, goals y assists de teams donde team='ARGENTINA'
select team, goals, assists from teams where team='ARGENTINA';

-- borro la fila de teams que tiene a team='ARGENTINA'
delete from teams where team='ARGENTINA';

-- inserto en teams el value 
insert into teams (team, players_used, avg_age, possession, games, goals, assists, cards_yellow, cards_red)
values 
	('ARGENTINA',24,28.4,57.4,7,15,8,17,0);


-- creo la tabla matches
CREATE TABLE matches (
    team1        VARCHAR(20)    NOT NULL,
    team2        VARCHAR(20)    NOT NULL,
    goals_team1  INT            NOT NULL,
    goals_team2  INT            NOT NULL,
    stage        VARCHAR(30)    NOT NULL
);

-- inserto values a la tabla matches a partir de un csv
copy matches (team1,team2,goals_team1,goals_team2,stage)
from '/matches.csv'
delimiter ';'
encoding 'LATIN1'
csv header;

