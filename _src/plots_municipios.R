# libraries
library(ggplot2)
library(dplyr)
library(tidyr)
library(zoo)

################################################################################
## Parametros de formatacao comum aos plots
################################################################################
plot.formatos <- theme_bw() +
    theme(axis.text = element_text(size = 10, face = "bold"),
          axis.title = element_text(size = 10, face = "bold"),
          legend.text = element_text(size = 12),
          title = element_text(size = 12),
          plot.margin = margin(2, 0, 0, 0, "pt"))


################################################################################
## N de novos casos observados e por nowcasting
## Com linha de média móvel
################################################################################
## COVID
plot.nowcast <-
    now.pred.zoo %>%
    ggplot(aes(Index)) +
    geom_line(aes(y = estimate.merged), lty = 2, col = "grey") +
    geom_point(data = window(now.pred.zoo, end = min(time(lista.covid$now.pred.zoo.original))),
               aes(y = n.casos, col = "Notificado"), size = 2) +
    geom_point(data = window(now.pred.zoo, start = min(time(lista.covid$now.pred.zoo.original)) + 1),
               aes(y = estimate, col = "Nowcasting"), size = 2) +
    geom_ribbon(data = window(now.pred.zoo, start = min(time(lista.covid$now.pred.zoo.original)) + 1),
                aes(x = Index, ymin = lower.merged, ymax = upper.merged),
                fill = RColorBrewer::brewer.pal(3, "Set1")[2], alpha = 0.1)+ 
    geom_line(aes(y = estimate.merged.smooth), alpha = 0.6, size = 2) +
    ##geom_ribbon(data= window(now.pred.zoo, start=min(time(now.pred.zoo.original))+1),
    ##            aes(x = Index, ymin = lower.merged.smooth, ymax= upper.merged.smooth),
    ##            fill = "darkblue", alpha =0.2) +
    scale_x_date(date_labels = "%d/%b") +
    scale_color_manual(name = "", values = RColorBrewer::brewer.pal(3, "Set1")[1:2]) +
    xlab("Dia do primeiro sintoma") +
    ylab("Número de novos casos") +
    plot.formatos +
    theme(legend.position = c(0.2,0.8))

## SRAG
plot.nowcast.srag <-
    now.srag.pred.zoo %>%
    ggplot(aes(Index)) +
    geom_line(aes(y = estimate.merged), lty = 2, col = "grey") +
    geom_point(data = window(now.srag.pred.zoo, end = min(time(lista.srag$now.pred.zoo.original))),
               aes(y = n.casos, col = "Notificado"), size = 2) +
    geom_point(data = window(now.srag.pred.zoo, start = min(time(lista.srag$now.pred.zoo.original)) + 1),
               aes(y = estimate, col = "Nowcasting"), size = 2) +
    geom_ribbon(data = window(now.srag.pred.zoo, start = min(time(lista.srag$now.pred.zoo.original)) + 1),
                aes(x = Index, ymin = lower.merged, ymax = upper.merged),
                fill = RColorBrewer::brewer.pal(3, "Set1")[2], alpha = 0.1) +
    geom_line(aes(y = estimate.merged.smooth), alpha = 0.6, size = 2) +
    ##geom_ribbon(data= window(now.srag.pred.zoo, start=min(time(now.srag.pred.zoo.original))+1),
    ##            aes(x = Index, ymin = lower.merged.smooth, ymax= upper.merged.smooth),
    ##            fill = "darkblue", alpha =0.2) +
    scale_x_date(date_labels = "%d/%b") +
    scale_color_manual(name = "", values = RColorBrewer::brewer.pal(3, "Set1")[1:2]) +
    xlab("Dia do primeiro sintoma") +
    ylab("Número de novos óbitos") +
    plot.formatos +
    theme(legend.position = c(0.2,0.8))

