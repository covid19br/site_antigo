source('prepara_dados.R')
source('ajuste_projecao_exponencial.R')
source('plots.R')
library(rmarkdown)

source('../sp/_src/update.R')

static_pages <- c('sobre.md', 'fontes.md', 'midia.md')
dynamic_pages <- c('index.Rmd', 'informacoes.Rmd', 'projecao.Rmd', 'pais.Rmd', 'casos.Rmd', 'propagacao.Rmd', 'dinamica.Rmd', 'transmissao.Rmd')
all_pages <- c(static_pages, dynamic_pages)

for (f in all_pages){
    rmarkdown::render(f, output_dir='../')
}

