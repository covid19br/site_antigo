source("funcoes.R")

################################################################################
## Funcao para projecao do n acumulado de casos por data do sintoma
################################################################################
#' Funcao para projecao do n acumulado de casos por data do sintoma
#' @param pred Data frame. Objeto `now.pred.zoo` gerado em prepara_dados_municipio_SP.R
#' @param pred.original Data frame. Objeto `now.pred.original` gerado em prepara_dados_municipio_SP.R
#' @param now.lista Lista. Objeto `now.lista` gerado em prepara_dados_municipio_SP.R
now.proj <- function(pred, 
                     pred.original, 
                     now.lista,
                     n.dias = 5){
    ## N de dias para projetar: 5 dias a partir da data atual
    ## Adiciona ao forecast dias entre a ultima data de nocasting e o dia atual
    days.to.forecast <- as.integer(Sys.Date() - max(time(pred)) + n.dias)
    ## Objeto zoo com n de casos previstos pelo nowcasting concatenados com o n de casos
    ## projetado a partir do nowcasting acumulado com regressão Poisson
    now.proj.zoo <- merge(
        now.mean.c = c(forecast.exponential(pred$estimate.merged.c,
                                            start = length(time(pred)) - 4,
                                            days.forecast = days.to.forecast)$predito,
                       pred$estimate.merged.c),
        
        now.low.c = c(forecast.exponential(pred$lower.merged.c,
                                           start = length(time(pred)) - 4,
                                           days.forecast = days.to.forecast)$predito,
                      pred$lower.merged.c),
        
        now.upp.c = c(forecast.exponential(pred$upper.merged.c,
                                           start = length(time(pred)) - 4,
                                           days.forecast = days.to.forecast)$predito,
                      pred$upper.merged.c)
    )
    ## Adiciona vetor com n de casos notificados e os previstos para os proximos dias pela projecao
    ## Previsto de casos notificados é calculado a partir das ditribuicoes de atrasos do nowcasting
    ## N de dias que foram corrigidos por nowcating
    ndias.now <- nrow(pred.original)
    now.proj.zoo$not.mean <- c(pred$n.casos,
                               estima.not(diff(now.proj.zoo$now.mean.c[(nrow(now.proj.zoo) - ndias.now):nrow(now.proj.zoo)]),
                                          now.lista,
                                          from = ndias.now - days.to.forecast + 1))
    now.proj.zoo$not.low <- c(pred$n.casos,
                              estima.not(diff(now.proj.zoo$now.low.c[(nrow(now.proj.zoo) - ndias.now):nrow(now.proj.zoo)]),
                                         now.lista,
                                         from = ndias.now - days.to.forecast + 1))
    now.proj.zoo$not.upp <- c(pred$n.casos,
                              estima.not(diff(now.proj.zoo$now.upp.c[(nrow(now.proj.zoo) - ndias.now):nrow(now.proj.zoo)]),
                                         now.lista,
                                         from = ndias.now - days.to.forecast + 1))
    ##Calcula n de casos cumulativos
    now.proj.zoo$not.mean.c <- cumsum(now.proj.zoo$not.mean)
    now.proj.zoo$not.low.c <- cumsum(now.proj.zoo$not.low)
    now.proj.zoo$not.upp.c <- cumsum(now.proj.zoo$not.upp)
    return(now.proj.zoo)
}
################################################################################

# COVID #### 
now.proj.zoo <- now.proj(pred = lista.covid$now.pred.zoo, 
                         pred.original = lista.covid$now.pred.original, 
                         now.lista = lista.covid$now.lista)

# SRAG ####
now.srag.proj.zoo <-  now.proj(pred = lista.srag$now.pred.zoo, 
                               pred.original = lista.srag$now.pred.original, 
                               now.lista = lista.srag$now.lista)

# OBITOS COVID ####
now.ob.covid.proj.zoo <-  now.proj(pred = lista.ob.covid$now.pred.zoo, 
                                   pred.original = lista.ob.covid$now.pred.original, 
                                   now.lista = lista.ob.covid$now.lista)

# OBITOS SRAG ####
now.ob.srag.proj.zoo <-  now.proj(pred = lista.ob.srag$now.pred.zoo, 
                                  pred.original = lista.ob.srag$now.pred.original, 
                                  now.lista = lista.ob.srag$now.lista)

