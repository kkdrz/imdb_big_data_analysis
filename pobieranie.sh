#!/bin/bash
echo -e "\e[32mCreating download list"
echo -e "\e[39m"
echo "https://datasets.imdbws.com/title.basics.tsv.gz " >> repository.txt
echo "https://datasets.imdbws.com/title.crew.tsv.gz" >> repository.txt
echo "https://datasets.imdbws.com/title.episode.tsv.gz" >> repository.txt
echo "https://datasets.imdbws.com/title.principals.tsv.gz" >> repository.txt
echo "https://datasets.imdbws.com/title.ratings.tsv.gz " >> repository.txt
echo "https://datasets.imdbws.com/name.basics.tsv.gz " >> repository.txt


echo -e "\e[32mDownloading database"
echo -e "\e[39m"
wget -i repository.txt -P database/
if [[ "$?" = 0 ]]; then
	echo -e "\e[32m"
	echo "Pobrano"
	echo -e "\e[39m"
	
	echo -e "\e[32mUnpacking files"
	echo -e "\e[39m"
	gunzip database/*.gz
else
	echo -e "\e[31m"	
	echo "Blad. Nie pobrano bazy danych. Sprawdz polaczenie internetowe."
	echo -e "\e[39m"
fi



echo -e "\e[32mRemoving repository file"
echo -e "\e[39m"
rm -f repository.txt


echo -e "\e[32mCreating template folder"
echo -e "\e[39m"
mkdir template
touch template/Titlecrew.csv
touch template/TitlePopularity.csv
touch template/SeriesPopularity.csv
touch template/NamePopularity.csv
touch template/Results.csv

