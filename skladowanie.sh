#!/bin/bash
echo -e "\e[32mCreating template folder"
echo -e "\e[39m"
mkdir template
touch template/Titlecrew.csv
touch template/TitlePopularity.csv
touch template/SeriesPopularity.csv
touch template/NamePopularity.csv
touch template/Results.csv

echo -e "\e[32mCreating hadoop directories"
echo -e "\e[39m"

hadoop fs -mkdir posrednie
hadoop fs -mkdir rezultaty

echo -e "\e[32Moving template folder to hadoop"
echo -e "\e[39m"

hadoop fs -copyFromLocal template/ posrednie

echo -e "\e[32Creating database for presentation"
echo -e "\e[39m"
./presentation.sh