#### obitos ####
## OBITOS COVID
plot.nowcast.ob.covid <-
    now.ob.covid.pred.zoo %>%
    ggplot(aes(Index)) +
    geom_line(aes(y = estimate.merged), lty = 2, col = "grey") +
    geom_point(data = window(now.ob.covid.pred.zoo, end = min(time(lista.ob.covid$now.pred.zoo.original))),
               aes(y = n.casos, col = "Notificado"), size = 2) +
    geom_point(data = window(now.ob.covid.pred.zoo, start = min(time(lista.ob.covid$now.pred.zoo.original)) + 1),
               aes(y = estimate, col = "Nowcasting"), size = 2) +
    geom_ribbon(data = window(now.ob.covid.pred.zoo, start = min(time(lista.ob.covid$now.pred.zoo.original)) + 1),
                aes(x = Index, ymin = lower.merged, ymax = upper.merged),
                fill = RColorBrewer::brewer.pal(3, "Set1")[2], alpha = 0.1)+
    geom_line(aes(y = estimate.merged.smooth), alpha = 0.6, size = 2) +
    ##geom_ribbon(data= window(now.pred.zoo, start=min(time(now.pred.zoo.original))+1),
    ##            aes(x = Index, ymin = lower.merged.smooth, ymax= upper.merged.smooth),
    ##            fill = "darkblue", alpha =0.2) +
    scale_x_date(date_labels = "%d/%b") +
    scale_color_manual(name = "", values = RColorBrewer::brewer.pal(3, "Set1")[1:2]) +
    xlab("Dia do óbito") +
    ylab("Número de novos óbitos") +
    plot.formatos +
    theme(legend.position = c(0.2, 0.8))

## OBITOS SRAG
plot.nowcast.ob.srag <-
    now.ob.srag.pred.zoo %>%
    ggplot(aes(Index)) +
    geom_line(aes(y = estimate.merged), lty = 2, col = "grey") +
    geom_point(data = window(now.ob.srag.pred.zoo, end = min(time(lista.ob.srag$now.pred.zoo.original))),
               aes(y = n.casos, col = "Notificado"), size = 2) +
    geom_point(data = window(now.ob.srag.pred.zoo, start = min(time(lista.ob.srag$now.pred.zoo.original)) + 1),
               aes(y = estimate, col = "Nowcasting"), size = 2) +
    geom_ribbon(data = window(now.ob.srag.pred.zoo, start = min(time(lista.ob.srag$now.pred.zoo.original)) + 1),
                aes(x = Index, ymin = lower.merged, ymax = upper.merged),
                fill = RColorBrewer::brewer.pal(3, "Set1")[2], alpha = 0.1) +
    geom_line(aes(y = estimate.merged.smooth), alpha = 0.6, size = 2) +
    ##geom_ribbon(data= window(now.pred.zoo, start=min(time(now.pred.zoo.original))+1),
    ##            aes(x = Index, ymin = lower.merged.smooth, ymax= upper.merged.smooth),
    ##            fill = "darkblue", alpha =0.2) +
    scale_x_date(date_labels = "%d/%b") +
    scale_color_manual(name = "", values = RColorBrewer::brewer.pal(3, "Set1")[1:2]) +
    xlab("Dia do óbito") +
    ylab("Número de novos óbitos") +
    plot.formatos +
    theme(legend.position = c(0.2, 0.8))


################################################################################
## N acumulados de casos (nowcasting) e de casos notificados
## com as projecoes para os próximos 5 dias
################################################################################
## COVID ##
plot.nowcast.cum <-
    now.proj.zoo %>%
    ggplot(aes(Index)) +
    geom_line(data = window(now.proj.zoo, end = max(time(now.pred.zoo))),
              aes(y = now.mean.c, color = "Estimados"), size = 1) +
    geom_ribbon(data = window(now.proj.zoo, start = max(time(now.pred.zoo))),
                aes(ymin = now.low.c, ymax = now.upp.c), fill = "lightgrey") +
    geom_line(data = window(now.proj.zoo, start = max(time(now.pred.zoo))),
              aes(y = now.mean.c, color = "Estimados"), lty = "longdash") +
    geom_line(data = window(now.proj.zoo, end = max(time(now.pred.zoo))),
              aes(y = not.mean.c, color = "Notificados"), size = 1) +
    geom_ribbon(data = window(now.proj.zoo, start = max(time(now.pred.zoo))),
                aes(ymin = not.low.c, ymax = not.upp.c), fill = "lightgrey") +
    geom_line(data = window(now.proj.zoo, start = max(time(now.pred.zoo))),
              aes(y = not.mean.c, color = "Notificados"), lty = "longdash") +
    scale_x_date(date_labels = "%d/%b") +
    plot.formatos +
    scale_color_discrete(name = "") +
    scale_color_manual(name = "", values = RColorBrewer::brewer.pal(3, "Set1")[1:2]) +
    xlab("Dia do primeiro sintoma") +
    ylab("Número acumulado de casos") +
    theme(legend.position = c(0.2,0.8)) +
    scale_y_log10()


