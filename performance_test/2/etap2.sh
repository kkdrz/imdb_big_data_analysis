#!/bin/bash
# PRZETWARZANIE etap2_perf_2
# CREATE etap1_perf_2 database
echo "CREATE DATABASE etap2_perf_2"
hive -e "CREATE DATABASE etap2_perf_2;"

echo "CREATE TABLE IF NOT EXISTS etap2_perf_2.actor_popularity"
#actor_popularity
hive -e "CREATE TABLE IF NOT EXISTS etap2_perf_2.actor_popularity AS SELECT tc.nconst, tp.year, AVG(tp.popularity) AS popularity, tc.primaryname FROM etap1_perf_2.title_crew tc JOIN etap1_perf_2.title_popularity tp ON tc.tconst = tp.tconst WHERE tc.isactor GROUP BY tc.nconst, tp.year, tc.primaryname;"

echo "CREATE TABLE IF NOT EXISTS etap2_perf_2.director_popularity"
#director_popularity
hive -e "CREATE TABLE IF NOT EXISTS etap2_perf_2.director_popularity AS SELECT tc.nconst, tp.year, AVG(tp.popularity) AS popularity, tc.primaryname FROM etap1_perf_2.title_crew tc JOIN etap1_perf_2.title_popularity tp ON tc.tconst = tp.tconst WHERE tc.isdirector GROUP BY tc.nconst, tp.year, tc.primaryname;"

echo "CREATE TABLE IF NOT EXISTS etap2_perf_2.series_popularity"
#series_popularity
hive -e "CREATE TABLE IF NOT EXISTS etap2_perf_2.series_popularity AS SELECT te.parenttconst AS tconst, AVG(tp.popularity) AS popularity, te.primarytitle, te.seasonnumber FROM etap1_perf_2.title_popularity tp JOIN etap1_perf_2.title_episode te ON tp.tconst = te.tconst GROUP BY te.parenttconst, te.seasonnumber, te.primarytitle;"