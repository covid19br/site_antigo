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

## Grafico da serie observada e do previsto pelo modelo exponencial
## para os proximos 5 dias (com intervalo de confiança)

estados.plot.forecast.exp.br <- list()
for (st in names(estados.d0)){
  ## Serie com observados e previstos
  ## (gambiarra para ter linha contínua no grafico, verificar help de ggplot.zoo)
  ncasos.completa <-merge(casos=estados[[st]]$casos.acumulados,
                          estados.exp.5d[[st]][, c("predito","ic.low","ic.upp")])
  ncasos.completa$casos[time(ncasos.completa)>=min(time(estados.exp.5d[[st]]))] <- estados.exp.5d[[st]]$predito[time(estados.exp.5d[[st]])>=min(time(estados.exp.5d[[st]]))]
  
  estados.plot.forecast.exp.br[[st]] <-
    ggplot(data=ncasos.completa, aes(x=Index, y=casos,ymin=ic.low, ymax=ic.upp)) +
    # confianca
    geom_ribbon(fill=ibm_ultramarine, alpha = 0.4) +
    # previsao
    geom_line(data=ncasos.completa[time(ncasos.completa)>=min(time(estados.exp.5d[[st]]))-1],
              col=ibm_ultramarine) +
    geom_point(data=ncasos.completa[time(ncasos.completa)>=min(time(estados.exp.5d[[st]]))],
               size=1,
               col=ibm_ultramarine_dark,
               aes(text = paste("Data:", Index, "\n",
                                "Casos previstos:", round(casos), "\n",
                                "IC min:", round(ic.low), "\n",
                                "IC max:", round(ic.upp)))) +
    # notificados
    geom_line(data=ncasos.completa[time(ncasos.completa)<min(time(estados.exp.5d[[st]]))],
              col=wong_black_light) +
    geom_point(data=ncasos.completa[time(ncasos.completa)<min(time(estados.exp.5d[[st]]))],
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
    ##ggtitle(paste("Número de casos notificados em", st, "em escala logarítimica")) +
}

######################################################################
## Tabela para preencher o minimo e o máximo
######################################################################
# Create a dataframe with all the locations as row names. Add VR
estados.minmax.casos <- data.frame(row.names = c(names(estados.exp.5d)))
# Get all the places in a dataframe
minmax.lugares <- estados.exp.5d
# Create vectors for keeping minimun, maximun and date.
min <- vector()
max <- vector()
data <- vector()
# Fill the vectors
for (i in 1:length(minmax.lugares)) {
  min[i] <- as.integer(minmax.lugares[[i]][max(nrow(minmax.lugares[[i]])),2])
  max[i] <- as.integer(minmax.lugares[[i]][max(nrow(minmax.lugares[[i]])),3])
  data[i] <- format(max(time(minmax.lugares[[i]])), "%d/%m/%Y")
}
# Fill the table
estados.minmax.casos <- cbind(estados.minmax.casos, min, max, data)
# Order table by alphabetic order
estados.minmax.casos <- estados.minmax.casos[order(row.names(estados.minmax.casos)),]
# Save to a csv
write.table(estados.minmax.casos, file="../web/data_forecast_exp_estados.csv", row.names = TRUE, col.names = FALSE)

