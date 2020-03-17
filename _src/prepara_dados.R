## Bibliotecas necessarias
library(zoo)
## Funcoes
source("funcoes.R")
## Leitura dos dados
brasil.raw <- read.csv("../dados/brasil.csv", as.is = TRUE)
## Cria objeto da classe zoo 
brasil <- zoo(brasil.raw[, 2:3], as.Date(brasil.raw$dia, "%d-%m-%Y")) 
## Tira os casos acumulados iniciais abaixo de um mínimo
minimo <- 15 ## pelo menos 15 casos
brasil.d0 <- diazero(brasil$casos.acumulados, limite = minimo)
