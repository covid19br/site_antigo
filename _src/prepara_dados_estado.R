## Bibliotecas necessarias
library(zoo)

## Funcoes
source("funcoes.R")

## Leitura dos dados
estados.raw <- read.csv("../dados/EstadosCov19.csv", as.is=TRUE)

minimo = 15
## Cria as tabelas necessárias
estados <- list()
estados.d0 <- list()
for(st in unique(estados.raw$estado)){
  if(exists("estados.para.atualizar") && ! (st %in% estados.para.atualizar))
    next
  estado.raw <- estados.raw[estados.raw$estado == st,]
  if (estado.raw$casos.acumulados[nrow(estado.raw)] <= minimo)
    next
  estados[[st]] <- zoo(estado.raw[,c("novos.casos","casos.acumulados")],
                       as.Date(estado.raw$data, "%Y-%m-%d"))
  estados.d0[[st]] <- diazero(estados[[st]]$casos.acumulados, limite = minimo)
}

