#!/bin/bash

# title.basics
hive -e "CREATE TABLE IF NOT EXISTS title_basics ( tconst string, titleType string, primaryTitle string, originalTitle string, isAdult BOOLEAN, startYear int, endYear int, runtimeMinutes int, genres string) COMMENT 'title.basics' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"
# title.crew
hive -e "CREATE TABLE IF NOT EXISTS title_crew ( tconst string, directors STRING, writers string) COMMENT 'title_crew' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"
# title.episode
hive -e "CREATE TABLE IF NOT EXISTS title_episode ( tconst string, parentTconst STRING, seasonNumber INT, episodeNumber INT) COMMENT 'title_episode' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"

#title.principals
hive -e "CREATE TABLE IF NOT EXISTS title_principals ( tconst string, ordering int, nconst string, category string, job string, characters string) COMMENT 'title.principals' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"

#title.ratings
hive -e "CREATE TABLE IF NOT EXISTS title_ratings ( tconst string, averageRating DECIMAL, numVotes int) COMMENT 'title.ratings' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"

#name.basics
hive -e "CREATE TABLE IF NOT EXISTS name_basics ( nconst string, primaryName string, birthYear int, deathYear int, primaryProfession string, knownForTitles string) COMMENT 'name.basics' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"

hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie/database/title.basics.tsv' OVERWRITE INTO TABLE title_basics;"

hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie/database/title.crew.tsv' OVERWRITE INTO TABLE title_crew;"

hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie/database/title.episode.tsv' OVERWRITE INTO TABLE title_episode;"

hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie/database/title.principals.tsv' OVERWRITE INTO TABLE title_principals;"

hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie/database/title.ratings.tsv' OVERWRITE INTO TABLE title_ratings;"

hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie/database/name.basics.tsv' OVERWRITE INTO TABLE name_basics;"
