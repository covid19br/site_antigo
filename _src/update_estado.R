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

# Estados a serem atualizados
estados.para.atualizar <- c('AC', 'AL', 'AM', 'AP', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MG', 'MS', 'MT', 'PA', 'PB', 'PE', 'PI', 'PR', 'RJ', 'RN', 'RO', 'RR', 'RS', 'SC', 'SE', 'SP', 'TO') # manter ordem alfabetica

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
  filepath <- paste("../web/plot.forecast.exp.", tolower(st), sep="") # plot.forecast.exp para estados
  
  # widget interativo
  graph.html <- ggplotly(estados.plot.forecast.exp.br[[st]])
  saveWidget(frameableWidget(graph.html), file = paste(filepath,".html",sep=""), libdir="./libs") 
  
  # svg placeholder
  graph.svg <- estados.plot.forecast.exp.br[[st]] + theme(axis.text=element_text(size=6.65), # corrige a diferenca do tamanho do texto entre svg e html
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

}, error = function(cond){
    message(cond)
    quit(status = 1)
})

