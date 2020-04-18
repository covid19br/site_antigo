# Libraries
library(rmarkdown)

estados.para.atualizar <- c('SP', 'RJ') # Estados a serem atualizados

# Processamento de Dados
source('prepara_dados.R')
source("prepara_dados_municipio_SP.R")
source('ajuste_projecao_exponencial.R')
source("analises_municipio.R")

# Geracao dos graficos
source('plots.R')
source("plots_municipios.R")

# Atualizacao do conteudo do site
# Graficos, tabelas e horário
source('update_web.R')