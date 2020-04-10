## Pacotes necessários
library(zoo)
library(dplyr)


## Diretorio dos arquivos das bases
nome.dir <- "../dados/municipio_SP/" 
## Retira datas dos sufixos dos nomes das bases e identifica a maior data
## Só funciona se os nomes das bases forem mantidos
data.base <- dir(nome.dir, pattern = "nowcasting_covid_20") %>%
    substr(start = 18, stop = 27) %>%
    as.Date(format = "%Y_%m_%d") %>%
    max() %>%
    format("%Y_%m_%d")
## Importa dados em objetos de séries temporais (zoo)
## Serie completa de n de notificacoes
n.notificados <- read.csv(paste0(nome.dir,"notificacoes_covid_",data.base,".csv"))
n.notificados.zoo <- with(n.notificados, zoo(n.notific,as.Date(dt_notific)))
## Previsoes de nowcasting e n de casos por data de inicio do sintoma
now.pred <- read.csv(paste0(nome.dir, "nowcasting_covid_previstos_",data.base,".csv"))
now.pred.zoo <- zoo(now.pred[,c("estimate", "lower", "upper")], as.Date(now.pred[,"onset_date"]))
## N de casos por data de sintoma
n.sintoma <- read.csv(paste0(nome.dir,"n_casos_data_sintoma_covid_",data.base,".csv"))
n.sintoma.zoo <- with(n.sintoma, zoo(n.casos,as.Date(dt_sin_pri)))
## Junta todos os casos por data de sintoma com previsao do nowcasting (que só tem os ultimos 30 dias)
## VERIFICAR: Total de casos reportado por data do nowcasting tem diferenças com total de casos por data de sintoma tabulado
now.pred.zoo <- merge(n.casos=n.sintoma.zoo, now.pred.zoo)
