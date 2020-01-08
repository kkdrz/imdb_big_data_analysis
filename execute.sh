#!/bin/bash

function create_hdfs_directories() {
    echo -e "\e[32mCreating hadoop directory: skladowanie"
    echo -e "\e[39m"
    hadoop fs -mkdir skladowanie

    echo -e "\e[32mCreating hadoop directory: posrednie"
    echo -e "\e[39m"

    hadoop fs -mkdir posrednie

    echo -e "\e[32mCreating hadoop directory: rezultaty"
    echo -e "\e[39m"

    hadoop fs -mkdir rezultaty
}

function copy_data_files_to_hdfs() {

    echo -e "\e[32mMoving files from ./database to hdfs:skladowanie"
    echo -e "\e[39m"
    hadoop fs -copyFromLocal database/ skladowanie

    echo -e "\e[32mMoving files from ./template to hdfs:posrednie"
    echo -e "\e[39m"
    hadoop fs -copyFromLocal template/ posrednie
}

function download_data_files_from_imdb() {

    echo -e "\e[32mCreating download list - repository.txt"
    echo -e "\e[39m"
    echo "https://datasets.imdbws.com/title.basics.tsv.gz " >>repository.txt
    echo "https://datasets.imdbws.com/title.crew.tsv.gz" >>repository.txt
    echo "https://datasets.imdbws.com/title.episode.tsv.gz" >>repository.txt
    echo "https://datasets.imdbws.com/title.principals.tsv.gz" >>repository.txt
    echo "https://datasets.imdbws.com/title.ratings.tsv.gz " >>repository.txt
    echo "https://datasets.imdbws.com/name.basics.tsv.gz " >>repository.txt

    echo "$(cat repository.txt)"

    echo -e "\e[32mDownloading data files"
    echo -e "\e[39m"
    wget -i repository.txt -P database/
    if [[ "$?" = 0 ]]; then
        echo -e "\e[32m"
        echo "Downloading files finished with success."
        echo -e "\e[39m"

        echo -e "\e[32mUnpacking files"
        echo -e "\e[39m"

        gunzip database/*.gz
    else
        echo -e "\e[31m"
        echo "Error while downloading data files. Check internet connection."
        echo -e "\e[39m"
    fi

    echo -e "\e[32mRemoving download list file - repository.txt"
    echo -e "\e[39m"
    rm -f repository.txt

}

function create_templates_directory() {
    echo -e "\e[32mCreating template directory with templates"
    echo -e "\e[39m"

    mkdir template
    touch template/Titlecrew.csv
    touch template/TitlePopularity.csv
    touch template/SeriesPopularity.csv
    touch template/NamePopularity.csv
    touch template/Results.csv
}

function create_tables_in_hive() {

    # imdb database
    echo -e "\e[32mHive: Creating database: imdb"
    echo -e "\e[39m"

    hive -e "CREATE DATABASE IF NOT EXISTS imdb;"

    # title.basics
    echo -e "\e[32mHive: Creating table: title_basics"
    echo -e "\e[39m"
    hive -e "CREATE TABLE IF NOT EXISTS imdb.title_basics ( tconst string, titleType string, primaryTitle string, originalTitle string, isAdult BOOLEAN, startYear int, endYear int, runtimeMinutes int, genres string) COMMENT 'title.basics' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"

    # title.crew
    echo -e "\e[32mHive: Creating table: title_crew"
    echo -e "\e[39m"
    hive -e "CREATE TABLE IF NOT EXISTS imdb.title_crew ( tconst string, directors STRING, writers string) COMMENT 'title_crew' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"

    # title.episode
    echo -e "\e[32mHive: Creating table: title_episode"
    echo -e "\e[39m"
    hive -e "CREATE TABLE IF NOT EXISTS imdb.title_episode ( tconst string, parentTconst STRING, seasonNumber INT, episodeNumber INT) COMMENT 'title_episode' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"

    #title.principals
    echo -e "\e[32mHive: Creating table: title_principals"
    echo -e "\e[39m"
    hive -e "CREATE TABLE IF NOT EXISTS imdb.title_principals ( tconst string, ordering int, nconst string, category string, job string, characters string) COMMENT 'title.principals' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"

    #title.ratings
    echo -e "\e[32mHive: Creating table: title_ratings"
    echo -e "\e[39m"
    hive -e "CREATE TABLE IF NOT EXISTS imdb.title_ratings ( tconst string, averageRating DECIMAL, numVotes int) COMMENT 'title.ratings' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"

    #name.basics
    echo -e "\e[32mHive: Creating table: name_basics"
    echo -e "\e[39m"
    hive -e "CREATE TABLE IF NOT EXISTS imdb.name_basics ( nconst string, primaryName string, birthYear int, deathYear int, primaryProfession string, knownForTitles string) COMMENT 'name.basics' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"

}

function load_data_from_hdfs_to_hive() {

    echo -e "\e[32mHive: Load data to title_basics"
    echo -e "\e[39m"
    hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie/database/title.basics.tsv' OVERWRITE INTO TABLE imdb.title_basics;"

    echo -e "\e[32mHive: Load data to title_crew"
    echo -e "\e[39m"
    hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie/database/title.crew.tsv' OVERWRITE INTO TABLE imdb.title_crew;"

    echo -e "\e[32mHive: Load data to title_episode"
    echo -e "\e[39m"
    hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie/database/title.episode.tsv' OVERWRITE INTO TABLE imdb.title_episode;"

    echo -e "\e[32mHive: Load data to title_principals"
    echo -e "\e[39m"
    hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie/database/title.principals.tsv' OVERWRITE INTO TABLE imdb.title_principals;"

    echo -e "\e[32mHive: Load data to title_ratings"
    echo -e "\e[39m"
    hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie/database/title.ratings.tsv' OVERWRITE INTO TABLE imdb.title_ratings;"

    echo -e "\e[32mHive: Load data to name_basics"
    echo -e "\e[39m"
    hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie/database/name.basics.tsv' OVERWRITE INTO TABLE imdb.name_basics;"

    echo -e "\e[32mHive: Data loading finished"
    echo -e "\e[39m"
}

if [ -f database/name.basics.tsv ]; then
    echo "Data files exist. Not downloading again."
else
    download_data_files_from_imdb
fi

create_hdfs_directories

create_templates_directory

copy_data_files_to_hdfs

create_tables_in_hive

load_data_from_hdfs_to_hive
