library(ggplot2)
library(dplyr)
library(tidyr)
library(zoo)
library(EpiEstim)


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
## (gambiarra para ter linha contínua no grafico, verificar help de ggplot.zoo)
ncasos.completa <-merge(casos=brasil$casos.acumulados, exp.5d[, c("predito","ic.low","ic.upp")])
ncasos.completa$casos[time(ncasos.completa)>=min(time(exp.5d))] <- exp.5d$predito[time(exp.5d)>=min(time(exp.5d))]

plot.forecast.exp <-
    ggplot(data=ncasos.completa, aes(x=Index, y=casos,ymin=ic.low, ymax=ic.upp)) +
    geom_ribbon(fill="lightgrey") +
    geom_line() +
    geom_point(data=ncasos.completa[time(ncasos.completa)<=min(time(exp.5d))], size=2,
               aes(text = paste("Data:", Index, "\n",
                                "Casos:", round(casos)))) +
    geom_point(data=ncasos.completa[time(ncasos.completa)>=min(time(exp.5d))],
               aes(text = paste("Data:", Index, "\n",
                        "Casos:", round(casos), "\n",
                        "IC min:", round(ic.low), "\n",
                        "IC max:", round(ic.upp))),
                size=2, col="#e66101") +
    scale_x_date(date_labels = "%d/%b", name="") +
    scale_y_log10() +
    ##ylim(0,max(ncasos.completa$ic.upp, na.rm=TRUE)) +
    ylab("Número de casos") +
    ggtitle("Número de casos notificados em escala logarítimica") +
    plot.formatos

################################################################################
##Tempo de duplicacao calculado para uma janela de 5 dias, a partir do dia zero
################################################################################
plot.tempo.dupl <-
    ggplot(tempos.duplicacao, aes(Index, estimativa)) +
    geom_ribbon(aes(ymin = ic.inf, ymax = ic.sup), fill="lightgrey") +
    geom_line(size = 1.25, color="darkblue") +
    scale_x_date(#breaks=seq(min(time(ncasos.completa)), max(time(ncasos.completa)), by=3),
                date_labels = "%d/%b", name="") +
    ylab("Tempo de duplicação (dias)") +
    plot.formatos 

# Default config will estimate R on weekly sliding windows.
## plot.estimate.R <- plot(res.uncertain.si, "R", legend=TRUE) + plot.formatos
plot.estimate.R0 <-
    ggplot(data = res.uncertain.si.zoo, aes(Index, Mean.R)) +
    geom_ribbon(aes(ymin = Quantile.0.025.R, ymax = Quantile.0.975.R), fill="lightgrey") +
    geom_line(size = 1.25, color="darkblue") +
    scale_x_date( date_labels = "%d/%b", name="") +
    ylim(0.8, max(res.uncertain.si.zoo$Quantile.0.975.R))+
    geom_hline(yintercept=1, linetype="dashed", col="red") +          
    ylab("Número de reprodução") +
    plot.formatos


################################################################################
## Evolucao de casos suspeitos, descartados e confirmados
################################################################################

evolucao.tipos.casos <-
    brasil.ivis %>%
    filter(!is.na(Suspeitos)) %>%
    gather(Suspeitos:Óbitos, key = Classe, value = N.casos) %>%
    mutate(Classe = factor(Classe, levels =c("Óbitos", "Confirmados", "Suspeitos","Descartados"))) %>%
    ggplot(aes(dia,N.casos)) +
    geom_col(aes(fill=Classe)) +
    scale_x_date( date_labels = "%d/%b", name="") +
    ylab("Número de casos") +
    plot.formatos
