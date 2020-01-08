#!/bin/bash

function create_hdfs_directories() {
    echo -e "\e[32mCreating hadoop directory: skladowanie"
    echo -e "\e[39m"
    hadoop fs -mkdir skladowanie

    echo -e "\e[32mCreating hadoop directory: posrednie"
    echo -e "\e[39m"

    hadoop fs -mkdir posrednie
}

function copy_data_files_to_hdfs() {

    echo -e "\e[32mMoving files from ./database to hdfs:skladowanie"
    echo -e "\e[39m"
    hadoop fs -copyFromLocal database/ skladowanie

}

function create_tables_in_hive() {

    # imdb database
    echo -e "\e[32mHive: Creating database: func_imdb"
    echo -e "\e[39m"

    hive -e "CREATE DATABASE IF NOT EXISTS func_imdb;"

    #title.principals
    echo -e "\e[32mHive: Creating table: title_principals"
    echo -e "\e[39m"
    hive -e "CREATE TABLE IF NOT EXISTS func_imdb.title_principals ( tconst string, ordering int, nconst string, category string, job string, characters string) COMMENT 'title.principals' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"

    #name.basics
    echo -e "\e[32mHive: Creating table: name_basics"
    echo -e "\e[39m"
    hive -e "CREATE TABLE IF NOT EXISTS func_imdb.name_basics ( nconst string, primaryName string, birthYear int, deathYear int, primaryProfession string, knownForTitles string) COMMENT 'name.basics' ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' STORED AS TEXTFILE tblproperties ('skip.header.line.count'='1');"

}

function load_data_from_hdfs_to_hive() {

    echo -e "\e[32mHive: Load data to title_principals"
    echo -e "\e[39m"
    hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie/database/title.principals.tsv' OVERWRITE INTO TABLE func_imdb.title_principals;"

    echo -e "\e[32mHive: Load data to name_basics"
    echo -e "\e[39m"
    hive -e "LOAD DATA INPATH '/user/cloudera/skladowanie/database/name.basics.tsv' OVERWRITE INTO TABLE func_imdb.name_basics;"

    echo -e "\e[32mHive: Data loading finished"
    echo -e "\e[39m"
}

function functional_test() {
    hive -e "CREATE DATABASE func_etap1"

    hive -e "CREATE TABLE IF NOT EXISTS func_etap1.title_crew AS
SELECT
  tp.tconst,
  tp.nconst,
  CASE tp.category WHEN 'director' THEN true ELSE false end AS isdirector,
  CASE tp.category WHEN 'actor' THEN true WHEN 'actress' THEN true ELSE false end AS isactor,
  nb.primaryname
FROM
  func_imdb.title_principals tp
  JOIN func_imdb.name_basics nb ON tp.nconst = nb.nconst
WHERE
  tp.category = 'director'
  OR tp.category = 'actor'
  OR tp.category = 'actress';"

  echo $(hive -e "Select from func_etap1.title_crew")
}

create_hdfs_directories

copy_data_files_to_hdfs

create_tables_in_hive

load_data_from_hdfs_to_hive

functional_test
