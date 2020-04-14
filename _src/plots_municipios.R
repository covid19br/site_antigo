library(ggplot2)
library(dplyr)
library(tidyr)
library(zoo)

################################################################################
## Parametros de formatacao comum aos plots
################################################################################
plot.formatos <- theme_bw()+
    theme(axis.text= element_text(size=12, face="bold"),
          axis.title = element_text(size=14, face="bold"),
          legend.text = element_text(size=12))


################################################################################
## N de novos casos observados e por nowcasting
################################################################################
plot.nowcast <-
    now.pred.zoo %>%
    ggplot(aes(Index, n.casos)) +
    geom_ribbon(aes(ymin = lower, ymax = upper), fill = "lightgrey", alpha = 0.5) +
    geom_line(aes(col = "Notificados"), size = 1) +
    geom_line(aes(y = estimate, col = "Estimado"), size = 1) +
    scale_x_date(date_labels = "%d/%b") +
    scale_color_manual(name="", values = RColorBrewer::brewer.pal(3, "Set1")[1:2]) +
    xlab("Dia do primeiro sintoma") +
    ylab("Número de novos casos") +
    plot.formatos +
    theme(legend.position = c(0.2,0.8))

################################################################################
## N acumulados de casos (nowcasting) e de casos notificados
## com as projecoes para os próximos 5 dias
################################################################################
plot.nowcast.cum <-
    now.proj.zoo %>%
    ggplot(aes(Index)) +
    geom_line(data=window(now.proj.zoo, end = max(time(now.pred.zoo))),
              aes(y = now.mean.c, color = "Estimados"), size=1) +
    geom_ribbon(data = window(now.proj.zoo, start = max(time(now.pred.zoo))),
                aes(ymin = now.low.c, ymax = now.upp.c), fill = "lightgrey", alpha = 0.5) +
    geom_line(data = window(now.proj.zoo, start = max(time(now.pred.zoo))),
              aes(y=now.mean.c, color="Estimados"), lty = "longdash") +
    geom_line(data=window(now.proj.zoo, end = max(time(now.pred.zoo))),
              aes(y = not.mean.c, color="Notificados"), size = 1) +
    geom_ribbon(data = window(now.proj.zoo, start = max(time(now.pred.zoo))),
                aes(ymin = not.low.c, ymax = not.upp.c), fill="lightgrey", alpha = 0.5) +
    geom_line(data = window(now.proj.zoo, start = max(time(now.pred.zoo))),
              aes(y = not.mean.c, color = "Notificados"), lty = "longdash") +
    scale_x_date(date_labels = "%d/%b") +
    plot.formatos +
    scale_color_discrete(name="") +
    scale_color_manual(name="", values = RColorBrewer::brewer.pal(3, "Set1")[1:2]) +
    xlab("Dia do primeiro sintoma") +
    ylab("Número acumulado de casos") +
    theme(legend.position = c(0.2,0.8)) +
    scale_y_log10() 


################################################################################
## Plot do tempo de duplicação em função do tempo
################################################################################
plot.tempo.dupl <-
    ggplot(td.now, aes(Index, estimativa)) +
    geom_ribbon(aes(ymin = ic.inf, ymax = ic.sup), fill = "lightgrey", alpha = 0.5) +
    geom_line(size = 1.25, colour = RColorBrewer::brewer.pal(3, "Dark2")[1]) +
    scale_x_date(date_labels = "%d/%b", name="") +
    ##coord_cartesian(ylim = c(0, 50)) +
    ylab("Tempo de duplicação (dias)") +
    plot.formatos 

################################################################################
## Plot do R efetivo em função do tempo
################################################################################
plot.estimate.R0 <-
    ggplot(data = Re.now.zoo, aes(Index, Mean.R)) +
    geom_ribbon(aes(ymin = Quantile.0.025.R, ymax = Quantile.0.975.R), fill = "lightgrey", alpha = 0.5) +
    geom_line(size = 1.25, colour = RColorBrewer::brewer.pal(4, "Dark2")[3]) +
    scale_x_date( date_labels = "%d/%b", name="") +
    ylim(min(c(0.8, min(Re.now.zoo$Quantile.0.025.R))), max(Re.now.zoo$Quantile.0.975.R))+
    geom_hline(yintercept=1, linetype = "dashed", col = "red", size = 1) +          
    ylab("Número de reprodução da epidemia") +
    plot.formatos


