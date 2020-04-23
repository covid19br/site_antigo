# Libraries
library(widgetframe)
library(tidyverse)
library(plotly)
library(lubridate)

# Helper Function
makeNamedList <- function(...) {
  structure(list(...), names = as.list(substitute(list(...)))[-1L])
}

estados.para.atualizar <- c('SP', 'RJ') # Estados a serem atualizados

# Processamento de Dados -separo por estado?-
source('prepara_dados_estado.R')
source('ajuste_projecao_exponencial_estado.R')

# Geracao dos graficos
source('plots_estados.R')

## Data de Atualizacao
print("Atualizando data de atualizacao...")
file <- file("../web/last.update.estado.txt")
writeLines(c(paste(now())), file)
close(file)

################################################################################
## Atualiza plot.forecast.exp por estado
################################################################################

for (st in estados.para.atualizar) {
  graph.html <- ggplotly(estados.plot.forecast.exp.br[[st]])  %>% layout(margin = list(l = 50, r = 50, b = 50, t = 50, pad = 4), title = list(y = 0.94))
  graph.svg <- estados.plot.forecast.exp.br[[st]] + theme(axis.text= element_text(size=11, face="plain"),
                                                          axis.title = element_text(size=14, face="plain"))
  filepath <- paste("../web/plot.forecast.exp.", tolower(st), sep="") # Atualiza plot.forecast.exp para estados
  saveWidget(frameableWidget(graph.html), file = paste(filepath,".html",sep=""), libdir="./libs") # HTML Interative Plot
  ggsave(paste(filepath,".svg",sep=""), plot = graph.svg, device = svg, scale= .8, width= 421, height = 285, units = "mm")

}


