source("funcoes.R")

################################################################################
## Projecao do n acumulado de casos por data do sintoma
################################################################################
## COVID ##
## N de dias para projetar: 5 dias a partir da data atual
## Adiciona ao forecast dias entre a ultima data de nocasting e o dia atual
days.to.forecast <- as.integer(Sys.Date()-max(time(now.pred.zoo)) + 5)
## Objeto zoo com n de casos previstos pelo nowcasting concatenados com o n de casos
## projetado a partir do nowcasting acumulado com regressão Poisson
now.proj.zoo <- merge(
    now.mean.c = c(forecast.exponential(now.pred.zoo$estimate.merged.c,
                                    start = length(time(now.pred.zoo))-4,
                                    days.forecast = days.to.forecast)$predito,
               now.pred.zoo$estimate.merged.c),
    
    now.low.c = c(forecast.exponential(now.pred.zoo$lower.merged.c,
                                     start = length(time(now.pred.zoo))-4,
                                     days.forecast = days.to.forecast)$predito,
                now.pred.zoo$lower.merged.c),
    
    now.upp.c = c(forecast.exponential(now.pred.zoo$upper.merged.c,
                                     start = length(time(now.pred.zoo))-4,
                                     days.forecast = days.to.forecast)$predito,
                now.pred.zoo$upper.merged.c)
)
## Adiciona vetor com n de casos notificados e os previstos para os proximos dias pela projecao
## Previsto de casos notificados é calculado a partir das ditribuicoes de atrasos do nowcasting
## N de dias que foram corrigidos por nowcating
ndias.now <- nrow(now.pred.original)
now.proj.zoo$not.mean <- c(now.pred.zoo$n.casos,
                           estima.not(diff(now.proj.zoo$now.mean.c[(nrow(now.proj.zoo)-ndias.now):nrow(now.proj.zoo)]),
                                           now.lista,
                                      from = ndias.now-days.to.forecast+1))
now.proj.zoo$not.low <- c(now.pred.zoo$n.casos,
                           estima.not(diff(now.proj.zoo$now.low.c[(nrow(now.proj.zoo)-ndias.now):nrow(now.proj.zoo)]),
                                           now.lista,
                                      from = ndias.now-days.to.forecast+1))
now.proj.zoo$not.upp <- c(now.pred.zoo$n.casos,
                           estima.not(diff(now.proj.zoo$now.upp.c[(nrow(now.proj.zoo)-ndias.now):nrow(now.proj.zoo)]),
                                           now.lista,
                                           from = ndias.now-days.to.forecast+1))
##Calcula n de casos cumulativos
now.proj.zoo$not.mean.c <- cumsum(now.proj.zoo$not.mean)
now.proj.zoo$not.low.c <- cumsum(now.proj.zoo$not.low)
now.proj.zoo$not.upp.c <- cumsum(now.proj.zoo$not.upp)

################################################################################

## SRAG ##

## N de dias para projetar: 5 dias a partir da data atual
## Adiciona ao forecast dias entre a ultima data de nocasting e o dia atual
days.to.forecast.srag <- as.integer(Sys.Date()-max(time(now.srag.pred.zoo)) + 5)
## Objeto zoo com n de casos previstos pelo nowcasting concatenados com o n de casos
## projetado a partir do nowcasting acumulado com regressão Poisson
now.srag.proj.zoo <- merge(
    now.mean.c = c(forecast.exponential(now.srag.pred.zoo$estimate.merged.c,
                                    start = length(time(now.srag.pred.zoo))-4,
                                    days.forecast = days.to.forecast.srag)$predito,
               now.srag.pred.zoo$estimate.merged.c),
        now.low.c = c(forecast.exponential(now.srag.pred.zoo$lower.merged.c,
                                     start = length(time(now.srag.pred.zoo))-4,
                                     days.forecast = days.to.forecast.srag)$predito,
                now.srag.pred.zoo$lower.merged.c),
        now.upp.c = c(forecast.exponential(now.srag.pred.zoo$upper.merged.c,
                                     start = length(time(now.srag.pred.zoo))-4,
                                     days.forecast = days.to.forecast.srag)$predito,
                now.srag.pred.zoo$upper.merged.c)
)
## Adiciona vetor com n de casos notificados e os previstos para os proximos dias pela projecao
## Previsto de casos notificados é calculado a partir das ditribuicoes de atrasos do nowcasting
## N de dias que foram corrigidos por nowcating
ndias.now.srag <- nrow(now.srag.pred.original)
now.srag.proj.zoo$not.mean <- c(now.srag.pred.zoo$n.casos,
                           estima.not(diff(now.srag.proj.zoo$now.mean.c[(nrow(now.srag.proj.zoo)-ndias.now.srag):nrow(now.srag.proj.zoo)]),
                                           now.srag.lista,
                                      from = ndias.now.srag-days.to.forecast.srag+1))
