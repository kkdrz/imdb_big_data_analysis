#!/bin/bash
# PRZETWARZANIE etap1
# CREATE etap1 database
echo "CREATE DATABASE etap1"
hive -e "CREATE DATABASE etap1;"

echo "CREATE TABLE IF NOT EXISTS etap1.title_crew"
#title_crew
hive -e "CREATE TABLE IF NOT EXISTS etap1.title_crew AS SELECT tp.tconst, tp.nconst, CASE tp.category WHEN 'director' THEN true ELSE false end AS isdirector, CASE tp.category WHEN 'actor' THEN true WHEN 'actress' THEN true ELSE false end AS isactor, nb.primaryname FROM imdb.title_principals tp JOIN imdb.name_basics nb ON tp.nconst = nb.nconst WHERE tp.category = 'director' OR tp.category = 'actor' OR tp.category = 'actress';"

echo "CREATE TABLE IF NOT EXISTS etap1.title_popularity"
#title_popularity
hive -e "CREATE TABLE IF NOT EXISTS etap1.title_popularity AS SELECT tr.tconst, tr.averagerating * tr.numvotes as popularity, tb.startyear as year, tb.primarytitle FROM imdb.title_ratings tr LEFT JOIN imdb.title_basics tb ON tr.tconst = tb.tconst;"

echo "CREATE TABLE IF NOT EXISTS etap1.title_episode"
#title_episode
hive -e "CREATE TABLE IF NOT EXISTS etap1.title_episode AS SELECT te.tconst, te.parenttconst, tb.primarytitle, te.seasonnumber, te.episodenumber FROM imdb.title_basics tb JOIN imdb.title_episode te ON tb.tconst = te.parenttconst;"