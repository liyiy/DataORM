DROP TABLE IF EXISTS pokemon;
DROP TABLE IF EXISTS trainers;
DROP TABLE IF EXISTS towns;

CREATE TABLE pokemon (
   id INTEGER PRIMARY KEY,
   name VACHAR(255) NOT NULL,
   trainer_id INTEGER,

   FOREIGN_KEY(trainer_id) REFERENCES trainer(id)
);

CREATE TABLE trainers (
   id INTEGER PRIMARY KEY,
   fname VARCHAR(255) NOT NULL,
   lname VARCHAR(255) NOT NULL,
   town_id INTEGER,

   FOREIGN_KEY(town_id) REFERENCES trainer(id)
);

CREATE TABLE towns (
   id INTEGER PRIMARY KEY,
   name VARCHAR(255) NOT NULL
);

INSERT INTO 
   trainers (id, fname, town_id)
VALUES 
   (1, "Ash", 1),
   (2, "Misty", 2),
   (3, "Brock", 3),
   (4, "Officer Jenny", NULL),
   (5, "Nurse Joy", NULL);

INSERT INTO 
   pokemon (id, name, trainer_id)
VALUES 
   (1, "Pikachu", 1),
   (2, "Charmander", 1),
   (3, "Totodile", 1),
   (4, "Psyduck", 2),
   (5, "Staryu", 2),
   (6, "Geodude", 3),
   (7, "Steelix", 3),
   (8, "Mew", NULL);

INSERT INTO 
   towns (id, name)
VALUES 
   (1, "Pallet Town"),
   (2, "Cerulean City"),
   (3, "Pewter City");

