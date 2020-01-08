#!/bin/bash
hive -e "SELECT * FROM etap2.series_popularity" | sed \$d | sed \$d > ./przetwarzanie/series_popularity.csv
hive -e "SELECT * FROM etap2.director_popularity" | sed \$d | sed \$d > ./przetwarzanie/director_popularity.csv
hive -e "SELECT * FROM etap2.actor_popularity" | sed \$d | sed \$d > ./przetwarzanie/actor_popularity.csv
mysql -uroot -pcloudera -e 'CREATE DATABASE presentation CHARACTER SET UTF8'
mysql -uroot -pcloudera presentation < ./presentation.sql
