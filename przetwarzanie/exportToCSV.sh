#!/bin/bash
echo "Export to CSV"
hive -e "SELECT * FROM etap2.series_popularity" | sed \$d | sed \$d > ./series_popularity.tsv
hive -e "SELECT * FROM etap2.director_popularity" | sed \$d | sed \$d > ./director_popularity.tsv
hive -e "SELECT * FROM etap2.actor_popularity" | sed \$d | sed \$d > ./actor_popularity.tsv
