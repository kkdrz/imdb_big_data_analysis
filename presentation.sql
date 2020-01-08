CREATE TABLE actor_popularity (nconst VARCHAR(255) PRIMARY KEY, year INT, popularity FLOAT, primaryname VARCHAR(255));
CREATE TABLE director_popularity (nconst VARCHAR(255) PRIMARY KEY, year INT, popularity FLOAT, primaryname VARCHAR(255));
CREATE TABLE series_popularity (tconst VARCHAR(255) PRIMARY KEY, popularity FLOAT, primarytitle VARCHAR(255), seasonnumber INT);
                                                                                                                   
LOAD DATA LOCAL INFILE './przetwarzanie/actor_popularity.tsv' INTO TABLE actor_popularity FIELDS TERMINATED BY '\t';
LOAD DATA LOCAL INFILE './przetwarzanie/director_popularity.tsv' INTO TABLE director_popularity FIELDS TERMINATED BY '\t';
LOAD DATA LOCAL INFILE './przetwarzanie/series_popularity.tsv' INTO TABLE series_popularity FIELDS TERMINATED BY '\t';
