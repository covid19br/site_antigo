#!/usr/bin/bash

today=`LANG=en date +'%b %d'`

git pull
git log -- ../dados/BrasilCov19.csv | grep  "$today"
novos_dados=$?

git log -- ../web/last.update.br.txt | grep  "$today"
nova_pagina=$?

if [[ $novos_dados = 0 && ! $nova_pagina = 0 ]]; then
    Rscript update.R && echo "Pagina BR atualizada" &&
    Rscript update_estado.R && echo "Pagina Estados atualizada" &&
    git add ../outputs/*.prev.5d.csv ../outputs/*.tempos.duplicacao.csv ../outputs/tempos.duplicacao.csv ../outputs/prev.5d.csv ../web/est.tempo.dupl.html ../web/est.tempo.dupl.svg ../web/last.update.br.txt ../web/last.update.estado.txt ../web/plot.forecast.exp.*.html ../web/plot.forecast.exp.*.svg ../web/proj.num.casos.html ../web/proj.num.casos.svg ../web/data_forecast_exp_br.csv ../web/data_forecast_exp_estados.csv

    git commit -m "[auto] atualizando paginas BR e Estados" &&
    git push
fi
