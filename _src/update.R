source('prepara_dados.R')
source('ajuste_projecao_exponencial.R')
library(rmarkdown)

rmarkdown::render('main.Rmd', output_file="../index.html")

#generate.page <- function(f, fname){
#    if (missing(fname)){
#        s <- strsplit(f, '.', fixed=TRUE)
#        s <- s[[1]][-length(s[[1]])]
#        fname <- paste(paste(s, collapse='.'), 'html', sep='.')
#    }
#    render(f, output_file=paste('../', fname, sep=''))
#    system(paste("sed -i '1i---\\n---' ../", fname, sep=''))
#}
#
#add.projection <- function(){
#    proj_file <- paste('projecoes-', fim-30, '.html', sep='')
#    generate.page('previsoes.Rmd', proj_file)
#    new_entry <- paste('             <li><a href="', proj_file, '">', fim-30, "</a></li>", sep='')
#    write(new_entry, file="../_includes/lista_projecoes.html", append=TRUE)
#    # prevent repeated entries
#    system('echo "`uniq ../_includes/lista_projecoes.html`" > ../_includes/lista_projecoes.html')
#    system(paste('cp ../', proj_file, ' ../index.html', sep=''))
#}
#
#all_files <- c('dados.Rmd', 'recursos.md', 'sobre.md', 'historico.Rmd', 'seca_2013-2014.md', 'clipping.md', 'artigo_plos.md', 'resposta_kelman.md', 'balanco2015.Rmd', 'balanco2016.Rmd', 'balanco2017.Rmd')
#to_update <- c('historico.Rmd', 'dados.Rmd')
#
#add.projection()
#
#for (f in to_update){
#    generate.page(f)
#}
#
#system('bash generate_sitemap.sh')
