tryCatch({
# Libraries
library(widgetframe)
library(tidyverse)
library(plotly)
library(lubridate)

# Helper Function
makeNamedList <- function(...) {
  structure(list(...), names = as.list(substitute(list(...)))[-1L])
}

# Processamento de Dados
source('prepara_dados.R')
source('ajuste_projecao_exponencial.R')

# Geracao dos graficos
source('plots.R')

# Atualizacao do conteudo do site
# Graficos, tabelas e horário

## Data de Atualizacao
print("Atualizando data de atualizacao...")
file <- file("../web/last.update.br.txt") # coloco o nome do municipio?
writeLines(c(paste(now())), file)
close(file)

################################################################################
## Atualiza Plots no site
################################################################################
print("Atualizando plots...")
# Graficos a serem atualizados
plots.para.atualizar <- makeNamedList(plot.forecast.exp.br, est.tempo.dupl, proj.num.casos)
filenames <- names(plots.para.atualizar)
n <- length(plots.para.atualizar)

for (i in 1:n){
  graph.html <- ggplotly(plots.para.atualizar[[i]]) %>% layout(margin = list(l = 50, r = 50, b = 50, t = 50, pad = 4), title = list(y = 0.94))
  graph.svg <- plots.para.atualizar[[i]] + theme(axis.text= element_text(size=11, face="plain"),
                                                 axis.title = element_text(size=14, face="plain"))
  filepath <- paste("../web/",filenames[i],sep="")
  saveWidget(frameableWidget(graph.html), file = paste(filepath,".html",sep=""), libdir="./libs") # HTML Interative Plot
  ggsave(paste(filepath,".svg",sep=""), plot = graph.svg, device = svg, scale= .8, width= 210, height = 142, units = "mm")

}

################################################################################
## Atualiza tabelas
################################################################################
print("Atualizando tabelas...")
tables.para.atualizar <- c(serie.temp.table) # Tabelas a serem atualizadas
names.tables <- makeNamedList(serie.temp.table) # Tabelas a serem atualizadas
filenames <- names(names.tables)
n <- length(tables.para.atualizar)

for (i in 1:n){
  filepath <- paste("../web/",filenames[i],sep="")
  filename <- paste(filepath,".html",sep="")
  write_file(tables.para.atualizar[i], filename)
}

}, error = function(cond){
    message(cond)
    quit(status = 1)
})

