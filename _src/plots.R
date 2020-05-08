library(ggplot2)
library(dplyr)
library(tidyr)
library(zoo)
library(EpiEstim) 
library(readr)
library(knitr)
library(scales)

################################################################################
## Parametros de formatacao comum aos plots
################################################################################
plot.formatos <- theme_bw() +
                 theme(axis.text= element_text(size=10, face="plain"),
                       axis.title = element_text(size=10, face="plain"),
                       legend.text = element_text(size=12),
                       title = element_text(size = 12),
                       plot.margin = margin(0, 0, 0, 0, "pt"),
                       panel.border = element_blank(),
                       panel.grid = element_line(size = 0.25),
                       panel.grid.minor = element_blank(),
                       panel.grid.major.x = element_blank())
plot.breaks <- c(10, 100, 1000, 10000, 100000, 1000000, 1000000)

################################################################################
## Funcao para calculo do prefixo na label (modificacao de scales lib) 
################################################################################
force_all <- function(...) list(...)

label_number_si <- function(accuracy = 1, unit = NULL, sep = NULL, ...) {
  sep <- if (is.null(unit)) "" else " "
  force_all(accuracy, ...)

  function(x) {
    breaks <- c(0, 10^c(" mil" = 3, M = 6, B = 9, T = 12))

    n_suffix <- cut(abs(x),
      breaks = c(unname(breaks), Inf),
      labels = c(names(breaks)),
      right = FALSE
    )
    n_suffix[is.na(n_suffix)] <- ""
    suffix <- paste0(sep, n_suffix, unit)

    scale <- 1 / breaks[n_suffix]
    # for handling Inf and 0-1 correctly
    scale[which(scale %in% c(Inf, NA))] <- 1

    number(x,
      accuracy = accuracy,
      scale = unname(scale),
      suffix = suffix,
      ...
    )
  }
}

################################################################################
## Color blind safe palettes
################################################################################
## IBM Palette
# Main
ibm_ultramarine       <- "#648fff" # cold
ibm_indigo            <- "#785ef0" # cold
ibm_magenta           <- "#dc267f" # hot
ibm_orange            <- "#fe6100" # hot
ibm_gold              <- "#ffb000" # hot
# Lighter
ibm_ultramarine_light <- "#B0C6FF" # cold
ibm_indigo_light      <- "#B5A7F2" # cold
ibm_magenta_light     <- "#E16AA4" # hot
ibm_orange_light      <- "#FF914D" # hot
ibm_gold_light        <- "#FFC64D" # hot
# Dark
ibm_ultramarine_dark  <- "#1D62CB" # cold
ibm_indigo_dark       <- "#4A39A3" # cold
ibm_magenta_dark      <- "#8F3053" # hot
ibm_orange_dark       <- "#B3411F" # hot
ibm_gold_dark         <- "#BC8538" # hot

## Wong Palette
# Main
wong_black            <- "#2b2b2b" # neutral
wong_orange           <- "#e69f00" # hot
wong_yellow           <- "#F0E442" # hot
wong_red              <- "#D55E00" # hot
wong_pink             <- "#CC79A7" # hot
wong_green            <- "#009E73" # cold
wong_darkblue         <- "#0072B2" # cold
wong_lightblue        <- "#56B4E9" # cold
# Lighter
wong_black_light      <- "#737373" # neutral
wong_orange_light     <- "#EAB646" # hot
wong_yellow_light     <- "#F2EB8A" # hot
wong_red_light        <- "#DD8542" # hot
wong_pink_light       <- "#D5BDCA" # hot
wong_green_light      <- "#34AE8E" # cold
wong_darkblue_light   <- "#398EBF" # cold
wong_lightblue_light  <- "#9ECFEC" # cold
# Darker
wong_black_dark       <- "#000000" # neutral

################################################################################
## Grafico da serie observada e do previsto pelo modelo exponencial
## para os proximos 5 dias (com intervalo de confiança)
################################################################################
## Serie com observados e previstos
## (gambiarra para ter linha contínua no grafico, verificar help de ggplot.zoo)
ncasos.completa <-merge(casos=brasil$casos.acumulados, exp.5d[, c("predito","ic.low","ic.upp")])
ncasos.completa$casos[time(ncasos.completa)>=min(time(exp.5d))] <- exp.5d$predito[time(exp.5d)>=min(time(exp.5d))]

