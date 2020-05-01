library(ggplot2)
library(dplyr)
library(tidyr)
library(zoo)
library(EpiEstim) 
library(readr)
library(knitr)
library(cowplot)

################################################################################
## Parametros de formatacao comum aos plots
################################################################################
plot.formatos <- theme_bw()+
  theme(axis.text= element_text(size=10, face="bold"),
        axis.title = element_text(size=10, face="bold"),
        legend.text = element_text(size=12),
        plot.title = element_text(size = 12),
        plot.margin = margin(5, 0, 0, 0, "pt"))

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
    geom_ribbon(fill="lightgrey") +
    geom_line() +
    geom_point(data=ncasos.completa[time(ncasos.completa)<=min(time(estados.exp.5d[[st]]))],
               size=2, aes(text = paste("Data:", Index, "\n", "Casos:",
                                        round(casos)))) +
    geom_point(data=ncasos.completa[time(ncasos.completa)>=min(time(estados.exp.5d[[st]]))],
               aes(text = paste("Data:", Index, "\n",
                                "Casos previstos:", round(casos), "\n",
                                "IC min:", round(ic.low), "\n",
                                "IC max:", round(ic.upp))),
               size=2, col="#007bff") +
    scale_x_date(date_labels = "%d/%b", name="", limits=c(as.Date('2020-02-25'), NA)) +
    scale_y_log10() +
    ##ylim(0,max(ncasos.completa$ic.upp, na.rm=TRUE)) +
    ylab("Número de casos") +
    ggtitle(paste("Número de casos notificados em", st, "em escala logarítimica")) +
    plot.formatos
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
# Order table by max cases
estados.minmax.casos <- estados.minmax.casos[order(-max),] 
# Save to a csv
write.table(estados.minmax.casos, file="../web/data_forecast_exp_estados.csv", row.names = TRUE, col.names = FALSE)

