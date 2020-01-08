#!/bin/bash
# rm -R -f database
rm -f repository.txt
hadoop fs -rm -R -f -skipTrash skladowanie
hadoop fs -rm -R -f -skipTrash posrednie
hadoop fs -rm -R -f -skipTrash rezultaty

