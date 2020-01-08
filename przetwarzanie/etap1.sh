#!/bin/bash
# PRZETWARZANIE etap1
# CREATE etap1 database
hive -e "CREATE DATABASE etap1"
 
#title_crew
hive -e "CREATE TABLE IF NOT EXISTS etap1.title_crew AS
SELECT
  tp.tconst,
  tp.nconst,
  CASE tp.category WHEN 'director' THEN true ELSE false end AS isdirector,
  CASE tp.category WHEN 'actor' THEN true WHEN 'actress' THEN true ELSE false end AS isactor,
  nb.primaryname
FROM
  imdb.title_principals tp
  JOIN imdb.name_basics nb ON tp.nconst = nb.nconst
WHERE
  tp.category = 'director'
  OR tp.category = 'actor'
  OR tp.category = 'actress';"
  
#title_popularity
hive -e "CREATE TABLE IF NOT EXISTS etap1.title_popularity AS
SELECT
  imdb.title_ratings.tconst,
  imdb.title_ratings.averagerating * imdb.title_ratings.numvotes as popularity,
  imdb.title_basics.startyear as year,
  imdb.title_basics.primarytitle
FROM
  imdb.title_ratings
  LEFT JOIN imdb.title_basics ON imdb.title_ratings.tconst = imdb.title_basics.tconst;"
  
#title_episode
hive -e "CREATE TABLE IF NOT EXISTS etap1.title_episode AS
SELECT
  te.tconst,
  te.parenttconst,
  tb.primarytitle,
  te.seasonnumber,
  te.episodenumber
FROM
  imdb.title_basics tb
  JOIN imdb.title_episode te ON tb.tconst = te.parenttconst"