now.srag.proj.zoo$not.low <- c(now.srag.pred.zoo$n.casos,
                           estima.not(diff(now.srag.proj.zoo$now.low.c[(nrow(now.srag.proj.zoo)-ndias.now.srag):nrow(now.srag.proj.zoo)]),
                                           now.srag.lista,
                                      from = ndias.now.srag-days.to.forecast.srag+1))
now.srag.proj.zoo$not.upp <- c(now.srag.pred.zoo$n.casos,
                           estima.not(diff(now.srag.proj.zoo$now.upp.c[(nrow(now.srag.proj.zoo)-ndias.now.srag):nrow(now.srag.proj.zoo)]),
                                           now.srag.lista,
                                           from = ndias.now.srag-days.to.forecast.srag+1))
##Calcula n de casos cumulativos
now.srag.proj.zoo$not.mean.c <- cumsum(now.srag.proj.zoo$not.mean)
now.srag.proj.zoo$not.low.c <- cumsum(now.srag.proj.zoo$not.low)
now.srag.proj.zoo$not.upp.c <- cumsum(now.srag.proj.zoo$not.upp)



################################################################################
## Cálculo do R efetivo ##
################################################################################
## COVID ##
Re.now <- Re.com.data(ncasos = now.pred.zoo$upper.merged, datas = time(now.pred.zoo), delay = 7)
## Objeto time series indexado pela data de fim de cada janela de cálculo
Re.now.zoo <- zoo(Re.now$R[,-(12:13)], Re.now$R[,13]) 

## SRAG ##
Re.now.srag <- Re.com.data(ncasos = now.srag.pred.zoo$upper.merged, datas = time(now.srag.pred.zoo), delay = 7)
## Objeto time series indexado pela data de fim de cada janela de cálculo
Re.now.srag.zoo <- zoo(Re.now.srag$R[,-(12:13)], Re.now.srag$R[,13]) 

################################################################################
## Cálculo do tempo de duplicação ##
################################################################################

## COVID ##
td.now <- dt.rw(now.pred.zoo$estimate.merged.c, window.width = 5)
## Conveniencia: reordena e renomeia as colunas do objeto resultante
td.now <- td.now[,c(1,3,2)]
names(td.now) <- c("estimativa", "ic.inf", "ic.sup")


## SRAG ##
td.now.srag <- dt.rw(now.srag.pred.zoo$estimate.merged.c, window.width = 5)
## Conveniencia: reordena e renomeia as colunas do objeto resultante
td.now.srag <- td.now.srag[,c(1,3,2)]
names(td.now.srag) <- c("estimativa", "ic.inf", "ic.sup")

#### Corta a partir do dia com >= 10 casos ####

## COVID ##
dia.zero <- time(now.pred.zoo)[min(which(now.pred.zoo$n.casos>=10, arr.ind=TRUE))]
now.pred.zoo <- window(now.pred.zoo, start=dia.zero)
now.proj.zoo <- window(now.proj.zoo, start=dia.zero)
td.now <- window(td.now, start = dia.zero)

## SRAG ##
dia.zero.srag <- time(now.srag.pred.zoo)[min(which(now.srag.pred.zoo$n.casos>=10, arr.ind = TRUE))]
now.srag.pred.zoo <- window(now.srag.pred.zoo, start=dia.zero.srag)
now.srag.proj.zoo <- window(now.srag.proj.zoo, start=dia.zero.srag)
td.now.srag <- window(td.now.srag, start = dia.zero.srag)

