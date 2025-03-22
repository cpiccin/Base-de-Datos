/*
* Taller II: Restricciones de Integridad en SQL
*/


-- creo tabla de teams con team como PK
CREATE TABLE if not exists teams (
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
CREATE table if not exists matches (
    team1        VARCHAR(20), -- references teams (team),
    team2        VARCHAR(20) check (team1 <> team2), -- references teams (team),
    goals_team1  INT            NOT NULL,
    goals_team2  INT            NOT NULL,
    stage        VARCHAR(30),
    constraint pk_matches primary key (team1, team2, stage),
    FOREIGN KEY (team1) references teams (team),
    FOREIGN KEY (team2) references teams (team)
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


/*
 * Verificacion I: violacion a la restriccion de unicidad.
 * Que pasa si quiero agregar un dato que ya esta? se cumple la unicidad?
 */
insert into teams (team, players_used, avg_age, possession, games, goals, assists, cards_yellow, cards_red)
values 
	('ARGENTINA',24,28.4,57.4,7,15,8,17,0); -- falla!!!!!

	
--  falla por el check que defini cuando cree la tabla 'violates check constraint "matches_check"''
insert into matches (team1,team2,goals_team1,goals_team2,stage)
values 
	('ARGENTINA', 'ARGENTINA', 2, 4, 'grupo1');
	
-- esto tambien falla porque no pueden haber nada null por el NOT NULL
insert into teams (
	team
)
values
	('Argentina');


-- puedo buscar algo por cualquier cosa que tenga en su nombre. ilike no distingue de mayus y minus
select * from teams where team ilike '%AR%';


/*
 * Verificacion II: violación de la restricción de integridad referencial.
 * O sea, intentar insertar una fila en la tabla matches donde uno de los valores 
 * de las columnas team1 o team2 no existe en la tabla teams
 */
insert into matches (team1,team2,goals_team1,goals_team2,stage)
values 
	('ARGENTINA', 'CHILE', 3, 2, 'grupo a');
-- falla!!!! violates foreign key constraint "matches_team2_fkey"


/*
 * Verificacion III: eliminacion de una tupla que es referenciada.
 * Intente provocar una violacion a la restriccion de integridad referencial definida, 
 * a traves de un DELETE en la tabla que considere apropiada.
 */
delete from teams where team='ARGENTINA';
-- falla: violates foreign key constraint "matches_team1_fkey" on table "matches"


/*
 * Verificacion IV: eliminacion de una tupla que es referenciada.
 * Intente modificar el nombre del equipo ’Argentina’ por ’ARG’ utilizando
 * un script de UPDATE. ¿Es posible hacerlo?
*/
update teams 
set team='Argentina'
where team='ARGENTINA';
-- falla: violates foreign key constraint "matches_team1_fkey" on table "matches"


/*
 * Actualizacion en cascada:
 * Quiero que sea posible cambiar el nombre de los equipos por sus diminutivos, 
 * modificando automaticamente todas las filas que hacen referencia a ella en otras 
 * tablas. Modifique para ello el script de CREATE TABLE, definiendo una CONSTRAINT 
 * de ON UPDATE en la tabla correspondiente.
*/
CREATE table matches (
    team1        VARCHAR(20), 
    team2        VARCHAR(20), -- references teams (team),
    goals_team1  INT            NOT NULL,
    goals_team2  INT            NOT NULL,
    stage        VARCHAR(30),
    constraint pk_matches primary key (team1, team2, stage),
    FOREIGN KEY (team1) references teams (team) on update cascade,
    FOREIGN KEY (team2) references teams (team) on update cascade
);

/*
 * Verificacion V: 
 * Intente nuevamente modificar el nombre del equipo ’Argentina’ por ’ARG’
 */
update teams 
set team='ARG'
where team='ARGENTINA';
-- si se actualiza la referencia se actualiza en cascada en todo el resto

/*
 * Eliminacion en cascada:
 * Insertaron a ’CHILE’ por error y necesitan eliminar todos los registros que contengan 
 * este equipo. Necesitan poder el automaticamente eliminar todas las filas que hacen 
 * referencia a este equipo en otras tablas. 
 * Modifique para ello el script de CREATE TABLE, definiendo una CONSTRAINT de ON DELETE
 * en la tabla correspondiente
 */
CREATE table matches (
    team1        VARCHAR(20), 
    team2        VARCHAR(20), -- references teams (team),
    goals_team1  INT            NOT NULL,
    goals_team2  INT            NOT NULL,
    stage        VARCHAR(30),
    constraint pk_matches primary key (team1, team2, stage),
    FOREIGN KEY (team1) references teams (team) on update cascade on delete cascade,
    FOREIGN KEY (team2) references teams (team) on update cascade on delete cascade
);


/*
 * Verificacion VI: 
 * Intente nuevamente eliminar el equipo erroneamente agregado y analice
 * lo ocurrido. ¿Que ocurre si nos olvidamos el WHERE en un DELETE?
 */
delete from teams where team='ARGENTINA';
delete from teams;
-- si no pongo el where se borra todo








