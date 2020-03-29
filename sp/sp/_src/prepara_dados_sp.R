## Bibliotecas necessarias
library(zoo)

## Funcoes
source("../sp/_src/funcoes_sp.R")
## Leitura dos dados
sampa.raw <- read.csv("../dados/sampa.csv", as.is = TRUE)
## Cria objeto da classe zoo 
sampa <- zoo(sampa.raw[, 2:3], as.Date(sampa.raw$dia, "%Y-%m-%d")) 
## Tira os casos acumulados iniciais abaixo de um mínimo
minimo <- 15 ## pelo menos 15 casos
sampa.d0 <- diazero(sampa$casos.acumulados, limite = minimo)

