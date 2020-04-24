## Bibliotecas necessarias
library(zoo)

## Funcoes
source("funcoes.R")

## Leitura dos dados
brasil.raw <- read.csv("../dados/BrasilCov19.csv", as.is = TRUE)

## Cria objeto da classe zoo 
brasil <- zoo(brasil.raw[, 2:3], as.Date(brasil.raw$data, "%Y-%m-%d"))

## Tira os casos acumulados iniciais abaixo de um mínimo
minimo <- 15 ## pelo menos 15 casos
brasil.d0 <- diazero(brasil$casos.acumulados, limite = minimo)
## Dados do IVIS: suspeitos, descartados e confirmados