#!/bin/bash
#hdfs dfs -test -e database
#if [[ "$?" != 0 ]]; then
#	echo "Dane sa juz na partycji rozproszonej"
#else
	echo -e "\e[32mCreating hadoop directory"
	echo -e "\e[39m"
	hadoop fs -mkdir skladowanie

	echo -e "\e[32mCreating hadoop directories"
	echo -e "\e[39m"

	hadoop fs -mkdir posrednie
	hadoop fs -mkdir rezultaty

	echo -e "\e[32mMoving data to hadoop"
	echo -e "\e[39m"
	hadoop fs -copyFromLocal database/ skladowanie
	hadoop fs -copyFromLocal template/ posrednie
#fi

