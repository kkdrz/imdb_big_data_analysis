#!/bin/bash

function create_hdfs_directories() {
    echo -e "\e[32mCreating hadoop directory: skladowanie_perf_1"
    echo -e "\e[39m"
    hadoop fs -mkdir skladowanie_perf_1

    echo -e "\e[32mCreating hadoop directory: posrednie_perf_1"
    echo -e "\e[39m"

    hadoop fs -mkdir posrednie_perf_1

    echo -e "\e[32mCreating hadoop directory: rezultaty_perf_1"
    echo -e "\e[39m"

    hadoop fs -mkdir rezultaty_perf_1
}

function copy_data_files_to_hdfs() {

    echo -e "\e[32mMoving files from ./database to hdfs:skladowanie_perf_1"
    echo -e "\e[39m"
    hadoop fs -copyFromLocal database/ skladowanie_perf_1

    echo -e "\e[32mMoving files from ./template to hdfs:posrednie_perf_1"
    echo -e "\e[39m"
    hadoop fs -copyFromLocal template/ posrednie_perf_1
}

function create_tables_in_hive() {

    # imdb_perf_1 database
    echo -e "\e[32mHive: Creating database: imdb_perf_1"
    echo -e "\e[39m"

    hive -e "CREATE DATABASE IF NOT EXISTS imdb_perf_1;"

    # title.basics
    echo -e "\e[32mHive: Creating table: title_basics"
    echo -e "\e[39m"
    hive -e "CREATE TABLE IF NOT EXISTS imdb_perf_1.title_basics ( tconst string, titleType string, primaryTitle string, originalTitle string, isAdult BOOLEAN, startYear int, endYear int, runtimeMinutes int, genres string) COMMENT 'title.basics' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"

    # title.crew
    echo -e "\e[32mHive: Creating table: title_crew"
    echo -e "\e[39m"
    hive -e "CREATE TABLE IF NOT EXISTS imdb_perf_1.title_crew ( tconst string, directors STRING, writers string) COMMENT 'title_crew' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"

    # title.episode
    echo -e "\e[32mHive: Creating table: title_episode"
    echo -e "\e[39m"
    hive -e "CREATE TABLE IF NOT EXISTS imdb_perf_1.title_episode ( tconst string, parentTconst STRING, seasonNumber INT, episodeNumber INT) COMMENT 'title_episode' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"

    #title.principals
    echo -e "\e[32mHive: Creating table: title_principals"
    echo -e "\e[39m"
    hive -e "CREATE TABLE IF NOT EXISTS imdb_perf_1.title_principals ( tconst string, ordering int, nconst string, category string, job string, characters string) COMMENT 'title.principals' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"

    #title.ratings
    echo -e "\e[32mHive: Creating table: title_ratings"
    echo -e "\e[39m"
    hive -e "CREATE TABLE IF NOT EXISTS imdb_perf_1.title_ratings ( tconst string, averageRating DECIMAL, numVotes int) COMMENT 'title.ratings' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"

    #name.basics
    echo -e "\e[32mHive: Creating table: name_basics"
    echo -e "\e[39m"
    hive -e "CREATE TABLE IF NOT EXISTS imdb_perf_1.name_basics ( nconst string, primaryName string, birthYear int, deathYear int, primaryProfession string, knownForTitles string) COMMENT 'name.basics' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"

}

function load_data_from_hdfs_to_hive() {

    echo -e "\e[32mHive: Load data to title_basics"
    echo -e "\e[39m"
    hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie_perf_1/database/title.basics.tsv' OVERWRITE INTO TABLE imdb_perf_1.title_basics;"

    echo -e "\e[32mHive: Load data to title_crew"
    echo -e "\e[39m"
    hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie_perf_1/database/title.crew.tsv' OVERWRITE INTO TABLE imdb_perf_1.title_crew;"

    echo -e "\e[32mHive: Load data to title_episode"
    echo -e "\e[39m"
    hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie_perf_1/database/title.episode.tsv' OVERWRITE INTO TABLE imdb_perf_1.title_episode;"

    echo -e "\e[32mHive: Load data to title_principals"
    echo -e "\e[39m"
    hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie_perf_1/database/title.principals.tsv' OVERWRITE INTO TABLE imdb_perf_1.title_principals;"

    echo -e "\e[32mHive: Load data to title_ratings"
    echo -e "\e[39m"
    hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie_perf_1/database/title.ratings.tsv' OVERWRITE INTO TABLE imdb_perf_1.title_ratings;"

    echo -e "\e[32mHive: Load data to name_basics"
    echo -e "\e[39m"
    hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie_perf_1/database/name.basics.tsv' OVERWRITE INTO TABLE imdb_perf_1.name_basics;"

    echo -e "\e[32mHive: Data loading finished"
    echo -e "\e[39m"
}

START=$(date +%s.%N)

create_hdfs_directories

copy_data_files_to_hdfs

create_tables_in_hive

load_data_from_hdfs_to_hive

. ./etap1.sh
. ./etap2.sh

END=$(date +%s.%N)

DIFF=$(echo "$END - $START" | bc)
echo "Duration: $DIFF seconds"