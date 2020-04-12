source("funcoes.R")


################################################################################
## Projecao do n acumulado de casos por data do sintoma
################################################################################
##
now.exp.mean <-forecast.exponential(now.pred.zoo$estimate.merged.c,
                               start = length(time(now.pred.zoo))-4,
                               days.forecast = 7)
now.exp.lower <-forecast.exponential(now.pred.zoo$lower.merged.c,
                               start = length(time(now.pred.zoo))-4,
                               days.forecast = 7)
now.exp.upper <-forecast.exponential(now.pred.zoo$upper.merged.c,
                               start = length(time(now.pred.zoo))-4,
                               days.forecast = 7)

################################################################################
## Cálculo do R efetivo ##
################################################################################
Re.now <- Re.com.data(ncasos = now.pred.zoo$estimate.merged, datas = time(now.pred.zoo), delay = 7)
## Objeto time series indexado pela data de fim de cada janela de cálculo
Re.now.zoo <- zoo(Re.now$R[,-(12:13)], Re.now$R[,13]) 

################################################################################
## Cálculo do tempo de duplicação ##
################################################################################
td.now <- dt.rw(now.pred.zoo$estimate.merged.c, window.width = 5)
## Conveniencia: reordena e renomeia as colunas do objeto resultante
td.now <- td.now[,c(1,3,2)]
names(td.now) <- c("estimativa", "ic.inf", "ic.sup")
