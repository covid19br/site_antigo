source("funcoes.R")


################################################################################
## Projecao do n acumulado de casos por data do sintoma
################################################################################
## N de dias para projetar: 5 dias a partir da data atual
## Adiciona ao forecats dias entre a ultima data de nocasting e o dia atual
days.to.forecast <- as.integer(Sys.Date()-max(time(now.pred.zoo)) + 5)
## Objeto zoo com n de casos previstos pelo owcasting concatenados com o n de casos
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
## Previstod e casos notificados é calculado a partir das ditribuicoes de atrasos do nowcasting
now.proj.zoo$not.mean <- c(now.pred.zoo$n.casos,
                           estima.not(diff(now.proj.zoo$now.mean.c[(nrow(now.proj.zoo)-30):nrow(now.proj.zoo)]),
                                           now.lista,
                                      from = 30-days.to.forecast+1))
now.proj.zoo$not.low <- c(now.pred.zoo$n.casos,
                           estima.not(diff(now.proj.zoo$now.low.c[(nrow(now.proj.zoo)-30):nrow(now.proj.zoo)]),
                                           now.lista,
                                      from = 30-days.to.forecast+1))
now.proj.zoo$not.upp <- c(now.pred.zoo$n.casos,
                           estima.not(diff(now.proj.zoo$now.upp.c[(nrow(now.proj.zoo)-30):nrow(now.proj.zoo)]),
                                           now.lista,
                                           from = 30-days.to.forecast+1))
##Calcula n de casos cumulativos
now.proj.zoo$not.mean.c <- cumsum(now.proj.zoo$not.mean)
now.proj.zoo$not.low.c <- cumsum(now.proj.zoo$not.low)
now.proj.zoo$not.upp.c <- cumsum(now.proj.zoo$not.upp)


################################################################################
## Cálculo do R efetivo ##
################################################################################
Re.now <- Re.com.data(ncasos = now.pred.zoo$estimate.merged, datas = time(now.pred.zoo), delay = 7)
## Objeto time series indexado pela data de fim de cada janela de cálculo
Re.now.zoo <- zoo(Re.now$R[,-(12:13)], Re.now$R[,13]) 

################################################################################
## Cálculo do tempo de duplicação ##
################################################################################
td.now <- dt.rw(now.pred.zoo$estimate.merged.c, window.width = 7)
## Conveniencia: reordena e renomeia as colunas do objeto resultante
td.now <- td.now[,c(1,3,2)]
names(td.now) <- c("estimativa", "ic.inf", "ic.sup")

#### Corta a partir do dia com >= 10 casos ####
dia.zero <- time(now.pred.zoo)[min(which(now.pred.zoo$n.casos>=10, arr.ind=TRUE))]
now.pred.zoo <- window(now.pred.zoo, start=dia.zero)
now.proj.zoo <- window(now.proj.zoo, start=dia.zero)

