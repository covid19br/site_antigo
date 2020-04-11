library(ggplot2)
library(dplyr)
library(tidyr)
library(zoo)

################################################################################
## Parametros de formatacao comum aos plots
################################################################################
plot.formatos <- theme_bw()+
    theme(axis.text= element_text(size=12, face="bold"),
          axis.title.y = element_text(size=14, face="bold"))


################################################################################
## N de novos casos observados e por nowcasting
################################################################################
plot.nowcast <-
    now.pred.zoo %>%
    ggplot(aes(Index, n.casos)) +
    geom_line(aes(col = "Notificados"), size = 1) +
    geom_line(aes(y = estimate, col = "Estimado"), size = 1) +
    geom_ribbon(aes(ymin = lower, ymax = upper), fill= "red", alpha = 0.2) +
    scale_x_date(date_labels = "%d/%b", name="") +
    scale_color_discrete(name="") +
    xlab("Dia do primeiro sintoma") +
    ylab("Número de novos casos") +
    plot.formatos +
    theme(legend.position = c(0.2,0.8))

################################################################################
## Plot do tempo de duplicação em função do tempo
################################################################################
plot.tempo.dupl <-
    ggplot(td.now, aes(Index, estimativa)) +
    geom_ribbon(aes(ymin = ic.inf, ymax = ic.sup), fill="lightgrey") +
    geom_line(size = 1.25, color="darkblue") +
    scale_x_date(date_labels = "%d/%b", name="") +
    ylab("Tempo de duplicação (dias)") +
    plot.formatos 

################################################################################
## Plot do R efetivo em função do tempo
################################################################################
plot.estimate.R0 <-
    ggplot(data = Re.now.zoo, aes(Index, Mean.R)) +
    geom_ribbon(aes(ymin = Quantile.0.025.R, ymax = Quantile.0.975.R), fill="lightgrey") +
    geom_line(size = 1.25, color="darkblue") +
    scale_x_date( date_labels = "%d/%b", name="") +
    ylim(min(c(0.8, min(Re.now.zoo$Quantile.0.025.R))), max(Re.now.zoo$Quantile.0.975.R))+
    geom_hline(yintercept=1, linetype="dashed", col="red") +          
    ylab("Número de reprodução da epidemia") +
    plot.formatos


