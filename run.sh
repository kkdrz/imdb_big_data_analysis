#!/bin/bash

if [ -f database/name.basics.tsv ]; then
    echo "Baza danych znajduje sie juz na dysku. Nie pobieram ponownie."
else
    ./pobieranie.sh
fi

./posrednie.sh
