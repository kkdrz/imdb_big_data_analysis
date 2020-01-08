CREATE TABLE actor_popularity (nconst VARCHAR(255) PRIMARY KEY, year INT, popularity FLOAT, primaryname VARCHAR(255));
CREATE TABLE director_popularity (nconst VARCHAR(255) PRIMARY KEY, year INT, popularity FLOAT, primaryname VARCHAR(255));
CREATE TABLE series_popularity (tconst VARCHAR(255) PRIMARY KEY, popularity FLOAT, primarytitle VARCHAR(255), seasonnumber INT);

LOAD DATA INFILE './przetwarzanie/actor_popularity.csv' INTO TABLE actor_popularity
LOAD DATA INFILE './przetwarzanie/director_popularity.csv' INTO TABLE director_popularity
LOAD DATA INFILE './przetwarzanie/series_popularity.csv' INTO TABLE series_popularity
