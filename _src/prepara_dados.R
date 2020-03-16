## Bibliotecas necessarias
library(zoo)
## Leitura dos dados
brasil.raw <- read.csv("../dados/brasil.csv", as.is = TRUE)
## Converte campo de datas para formato Date
## Cria objeto da classe zoo 
brasil <- zoo(brasil.raw[, 2:3], as.Date(brasil.raw$dia, "%d-%m-%Y")) 
