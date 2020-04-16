# Libraries
library(rmarkdown)

estados.para.atualizar <- c('SP', 'RJ') # Estados a serem atualizados

# Processamento de Dados
source('prepara_dados.R')
source('ajuste_projecao_exponencial.R')

# Geracao dos graficos
source('plots.R')

# Atualizacao do conteudo do site
# Graficos, tabelas e horário
source('update_web.R')