################################################################################
## Cálculo do R efetivo ##
################################################################################
## COVID ##
Re.now <- Re.com.data(ncasos = lista.covid$now.pred.zoo$upper.merged, datas = time(lista.covid$now.pred.zoo), delay = 7)
## Objeto time series indexado pela data de fim de cada janela de cálculo
Re.now.zoo <- zoo(Re.now$R[, -(12:13)], Re.now$R[, 13]) 

## SRAG ##
Re.now.srag <- Re.com.data(ncasos = lista.srag$now.pred.zoo$upper.merged, datas = time(lista.srag$now.pred.zoo), delay = 7)
## Objeto time series indexado pela data de fim de cada janela de cálculo
Re.now.srag.zoo <- zoo(Re.now.srag$R[, -(12:13)], Re.now.srag$R[, 13]) 

################################################################################
## Cálculo do tempo de duplicação ##
################################################################################

## COVID ##
td.now <- dt.rw(lista.covid$now.pred.zoo$estimate.merged.c, window.width = 5)
## Conveniencia: reordena e renomeia as colunas do objeto resultante
td.now <- td.now[, c(1, 3, 2)]
names(td.now) <- c("estimativa", "ic.inf", "ic.sup")

## SRAG ##
td.now.srag <- dt.rw(lista.srag$now.pred.zoo$estimate.merged.c, window.width = 5)
## Conveniencia: reordena e renomeia as colunas do objeto resultante
td.now.srag <- td.now.srag[, c(1, 3, 2)]
names(td.now.srag) <- c("estimativa", "ic.inf", "ic.sup")

## OBITOS COVID ##
td.now.ob.covid <- dt.rw(lista.ob.covid$now.pred.zoo$estimate.merged.c, window.width = 5)
## Conveniencia: reordena e renomeia as colunas do objeto resultante
td.now.ob.covid <- td.now.ob.covid[, c(1, 3, 2)]
names(td.now.ob.covid) <- c("estimativa", "ic.inf", "ic.sup")

## OBITOS SRAG ##
td.now.ob.srag <- dt.rw(lista.ob.srag$now.pred.zoo$estimate.merged.c, window.width = 5)
## Conveniencia: reordena e renomeia as colunas do objeto resultante
td.now.ob.srag <- td.now.ob.srag[, c(1, 3, 2)]
names(td.now.ob.srag) <- c("estimativa", "ic.inf", "ic.sup")


#### Corta a partir do dia com >= 10 casos ####

## COVID ##
dia.zero <- time(lista.covid$now.pred.zoo)[min(which(lista.covid$now.pred.zoo$n.casos >= 10, arr.ind = TRUE))]
now.pred.zoo <- window(lista.covid$now.pred.zoo, start = dia.zero)
now.proj.zoo <- window(now.proj.zoo, start = dia.zero)

## SRAG ##
dia.zero.srag <- time(lista.srag$now.pred.zoo)[min(which(lista.srag$now.pred.zoo$n.casos >= 10, arr.ind = TRUE))]
now.srag.pred.zoo <- window(lista.srag$now.pred.zoo, start = dia.zero.srag)
now.srag.proj.zoo <- window(now.srag.proj.zoo, start = dia.zero.srag)

## OBITO COVID ##
dia.zero.ob.covid <- time(lista.ob.covid$now.pred.zoo)[min(which(lista.ob.covid$now.pred.zoo$n.casos >= 10, arr.ind = TRUE))]
now.ob.covid.pred.zoo <- window(lista.ob.covid$now.pred.zoo, start = dia.zero.ob.covid)
now.ob.covid.proj.zoo  <- window(now.ob.covid.proj.zoo, start = dia.zero.ob.covid)

## OBITO SRAG ##
dia.zero.ob.srag <- time(lista.ob.srag$now.pred.zoo)[min(which(lista.ob.srag$now.pred.zoo$n.casos >= 10, arr.ind = TRUE))]
now.ob.srag.pred.zoo <- window(lista.ob.srag$now.pred.zoo, start = dia.zero.ob.srag)
now.ob.srag.proj.zoo  <- window(now.ob.srag.proj.zoo, start = dia.zero.ob.srag)

