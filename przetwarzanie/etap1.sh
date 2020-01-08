#!/bin/bash
# PRZETWARZANIE etap1
# CREATE etap1 database
hive -e "Create DATABASE etap1"
 
# CREATE reduced name_basics table
hive -e "CREATE TABLE IF NOT EXISTS etap1.name_basics AS SELECT nconst, primaryname, knownfortitles FROM default.name_basics;"
 
# CREATE reduced TitleBasics
hive -e "CREATE TABLE IF NOT EXISTS etap1.title_basics AS SELECT tconst, primarytitle, startyear FROM default.title_basics;"
 
# CREATE JOINED title_ratings_years
hive -e "CREATE TABLE IF NOT EXISTS etap1.title_ratings_years AS SELECT title_ratings.tconst as tconst, title_ratings.averagerating as averagerating, title_ratings.numvotes as numvotes, title_basics.startyear as startyear, title_basics.primarytitle as primarytitle FROM title_ratings LEFT JOIN title_basics ON title_ratings.tconst = title_basics.tconst;"
 
# Rozbijanie po spacjach (potrzebne do atomizecrew)
# SELECT tconst, uniqueDirectors as director, writers FROM (
# SELECT tconst, split(directors, '\,') as directors, writers  FROM default.title_crew P
# ) a lateral view explode(a.directors) exploded as uniqueDirectors;
 
# Title_crew z ominieciem atomizecrew
"CREATE TABLE IF NOT EXISTS etap1.title_crew AS SELECT tconst, nconst, CASE category WHEN "director" THEN true ELSE false END as isDirector, CASE category WHEN "actor" THEN true ELSE false END as isActor FROM default.title_principals WHERE category = 'director' OR category = 'actor';"