## SRAG ##
plot.nowcast.cum.srag <-
    now.srag.proj.zoo %>%
    ggplot(aes(Index)) +
    geom_line(data = window(now.srag.proj.zoo, end = max(time(now.srag.pred.zoo))),
              aes(y = now.mean.c, color = "Estimados"), size = 1) +
    geom_ribbon(data = window(now.srag.proj.zoo, start = max(time(now.srag.pred.zoo))),
                aes(ymin = now.low.c, ymax = now.upp.c), fill = "lightgrey") +
    geom_line(data = window(now.srag.proj.zoo, start = max(time(now.srag.pred.zoo))),
              aes(y = now.mean.c, color = "Estimados"), lty = "longdash") +
    geom_line(data = window(now.srag.proj.zoo, end = max(time(now.srag.pred.zoo))),
              aes(y = not.mean.c, color = "Notificados"), size = 1) +
    geom_ribbon(data = window(now.srag.proj.zoo, start = max(time(now.srag.pred.zoo))),
                aes(ymin = not.low.c, ymax = not.upp.c), fill = "lightgrey") +
    geom_line(data = window(now.srag.proj.zoo, start = max(time(now.srag.pred.zoo))),
              aes(y = not.mean.c, color = "Notificados"), lty = "longdash") +
    scale_x_date(date_labels = "%d/%b") +
    plot.formatos +
    scale_color_discrete(name = "") +
    scale_color_manual(name = "", values = RColorBrewer::brewer.pal(3, "Set1")[1:2]) +
    xlab("Dia do primeiro sintoma") +
    ylab("Número acumulado de casos") +
    theme(legend.position = c(0.2,0.8)) +
    scale_y_log10() 

################################################################################
## Plot do tempo de duplicação em função do tempo #srm: criei um fracasito aqui
################################################################################
plot.tempo.dupl.municipio <-
    td.now %>%
    ggplot(aes(Index, estimativa)) +
    geom_ribbon(aes(ymin = ic.inf, ymax = ic.sup), fill = "lightgrey") +
    geom_line(size = 1.25, colour = RColorBrewer::brewer.pal(3, "Dark2")[1]) +
    scale_x_date(date_labels = "%d/%b", name = "") +
    ##coord_cartesian(ylim = c(0, 50)) +
    ylab("Tempo de duplicação (dias)") +
    plot.formatos 

plot.tempo.dupl.municipio.srag  <- plot.tempo.dupl.municipio %+% 
    fortify(window(td.now.srag, start = min(time(td.now)))) 

##### OBITOS ####
## COVID
plot.tempo.dupl.municipio.ob.covid  <- plot.tempo.dupl.municipio %+% 
    fortify(window(td.now.ob.covid, start = min(time(td.now)))) 

## SRAG
plot.tempo.dupl.municipio.ob.srag  <- plot.tempo.dupl.municipio %+% 
    fortify(window(td.now.ob.srag, start = min(time(td.now)))) 

################################################################################
## Plot do R efetivo em função do tempo
################################################################################
## COVID
plot.estimate.R0.municipio <-
    ggplot(data = Re.now.zoo, aes(Index, Mean.R)) +
    geom_ribbon(aes(ymin = Quantile.0.025.R, ymax = Quantile.0.975.R), fill = "lightgrey") +
    geom_line(size = 1.25, colour = RColorBrewer::brewer.pal(4, "Dark2")[3]) +
    scale_x_date( date_labels = "%d/%b", name="") +
    ylim(min(c(0.8, min(Re.now.zoo$Quantile.0.025.R))), max(Re.now.zoo$Quantile.0.975.R))+
    geom_hline(yintercept=1, linetype = "dashed", col = "red", size = 1) +          
    ylab("Número de reprodução da epidemia") +
    plot.formatos

