source('../sp/_src/prepara_dados_sp.R')
source('../sp/_src/ajuste_projecao_exponencial_sp.R')
source('../sp/_src/plots_sp.R')
library(rmarkdown)

dynamic_pages <- c('../sp/_src/index.Rmd', '../sp/_src/main_sp.Rmd','../sp/_src/projecao_sp.Rmd', '../sp/_src/propagacao_sp.Rmd', '../sp/_src/transmissaos_sp.Rmd')
all_pages <- c(dynamic_pages)

for (f in all_pages){
    rmarkdown::render(f, output_dir='../sp/')
}

