# Atualizacao do conteudo do site
print("Atualizando conteudo do website")

# Libraries
library(widgetframe)
library(tidyverse)
library(plotly)
library(lubridate)
library(svglite)

# Helper Functions
makeNamedList <- function(...) {
  structure(list(...), names = as.list(substitute(list(...)))[-1L])
}

################################################################################
## Data de Atualizacao
################################################################################
print("Atualizando data de atualizacao...")
file <- file("../web/last.update.txt")
writeLines(c(paste(now())), file)
close(file)

################################################################################
## Atualiza Plots
################################################################################
print("Atualizando plots...")
plots.para.atualizar <- makeNamedList(plot.forecast.exp.br, plot.tempo.dupl, est.tempo.dupl, proj.num.casos, plot.nowcast.cum, plot.tempo.dupl.municipio, plot.estimate.R0.municipio) # Graficos a serem atualizados
filenames <- names(plots.para.atualizar)
n <- length(plots.para.atualizar)

for (i in 1:n){
    graph.html <- ggplotly(plots.para.atualizar[[i]]) # GGPlot -> Plotly
    graph.svg <- plots.para.atualizar[[i]]
    filepath <- paste("../web/", filenames[i], sep="")
    ggsave(paste(filepath,".svg",sep=""), graph.svg) # SVG Static Plot
    saveWidget(frameableWidget(graph.html), file = paste(filepath,".html",sep=""), libdir="./libs") # HTML Interative Plot
}

################################################################################
## Atualiza plot.forecast.exp por estado
################################################################################
for (st in estados.para.atualizar) {
  graph.html <- ggplotly(estados.plot.forecast.exp.br[[st]]) # GGPlot -> Plotly
  graph.svg <- estados.plot.forecast.exp.br[[st]]
  filepath <- paste("../web/plot.forecast.exp.", tolower(st), sep="") # Atualiza plot.forecast.exp para estados
  ggsave(paste(filepath,".svg",sep=""), graph.svg) # SVG Static Plot
  saveWidget(frameableWidget(graph.html), file = paste(filepath,".html",sep=""), libdir="./libs") # HTML Interative Plot
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