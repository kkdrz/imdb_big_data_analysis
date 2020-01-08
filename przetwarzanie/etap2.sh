#!/bin/bash
# PRZETWARZANIE etap2
# CREATE etap1 database
hive -e "CREATE DATABASE etap2"
 
#actor_popularity
hive -e "CREATE TABLE IF NOT EXISTS etap2.actor_popularity AS
SELECT
  tc.nconst,
  tp.year,
  AVG(tp.popularity) AS popularity,
  tc.primaryname
FROM
  etap1.title_crew tc
  JOIN etap1.title_popularity tp ON tc.tconst = tp.tconst
WHERE
  tc.isactor
GROUP BY
  tc.nconst,
  tp.year,
  tc.primaryname;"
  
#director_popularity
hive -e "CREATE TABLE IF NOT EXISTS etap2.director_popularity AS
SELECT
  tc.nconst,
  tp.year,
  AVG(tp.popularity) AS popularity,
  tc.primaryname
FROM
  etap1.title_crew tc
  JOIN etap1.title_popularity tp ON tc.tconst = tp.tconst
WHERE
  tc.isdirector
GROUP BY
  tc.nconst,
  tp.year,
  tc.primaryname;"
  
#series_popularity
hive -e "CREATE TABLE IF NOT EXISTS etap2.series_popularity AS
SELECT
  te.parenttconst AS tconst,
  AVG(tp.popularity) AS popularity,
  te.primarytitle,
  te.seasonnumber
FROM
  etap1.title_popularity tp
  JOIN etap1.title_episode te ON tp.tconst = te.tconst
GROUP BY
  te.parenttconst,
  te.seasonnumber,
  te.primarytitle;"