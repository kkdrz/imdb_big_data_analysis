hive -e "SELECT * FROM etap2.series_popularity" | sed \$d | sed \$d > ./series_popularity.csv
hive -e "SELECT * FROM etap2.director_popularity" | sed \$d | sed \$d > ./director_popularity.csv
hive -e "SELECT * FROM etap2.actor_popularity" | sed \$d | sed \$d > ./actor_popularity.csv
