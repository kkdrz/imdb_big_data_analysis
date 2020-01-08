#!/bin/bash

hadoop fs -rm -R -f -skipTrash skladowanie
hadoop fs -rm -R -f -skipTrash posrednie
hadoop fs -rm -R -f -skipTrash rezultaty

hive -e "drop database if exists imdb CASCADE;"
hive -e "drop database if exists etap1 CASCADE;"
hive -e "drop database if exists etap2 CASCADE;"

hive -e "drop database if exists func_etap2 CASCADE;"
hive -e "DROP DATABASE IF EXISTS func_etap1 CASCADE;"
hive -e "DROP DATABASE IF EXISTS func_imdb CASCADE;"
