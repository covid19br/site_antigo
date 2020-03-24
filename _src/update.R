source('prepara_dados.R')
source('ajuste_projecao_exponencial.R')
source('plots.R')
library(rmarkdown)

all_pages <- c('index.Rmd', 'informacoes.Rmd', 'sobre.md', 'fontes.md', 'projecao.Rmd')

for (f in all_pages){
    rmarkdown::render(f, output_dir='../')
}

