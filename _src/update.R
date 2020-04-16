# Libraries
library(rmarkdown)

# Helper Functions
makeNamedList <- function(...) {
  structure(list(...), names = as.list(substitute(list(...)))[-1L])
}

estados.para.atualizar <- c('SP', 'RJ') # Estados a serem atualizados

# Processamento de Dados
source('prepara_dados.R')
source('ajuste_projecao_exponencial.R')

# Geracao dos graficos
source('plots.R')

# Atualizacao do conteudo do site
# Atualizacao
plots.para.atualizar <- makeNamedList(plot.forecast.exp.br, plot.tempo.dupl, est.tempo.dupl, proj.num.casos) # Graficos a serem atualizados
tables.para.atualizar <- c(serie.temp.table) # Tabelas a serem atualizadas
# Graficos, tabelas e horário
source('update_web.R')