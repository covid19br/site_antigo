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
  filepath <- paste("../web/",filenames[i],sep="") # caminho do arquivo
  
  # widget interativo
  graph.html <- ggplotly(plots.para.atualizar[[i]])
  saveWidget(frameableWidget(graph.html), file = paste(filepath,".html",sep=""), libdir="./libs")

  # svg placeholder
  # extra large
  graph.svg <- plots.para.atualizar[[i]] + theme(axis.text=element_text(size=6.65), # corrige a diferenca do tamanho do texto entre svg e html
                                                 plot.margin = margin(10, 0, 0, 7, "pt")) # corrige a margem inserida pelo plotly
  ggsave(paste(filepath,".svg",sep=""), plot = graph.svg, device = svg, scale = 1, width = 215, height = 146, units = "mm")
  # tamanho calculado usando ppi = 141.21
  # o tamanho do texto no placeholder deve ser um fator de 0.665 do tamanho original
  
  # large
  graph.sm.svg <- graph.svg + theme(axis.text=element_text(size=8.65)) # corrige a diferenca do tamanho do texto entre svg e html
  ggsave(paste(filepath,".lg.svg",sep=""), plot = graph.sm.svg, device = svg, scale = 1, width = 215, height = 146, units = "mm")
  # medium
  graph.sm.svg <- graph.svg + theme(axis.text=element_text(size=12.65)) # corrige a diferenca do tamanho do texto entre svg e html
  ggsave(paste(filepath,".md.svg",sep=""), plot = graph.sm.svg, device = svg, scale = 1, width = 215, height = 146, units = "mm")
  # small
  graph.sm.svg <- graph.svg + theme(axis.text=element_text(size=16.65)) # corrige a diferenca do tamanho do texto entre svg e html
  ggsave(paste(filepath,".sm.svg",sep=""), plot = graph.sm.svg, device = svg, scale = 1, width = 215, height = 146, units = "mm")
  # extra small
  graph.sm.svg <- graph.svg + theme(axis.text=element_text(size=20.65)) # corrige a diferenca do tamanho do texto entre svg e html
  ggsave(paste(filepath,".ex.svg",sep=""), plot = graph.sm.svg, device = svg, scale = 1, width = 215, height = 146, units = "mm")
  
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