## SRAG #
plot.estimate.R0.municipio.srag <- plot.estimate.R0.municipio %+% fortify(window(Re.now.srag.zoo, start=min(time(Re.now.zoo))))

######################################################################
## Tabelas para preencher o html
######################################################################
## COVID ##

## Tabela que preenche o minimo e o maximo do nowcast
municipios.minmax.casos <- data.frame(row.names = c("SP"))
min <- as.integer(now.proj.zoo[max(nrow(now.proj.zoo)),2])
max <- as.integer(now.proj.zoo[max(nrow(now.proj.zoo)),3])
data <- format(max(time(now.proj.zoo)), "%d/%m/%Y")
municipios.minmax.casos <- cbind(municipios.minmax.casos, min, max, data)
write.table(municipios.minmax.casos, file="../web/data_forecasr_exp_municipios.csv", row.names = TRUE, col.names = FALSE)
# Não é generico, é apenas para o municipio de sp. Tendo mais, tem que atualizar

## Tabela do tempo de duplicação
municipios.temp.dupl <- data.frame(row.names = c("SP"))
min.dias <- as.vector(round(td.now[max(nrow(td.now)),2], 1))
max.dias <- as.vector(round(td.now[max(nrow(td.now)),3], 1))
municipios.temp.dupl <- cbind(municipios.temp.dupl, min.dias, max.dias)
write.table(municipios.temp.dupl, file="../web/data_tempo_dupli_municipio.csv", row.names = TRUE, col.names = FALSE)


## Tabela do Re
municipios.Re <- data.frame(row.names = c("SP"))
min <- as.factor(round(Re.now.zoo[nrow(Re.now.zoo), 5],1))
max <- as.factor(round(Re.now.zoo[nrow(Re.now.zoo), 11],1))
municipios.Re <- cbind(municipios.Re, min, max)
write.table(municipios.Re, file="../web/data_Re_municipio.csv", row.names = TRUE, col.names = FALSE)


## SRAG ##

## Tabela que preenche o minimo e o maximo do nowcast
municipios.minmax.casos.srag <- data.frame(row.names = c("SP"))
min <- as.integer(now.srag.proj.zoo[max(nrow(now.srag.proj.zoo)),2])
max <- as.integer(now.srag.proj.zoo[max(nrow(now.srag.proj.zoo)),3])
data <- format(max(time(now.srag.proj.zoo)), "%d/%m/%Y")
municipios.minmax.casos.srag <- cbind(municipios.minmax.casos.srag, min, max, data)
write.table(municipios.minmax.casos.srag, file="../web/data_forecasr_exp_municipios_srag.csv", row.names = TRUE, col.names = FALSE)
# Não é generico, é apenas para o municipio de sp. Tendo mais, tem que atualizar

## Tabela do tempo de duplicação
municipios.temp.dupl.srag <- data.frame(row.names = c("SP"))
min.dias <- as.vector(round(td.now.srag[max(nrow(td.now.srag)),2], 1))
max.dias <- as.vector(round(td.now.srag[max(nrow(td.now.srag)),3], 1))
municipios.temp.dupl.srag <- cbind(municipios.temp.dupl.srag, min.dias, max.dias)
write.table(municipios.temp.dupl.srag, file="../web/data_tempo_dupli_municipio_srag.csv", row.names = TRUE, col.names = FALSE)


## Tabela do Re
municipios.Re.srag <- data.frame(row.names = c("SP"))
min <- as.factor(round(Re.now.srag.zoo[nrow(Re.now.srag.zoo), 5],1))
max <- as.factor(round(Re.now.srag.zoo[nrow(Re.now.srag.zoo), 11],1))
municipios.Re.srag <- cbind(municipios.Re.srag, min, max)
write.table(municipios.Re.srag, file="../web/data_Re_municipio_srag.csv", row.names = TRUE, col.names = FALSE)


