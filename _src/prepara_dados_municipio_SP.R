## Pacotes necessários
library(zoo)
library(dplyr)
source("funcoes.R")

## Diretorio dos arquivos das bases
nome.dir <- "../dados/municipio_SP/" 
## Retira datas dos sufixos dos nomes das bases e identifica a maior data
## Só funciona se os nomes das bases forem mantidos no padrão
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
now.pred.original <- read.csv(paste0(nome.dir, "nowcasting_covid_previstos_",data.base,".csv"))
now.pred.zoo.original <- zoo(now.pred.original[,c("estimate", "lower", "upper")], as.Date(now.pred.original[,"onset_date"]))
## N de casos por data de sintoma
n.sintoma <- read.csv(paste0(nome.dir,"n_casos_data_sintoma_covid_",data.base,".csv"))
n.sintoma.zoo <- with(n.sintoma, zoo(n.casos,as.Date(dt_sin_pri)))
## Junta todos os casos por data de sintoma com previsao do nowcasting (que só tem os ultimos 40 dias)
## VERIFICAR: Total de casos reportado por data do nowcasting tem diferenças com total de casos por data de sintoma tabulado
now.pred.zoo <- merge(n.casos=n.sintoma.zoo, now.pred.zoo.original)
## Retira os dias ara os quais há n de casos observados mas nao nowcasting
now.pred.zoo <- window(now.pred.zoo, start=min(time(n.sintoma.zoo)), end = max(time(now.pred.zoo.original)))
## Adiciona variavel de novos casos merged:
## junta os valores corrigidos por nowcasting (que em geral vai até um certo ponto no passado)
## e n de casos observados antes da data em que começa a correção de nowcasting
now.pred.zoo$estimate.merged <- with(now.pred.zoo, preenche.now(estimate, n.casos))
now.pred.zoo$lower.merged <- with(now.pred.zoo, preenche.now(lower, n.casos))
now.pred.zoo$upper.merged <- with(now.pred.zoo, preenche.now(upper, n.casos))
## n cumulativo
now.pred.zoo$estimate.merged.c <- cumsum(now.pred.zoo$estimate.merge)
now.pred.zoo$lower.merged.c <- cumsum(now.pred.zoo$lower.merge)
now.pred.zoo$upper.merged.c <- cumsum(now.pred.zoo$upper.merge)

## Atualiza tb o data.frame
now.pred <- as.data.frame(now.pred.zoo)
now.pred$onset_date <- as.Date(rownames(now.pred))
now.pred <- now.pred[,c(11,1:10)]

## Lista com todos os resultados no nowcasting
now.lista <- readRDS(paste0(nome.dir, "nowcasting_covid_",data.base,".rds"))
