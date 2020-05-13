################################################################################
## Funcao para projecao do n acumulado de casos por data do sintoma
################################################################################
#' Funcao para projecao do n acumulado de casos por data do sintoma
#' @param pred Data frame. Objeto `now.pred.zoo` gerado em prepara_nowcasting.R
#' @param pred.original Data frame. Objeto `now.pred.original` gerado em prepara_nowcasting.R
#' @param now.lista Lista. Objeto `now.lista` gerado em prepara_dados_nowcasting.R
#' @param now.params.post Data frame. Objeto `now.params.post` gerado em gerado em prepara_dados_nowcasting.R
now.proj <- function(pred, 
                     pred.original, 
                     now.params.post,
                     n.dias = 5) {
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
                                          NobBS.params.post = now.params.post,
                                          from = ndias.now - days.to.forecast + 1))
    now.proj.zoo$not.low <- c(pred$n.casos,
                              estima.not(diff(now.proj.zoo$now.low.c[(nrow(now.proj.zoo) - ndias.now):nrow(now.proj.zoo)]),
                                         NobBS.params.post = now.params.post,
                                         from = ndias.now - days.to.forecast + 1))
    now.proj.zoo$not.upp <- c(pred$n.casos,
                              estima.not(diff(now.proj.zoo$now.upp.c[(nrow(now.proj.zoo) - ndias.now):nrow(now.proj.zoo)]),
                                         NobBS.params.post = now.params.post,
                                         from = ndias.now - days.to.forecast + 1))
    ##Calcula n de casos cumulativos
    
    now.proj.zoo$not.mean.c <- cumsum(na.zero(now.proj.zoo$not.mean))
    now.proj.zoo$not.low.c <- cumsum(na.zero(now.proj.zoo$not.low))
    now.proj.zoo$not.upp.c <- cumsum(na.zero(now.proj.zoo$not.upp))
    return(now.proj.zoo)
}
