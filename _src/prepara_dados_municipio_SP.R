## Pacotes necessários
library(zoo)
library(dplyr)
source("funcoes.R")

## Diretorio dos arquivos das bases
nome.dir <- "../dados/municipio_SP/"
################################################################################
## Dados e nowcastings COVID
################################################################################
## Retira datas dos sufixos dos nomes das bases e identifica a maior data
## Só funciona se os nomes das bases forem mantidos no padrão
data.base <- dir(nome.dir, pattern = "nowcasting_covid_previstos_20") %>%
    substr(start = 28, stop = 37) %>%
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
## Media movel da estimativa e dos limites superior e inferiors
now.pred.zoo$estimate.merged.smooth <- rollapply(now.pred.zoo$estimate.merged, width = 10, mean, partial=TRUE)
now.pred.zoo$lower.merged.smooth <- rollapply(now.pred.zoo$lower.merged, width = 10, mean, partial=TRUE)
now.pred.zoo$upper.merged.smooth <- rollapply(now.pred.zoo$upper.merged, width = 10, mean, partial=TRUE)

## n cumulativo
now.pred.zoo$estimate.merged.c <- cumsum(now.pred.zoo$estimate.merged)
now.pred.zoo$lower.merged.c <- cumsum(now.pred.zoo$lower.merged)
now.pred.zoo$upper.merged.c <- cumsum(now.pred.zoo$upper.merged)

## Atualiza tb o data.frame
now.pred <- as.data.frame(now.pred.zoo)
now.pred$onset_date <- as.Date(rownames(now.pred))
now.pred <- now.pred[,c(11,1:10)]

## Distribuições posteriores dos parâmetros do nowcasting
now.post <- read.csv(paste0(nome.dir, "nowcasting_covid_post_",data.base,".csv"))

## Lista com todos os resultados no nowcasting
## now.lista <- readRDS(paste0(nome.dir, "nowcasting_covid_",data.base,".rds"))

################################################################################
## Dados e nowcastings SRAG
################################################################################
## Retira datas dos sufixos dos nomes das bases e identifica a maior data
## Só funciona se os nomes das bases forem mantidos no padrão
data.base <- dir(nome.dir, pattern = "nowcasting_srag_previstos_20") %>%
    substr(start = 27, stop = 36) %>%
    as.Date(format = "%Y_%m_%d") %>%
    max() %>%
    format("%Y_%m_%d")
## Importa dados em objetos de séries temporais (zoo)
## Serie completa de n de notificacoes
n.notificados.srag <- read.csv(paste0(nome.dir,"notificacoes_srag_",data.base,".csv"))
n.notificados.srag.zoo <- with(n.notificados.srag, zoo(n.notific,as.Date(dt_notific)))
## Previsoes de nowcasting e n de casos por data de inicio do sintoma
now.srag.pred.original <- read.csv(paste0(nome.dir, "nowcasting_srag_previstos_",data.base,".csv"))
now.srag.pred.zoo.original <- zoo(now.srag.pred.original[,c("estimate", "lower", "upper")], as.Date(now.srag.pred.original[,"onset_date"]))
## N de casos por data de sintoma
n.sintoma.srag <- read.csv(paste0(nome.dir,"n_casos_data_sintoma_srag_",data.base,".csv"))
n.sintoma.srag.zoo <- with(n.sintoma.srag, zoo(n.casos,as.Date(dt_sin_pri)))
## Junta todos os casos por data de sintoma com previsao do nowcasting (que só tem os ultimos 40 dias)
## VERIFICAR: Total de casos reportado por data do nowcasting tem diferenças com total de casos por data de sintoma tabulado
now.srag.pred.zoo <- merge(n.casos=n.sintoma.srag.zoo, now.srag.pred.zoo.original)
## Retira os dias ara os quais há n de casos observados mas nao nowcasting
now.srag.pred.zoo <- window(now.srag.pred.zoo, start=min(time(n.sintoma.srag.zoo)), end = max(time(now.srag.pred.zoo.original)))
## Adiciona variavel de novos casos merged:
## junta os valores corrigidos por nowcasting (que em geral vai até um certo ponto no passado)
## e n de casos observados antes da data em que começa a correção de nowcasting
now.srag.pred.zoo$estimate.merged <- with(now.srag.pred.zoo, preenche.now(estimate, n.casos))
now.srag.pred.zoo$lower.merged <- with(now.srag.pred.zoo, preenche.now(lower, n.casos))
now.srag.pred.zoo$upper.merged <- with(now.srag.pred.zoo, preenche.now(upper, n.casos))
## Media movel da estimativa e dos limites superior e inferiors
now.srag.pred.zoo$estimate.merged.smooth <- rollapply(now.srag.pred.zoo$estimate.merged, width = 10, mean, partial=TRUE)
now.srag.pred.zoo$lower.merged.smooth <- rollapply(now.srag.pred.zoo$lower.merged, width = 10, mean, partial=TRUE)
now.srag.pred.zoo$upper.merged.smooth <- rollapply(now.srag.pred.zoo$upper.merged, width = 10, mean, partial=TRUE)

## n cumulativo
now.srag.pred.zoo$estimate.merged.c <- cumsum(now.srag.pred.zoo$estimate.merged)
now.srag.pred.zoo$lower.merged.c <- cumsum(now.srag.pred.zoo$lower.merged)
now.srag.pred.zoo$upper.merged.c <- cumsum(now.srag.pred.zoo$upper.merged)

## Atualiza tb o data.frame
now.srag.pred <- as.data.frame(now.srag.pred.zoo)
now.srag.pred$onset_date <- as.Date(rownames(now.srag.pred))
now.srag.pred <- now.srag.pred[,c(11,1:10)]

## Distribuições posteriores dos parâmetros do nowcasting
now.srag.post <- read.csv(paste0(nome.dir, "nowcasting_srag_post_",data.base,".csv"))

## Lista com todos os resultados no nowcasting
## now.srag.lista <- readRDS(paste0(nome.dir, "nowcasting_srag_",data.base,".rds"))
