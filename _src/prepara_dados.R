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
## Dados do IVIS: suspeitos, descartados e confirmados
brasil.ivis <- read.csv2("../dados/brutos-ivis/brazil.csv", as.is=TRUE, na.strings="-")
names(brasil.ivis) <- c("dia","Suspeitos","Confirmados","Descartados","Óbitos")
brasil.ivis <- brasil.ivis[, c(1,2,4,3,5)]
brasil.ivis$dia <- as.Date(brasil.ivis$dia, "%Y-%m-%d")
## objeto zoo
brasil.ivis.zoo <- zoo(brasil.ivis[,-1], brasil.ivis$dia)
