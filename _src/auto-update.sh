#!/usr/bin/bash

ROOT="$( dirname "${BASH_SOURCE[0]}" )"
year=`date "+%Y"`
hoje=`date +"%Y-%m-%d"`
ontem=`date -d "yesterday" +"%Y-%m-%d"`

python scraper/downloader.py

if [ $? = 0 ]; then
    R --no-save < update.R
    if [ $? = 0 ]; then
        pushd ..
        git add outputs/prev.5d.csv  outputs/tempos.duplicacao.csv index.html
        popd
        git commit -m "[auto] Novas projeções."
        git push
    else
        echo "** Erro na atualização do site. **"
    fi
else
    echo "** Nenhum dado novo, nenhuma projeção realizada. **"
fi

