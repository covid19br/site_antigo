library(ggplot2)
library(zoo)

################################################################################
## Parametros de formatacao comum aos plots
################################################################################
plot.formatos <- theme_bw()+
    theme(axis.text= element_text(size=12, face="bold"),
          axis.title.y = element_text(size=14, face="bold"))


################################################################################
## Grafico da serie observada e do previsto pelo modelo exponencial
## para os proximos 5 dias (com intervalo de confiança)
################################################################################
## Serie com observados e previstos
## (gambiarra para ter linha contínua no graico, verificar hel de ggplot.zoo)
ncasos.completa <-c(brasil$casos.acumulados, exp.5d$predito)
plot.forecast.exp <-
    ggplot(ncasos.completa, aes(Index, ncasos.completa)) +
    geom_line(aes(Index, ncasos.completa), color="gray") +
    geom_point(data=brasil, aes(Index, casos.acumulados), size=2) +
    scale_x_date(#breaks=seq(min(time(ncasos.completa)), max(time(ncasos.completa)), by=3),
                date_labels = "%d/%b", name="") +
    ylim(0,max(exp.5d$ic.upp)) +
    geom_point(data=exp.5d, aes(Index,predito), col="blue", size=2) +
    geom_ribbon(data=exp.5d, aes(Index, predito, ymin=ic.low, ymax=ic.upp), fill="blue", alpha=0.25) +
    ylab("Número de casos") +
    plot.formatos
    
################################################################################
##Tempo de duplicacao calculado para uma janela de 5 dias, a partir do dia zero
################################################################################
plot.tempo.dupl <-
    ggplot(tempos.duplicacao, aes(Index, estimativa)) +
    geom_line(size = 1.25) +
    geom_ribbon(aes(ymin = ic.inf, ymax = ic.sup), alpha = 0.25) +
    scale_x_date(#breaks=seq(min(time(ncasos.completa)), max(time(ncasos.completa)), by=3),
                date_labels = "%d/%b", name="") +
    ylab("Tempo de duplicação (dias)") +
    plot.formatos

#> Default config will estimate R on weekly sliding windows.
p <- plot(res_uncertain_si, legend = TRUE) + plot.formatos

