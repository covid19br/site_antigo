source('prepara_dados.R')
source('ajuste_projecao_exponencial.R')
source('plots.R')
library(rmarkdown)

all_pages <- c('informacoes.Rmd', 'sobre.md', 'fontes.md')
to_update <- c('main.Rmd')

for (f in all_pages){
    s <- strsplit(f, '.', fixed=TRUE)
    s <- s[[1]][-length(s[[1]])]
    fname <- paste(paste(s, collapse='.'), 'html', sep='.')
    rmarkdown::render(f, output_file=paste('../', fname, sep=''), output_dir='../')
}

rmarkdown::render('main.Rmd', output_file="../index.html")

