## Pacotes necessários
library(zoo)
library(dplyr)
library(stringr)
source("funcoes.R")

################################################################################
## Funcao para ajudar no processo 
################################################################################
#' Função para automatizar a preparação dos dados por municipio
#' @details Retira datas dos sufixos dos nomes das bases e identifica a maior data. Só funciona se os nomes das bases forem mantidos no padrão
#' @param tipo Caractere. Nome da base de dados para preparar. Tipos possíveis: `covid` para casos de COVID-19, `srag` para casos de SRAG, `obitos_covid` para óbitos por COVID-19 e `obitos_srag` para óbitos por SRAG
prepara.dados.muni <- function(tipo = "covid") { # tipos possiveis: covid, srag, obitos_covid e obitos_srag
    casos <- c("covid", "srag")
    obitos <- c("obitos_covid", "obitos_srag")
    nome.dir <- "../dados/municipio_SP/"
    data.base <- dir(nome.dir, pattern = paste0("nowcasting_", tipo, "_20")) %>% 
      stringr::str_extract("(19|20)\\d\\d[_ /.](0[1-9]|1[012])[_ /.](0[1-9]|[12][0-9]|3[01])") %>% #prfct
        as.Date(format = "%Y_%m_%d") %>%
        max() %>%
        format("%Y_%m_%d")
    ## Importa dados em objetos de séries temporais (zoo)
    ## Serie completa de n de notificacoes
    n.notificados <- read.csv(paste0(nome.dir,"notificacoes_", tipo, "_", data.base,".csv"))
    
    #rename columns forever to unify the analyses
    # srm: colocando tambem condicao para definir no nome em n.sintoma
    if (tipo %in% casos) {
      n.notificados <- n.notificados %>%
        rename(dt_col = "dt_notific")
      nome.sint <- "n_casos_data_sintoma_"
    }
    if (tipo %in% obitos) {
      n.notificados <- n.notificados %>% 
        rename(dt_col = "dt_encerra") #ast isto é uma das coisas que muda mas tem que ser um rename 
      nome.sint <- "n_casos_data_"
    }
    n.notificados.zoo <- with(n.notificados, zoo(n.notific, as.Date(dt_col)))#%ast aqui estou usando a renomeada
    
    ## Previsoes de nowcasting e n de casos por data de inicio do sintoma %ast aqui não precisa mudar porque tudo é onset_date
    now.pred.original <- read.csv(paste0(nome.dir, "nowcasting_", tipo, "_previstos_", data.base, ".csv"))
    now.pred.zoo.original <- zoo(now.pred.original[,c("estimate", "lower", "upper")], 
                                 as.Date(now.pred.original[,"onset_date"]))
    
    ## N de casos por data de sintoma
    n.sintoma <- read.csv(paste0(nome.dir, nome.sint, tipo, "_", data.base, ".csv"))#este paste tao especifico nao pode porque sintomas é obitos também agora
   #daí tava tentando um list.files tipo
    #file.sintoma <- list.files(path = nome.dir, pattern = paste0("n_casos_data.+", tipo), full.names = T)#isto está funcionando para tipo obito_covid que me serve mas nao vai servir para todos
    #n.sintoma <- read.csv(file.sintoma)
    #o problema é que tipo obito_xxx contém xxx entao nao faz bem o subset. a opção seria renomear as colunas de n_casos_obitos ou n_casos_sintomas como nas linhas 29 e 34. (ou renomear na hora de salvar? ou no inicio do script?
    #names(n.sintoma)
    # adicionando condicao para 
    if (tipo %in% casos)
      n.sintoma.zoo <- with(n.sintoma, zoo(n.casos, as.Date(dt_sin_pri)))
    if (tipo %in% obitos)
      n.sintoma.zoo <- with(n.sintoma, zoo(n.casos, as.Date(dt_evoluca)))#ast aqui igual, dt_sin_pri é dt_evoluca no caso dos obitos
    
    ## Junta todos os casos por data de sintoma com previsao do nowcasting (que só tem os ultimos 40 dias)
    ## VERIFICAR: Total de casos reportado por data do nowcasting tem diferenças com total de casos por data de sintoma tabulado
    now.pred.zoo <- merge(n.casos = n.sintoma.zoo, now.pred.zoo.original)
    ## Retira os dias ara os quais há n de casos observados mas nao nowcasting
    now.pred.zoo <- window(now.pred.zoo, start = min(time(n.sintoma.zoo)), end = max(time(now.pred.zoo.original)))
    ## Adiciona variavel de novos casos merged:
    ## junta os valores corrigidos por nowcasting (que em geral vai até um certo ponto no passado)
    ## e n de casos observados antes da data em que começa a correção de nowcasting
    now.pred.zoo$estimate.merged <- with(now.pred.zoo, preenche.now(estimate, n.casos))
    now.pred.zoo$lower.merged <- with(now.pred.zoo, preenche.now(lower, n.casos))
    now.pred.zoo$upper.merged <- with(now.pred.zoo, preenche.now(upper, n.casos))
    ## Media movel da estimativa e dos limites superior e inferiors
    now.pred.zoo$estimate.merged.smooth <- rollapply(now.pred.zoo$estimate.merged, width = 10, mean, partial = TRUE)
    now.pred.zoo$lower.merged.smooth <- rollapply(now.pred.zoo$lower.merged, width = 10, mean, partial = TRUE)
    now.pred.zoo$upper.merged.smooth <- rollapply(now.pred.zoo$upper.merged, width = 10, mean, partial = TRUE)
    
    ## n cumulativo
    now.pred.zoo$estimate.merged.c <- cumsum(now.pred.zoo$estimate.merged)
    now.pred.zoo$lower.merged.c <- cumsum(now.pred.zoo$lower.merged)
    now.pred.zoo$upper.merged.c <- cumsum(now.pred.zoo$upper.merged)
    
    ## Atualiza tb o data.frame
    now.pred <- as.data.frame(now.pred.zoo)
    now.pred$onset_date <- as.Date(rownames(now.pred))
    now.pred <- now.pred[, c(11, 1:10)]
    
    ## Lista com todos os resultados no nowcasting
    now.lista <- readRDS(paste0(nome.dir, "nowcasting_", tipo, "_", data.base, ".rds"))
    
    # lista para salvar os objetos
    pred <- list(now.pred = now.pred, 
                 now.pred.zoo = now.pred.zoo, 
                 now.pred.original = now.pred.original, 
                 now.pred.zoo.original = now.pred.zoo.original,
                 now.lista = now.lista)
    
    return(pred)
}

################################################################################
## Dados e nowcastings COVID
################################################################################

lista.covid <- prepara.dados.muni(tipo = "covid")

################################################################################
## Dados e nowcastings SRAG
################################################################################

lista.srag <- prepara.dados.muni(tipo = "srag")

################################################################################
## Dados e nowcastings COVID OBITOS
################################################################################

lista.ob.covid <- prepara.dados.muni(tipo = "obitos_covid")

################################################################################
## Dados e nowcastings SRAG OBITOS
################################################################################

lista.ob.srag <- prepara.dados.muni(tipo = "obitos_srag")