plot.forecast.exp.br <-
    ggplot(data=ncasos.completa, aes(x=Index, y=casos, ymin=ic.low, ymax=ic.upp)) +
    # confianca
    geom_ribbon(fill=ibm_ultramarine_dark, alpha = 0.4) +
    # previsao
    geom_line(data=ncasos.completa[time(ncasos.completa)>=min(time(exp.5d))-1],
              col=ibm_ultramarine) +
    geom_point(data=ncasos.completa[time(ncasos.completa)>=min(time(exp.5d))],
               size=1,
               col=ibm_ultramarine_dark,
               aes(text = paste("Data:", Index, "\n",
                                "Casos previstos:", round(casos), "\n",
                                "IC min:", round(ic.low), "\n",
                                "IC max:", round(ic.upp)))) +
    # notificados
    geom_line(data=ncasos.completa[time(ncasos.completa)<min(time(exp.5d))],
              col=wong_black_light) +
    geom_point(data=ncasos.completa[time(ncasos.completa)<min(time(exp.5d))],
               size=.75,
               col=wong_black,
               aes(text = paste("Data:", Index, "\n",
                                "Casos:", round(casos)))) +
    # escala
    scale_x_date(date_labels = "%d/%b", name="", limits=c(as.Date('2020-02-25'), NA)) +
    scale_y_log10(labels = label_number_si(),
                  breaks = plot.breaks) +
    ylab(NULL) +
    plot.formatos
    ##ylim(0,max(ncasos.completa$ic.upp, na.rm=TRUE)) +
    ##ggtitle("Número de casos notificados em escala logarítimica") +

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
## Série temporal dos tempos de duplicação
################################################################################
ex.dt <- dt.rw(brasil.d0[1:10], window.width =5)
ex.dt$coef  <-  round(ex.dt$coef,1)
ex.dt$coef.low  <- round(ex.dt$coef.low,1)
ex.dt$coef.upp  <- round(ex.dt$coef.upp,1)
ex.dt.df <- as.data.frame(ex.dt[,c(1,3,2)])
rownames(ex.dt.df) <- format(as.Date(rownames(ex.dt.df)), "%d/%m/%Y")
serie.temp.table <- kable(ex.dt.df, "html", col.names=c("Estimado", "IC-inferior", "IC-superior"),
                          caption="Estimativas dos tempos de duplicação do número de casos de COVID-19 para o Brasil, para período de 5 dias, a partir de 07 de março de 2020. Indicados os valores estimados e os limites inferiores e superiores do intervalo de confiança a 95%. As datas em cada linha da tabela são os dias do final de cada período.",
                          pagetitle = "09")

################################################################################
## Estimativa tempo de duplicação
################################################################################

exemplo1 <- window(brasil, start="2020-03-07",end="2020-03-11")
ex.fit <- fitP.exp(exemplo1$casos.acumulados, only.coef=FALSE)
exemplo1$pred <- predict(ex.fit, type="response")
est.tempo.dupl <- ggplot(exemplo1,
                         aes(Index, casos.acumulados)) +
  geom_point(size=2, color="darkblue") +
  geom_line(aes(Index, pred)) +
  scale_x_date(date_labels = "%d/%b", name="") +
  ylab("log (Número de casos)") +
  scale_y_log10() +
  plot.formatos

################################################################################
## Projeções de número de casos 
################################################################################
ex.forecast <- forecast.exponential(exemplo1$casos.acumulados,
                                    start=as.Date("2020-03-07"),
                                    days.forecast = 5)
exemplo2 <- window(brasil, start="2020-03-07", end="2020-03-16")
exemplo2 <- merge(exemplo2,
                  zoo(data.frame(pred=predict(ex.fit, newdata=data.frame(ndias=0:10), type="response")),
                      time(exemplo2)))              
proj.num.casos <- ggplot(data= exemplo2, aes(Index, casos.acumulados)) +
  geom_point(size=2, color="darkblue") +
  geom_line(aes(Index, pred)) +
  geom_ribbon(data=ex.forecast, aes(y=predito, ymin=ic.low, ymax=ic.upp), alpha=0.2) +
  scale_x_date(date_labels = "%d/%b", name="") +
  ylab("log (Número de casos)") +
  scale_y_log10() +
  plot.formatos

######################################################################
## Tabela para preencher o minimo e o máximo
######################################################################
# Create a dataframe with all the locations as row names. Add VR
minmax.casos <- data.frame(row.names = c("BR"))
# Get all the places in a dataframe
minmax.lugares <- exp.5d

min <- as.integer(minmax.lugares[max(nrow(minmax.lugares)),2])
max <- as.integer(minmax.lugares[max(nrow(minmax.lugares)),3])
data <- format(max(time(minmax.lugares)), "%d/%m/%Y")

# Fill the table
minmax.casos <- cbind(minmax.casos, min, max, data)
# Order table by alphabetic order
minmax.casos <- minmax.casos[order(row.names(minmax.casos)),]
# Save to a csv
write.table(minmax.casos, file="../web/data_forecast_exp_br.csv", row.names = TRUE, col.names = FALSE)

