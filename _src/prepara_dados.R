## Bibliotecas necessarias
library(zoo)

## Funcoes
source("funcoes.R")

## Leitura dos dados
brasil.raw <- read.csv("../dados/BrasilCov19.csv", as.is = TRUE)
estados.raw <- read.csv("../dados/EstadosCov19.csv", as.is=TRUE)

## Cria objeto da classe zoo 
brasil <- zoo(brasil.raw[, 2:3], as.Date(brasil.raw$data, "%Y-%m-%d"))

## Tira os casos acumulados iniciais abaixo de um mínimo
minimo <- 15 ## pelo menos 15 casos
brasil.d0 <- diazero(brasil$casos.acumulados, limite = minimo)
## Dados do IVIS: suspeitos, descartados e confirmados

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