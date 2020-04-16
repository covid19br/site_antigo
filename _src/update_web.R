# Atualizacao do conteudo do site

# Libraries
library(widgetframe)
library(tidyverse)
library(plotly)
library(lubridate)

# Helper Functions
makeNamedList <- function(...) {
  structure(list(...), names = as.list(substitute(list(...)))[-1L])
}

################################################################################
## Data de Atualizacao
################################################################################
file <- file("../web/last.update.txt")
writeLines(c(paste(now())), file)
close(file)

################################################################################
## Atualiza Plots
################################################################################
plots.para.atualizar <- makeNamedList(plot.forecast.exp.br, plot.tempo.dupl, est.tempo.dupl, proj.num.casos) # Graficos a serem atualizados
filenames <- names(plots.para.atualizar)
n <- length(plots.para.atualizar)

for (i in 1:n){
    graph <- ggplotly(plots.para.atualizar[[i]]) # GGPlot -> Plotly
    filepath <- paste("../web/",filenames[i],sep="")
    orca(graph, paste(filepath,".svg",sep="")) # SVG Static Plot
    saveWidget(frameableWidget(graph), file = paste(filepath,".html",sep=""), libdir="./libs") # HTML Interative Plot
}

################################################################################
## Atualiza plot.forecast.exp por estado
################################################################################
for (st in estados.para.atualizar) {
  graph <- ggplotly(estados.plot.forecast.exp.br[[st]]) # GGPlot -> Plotly
  filepath <- paste("../web/plot.forecast.exp.", st, sep="") # Atualiza plot.forecast.exp para estados
  orca(graph, paste(filepath,".svg",sep="")) # SVG Static Plot
  saveWidget(frameableWidget(graph), file = paste(filepath,".html",sep=""), libdir="./libs") # HTML Interative Plot
}

################################################################################
## Atualiza tabelas
################################################################################
tables.para.atualizar <- c(serie.temp.table) # Tabelas a serem atualizadas
names.tables <- makeNamedList(serie.temp.table) # Tabelas a serem atualizadas
filenames <- names(names.tables)
n <- length(tables.para.atualizar)

for (i in 1:n){
  filepath <- paste("../web/",filenames[i],sep="")
  filename <- paste(filepath,".html",sep="")
  write_file(tables.para.atualizar[i], filename)
}