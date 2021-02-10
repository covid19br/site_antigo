# Libraries
library(widgetframe)
library(tidyverse)
library(lubridate)
library(optparse)
library(ggplot2)
library(plotly)
library(dplyr)
library(tidyr)
library(withr)
Sys.setlocale(category = "LC_TIME", locale = "pt_BR.UTF-8")

# carrega funcoes----
source("funcoes.R")
source("fct/plot.nowcast.diario.brasil.R")

################################################################################
## Parsing command line arguments
################################################################################
if (sys.nframe() == 0L) {
    # Parsing command line arguments
    option_list <- list(
                        make_option("--dataBase",
                                    help = ("Data da base de dados, formato 'yyyy_mm_dd'"),
                                    metavar = "dataBase"),
                        make_option("--updateGit", default = "FALSE",
                                    help = ("Fazer git add, commit e push?"),
                                    metavar = "updateGit")
    )
    parser_object <- OptionParser(usage = "Rscript %prog [Opções]\n",
                                  option_list = option_list,
                                  description = "Script para atualizar plots do site do OBSERVATORIO COVID-19 BR com resultados do Brasil por estado")

    ## TO TEST INTERACTIVELY the command-line arguments
    #input <- "--dataBase 2021_02_01 --updateGit FALSE"
    #command.args <- strsplit(input, " ")[[1]]
    #opt <- parse_args(parser_object, args = command.args, positional_arguments = TRUE)
    ## SKIP opt line below
    opt <- parse_args(parser_object, args = commandArgs(trailingOnly = TRUE), positional_arguments=TRUE)
    ## aliases
    data <- opt$options$dataBase
    update.git <- opt$options$updateGit

    options(error = function() quit(save="no", status=1))
}

if (update.git)
    system("git pull")

plot.dir <- paste0("../web/brasil/")

estados <- c("AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", "MA", "MG",
             "MS", "MT", "PA", "PB", "PE", "PI", "PR", "RJ", "RN", "RO", "RR",
             "RS", "SC", "SE", "SP", "TO")


df.estados <- data.frame(estado=estados, data.dir=NA, data=NA, existe.covid=NA,
                         existe.srag=NA, existe.ob.covid=NA, existe.ob.srag=NA,
                         row.names=estados)
for (estado in estados) {
    # dir para os ler os dados
    data.dir <- paste0("../dados/estado/", estado,
                       "/tabelas_nowcasting_para_grafico/")
    
    # pegando a data mais recente
    if (is.null(data)) {
        data <- get.last.date(data.dir)
    }

    # testando se existe nowcasting
    existe.covid <- existe.nowcasting2(tipo = "covid",
                                       output.dir = data.dir,
                                       data = data)
    existe.srag <- existe.nowcasting2(tipo = "srag",
                                      output.dir = data.dir,
                                      data = data)
    existe.ob.covid <- existe.nowcasting2(tipo = "obitos_covid",
                                          output.dir = data.dir,
                                          data = data)
    existe.ob.srag <- existe.nowcasting2(tipo = "obitos_srag",
                                         output.dir = data.dir,
                                         data = data)
    df.estados[estado,] <- c(estado, data.dir, data, existe.covid, existe.srag,
                             existe.ob.covid, existe.ob.srag)
}

# Covid
if (all(as.logical(df.estados$existe.covid))) {
    df.covid.diario <- list()
    for (estado in estados) {
        data.dir <- df.estados[estado, "data.dir"]
        df.covid.diario[[estado]] <- read.csv(paste0(data.dir, "nowcasting_diario_covid_", data, ".csv"), stringsAsFactors = FALSE)
    }
    df.covid.diario <- plyr::ldply(df.covid.diario, .id="UF")
    plot.nowcast.covid <- plot.nowcast.diario.brasil(df.covid.diario)
} else {
    plot.nowcast.covid <- NULL
}

# SRAG
if (all(as.logical(df.estados$existe.srag))) {
    df.srag.diario <- list()
    for (estado in estados) {
        data.dir <- df.estados[estado, "data.dir"]
        df.srag.diario[[estado]] <- read.csv(paste0(data.dir, "nowcasting_diario_srag_", data, ".csv"), stringsAsFactors = FALSE)
    }
    df.srag.diario <- plyr::ldply(df.srag.diario, .id="UF")
    plot.nowcast.srag <- plot.nowcast.diario.brasil(df.srag.diario)
} else {
  plot.nowcast.srag <- NULL
}

# óbitos Covid
if (all(as.logical(df.estados$existe.ob.covid))) {
    df.ob.covid.diario <- list()
    for (estado in estados) {
        data.dir <- df.estados[estado, "data.dir"]
        df.ob.covid.diario[[estado]] <- read.csv(paste0(data.dir, "nowcasting_diario_obitos_covid_", data, ".csv"), stringsAsFactors = FALSE)
    }
    df.ob.covid.diario <- plyr::ldply(df.ob.covid.diario, .id="UF")
    plot.nowcast.ob.covid <- plot.nowcast.diario.brasil(df.ob.covid.diario)
} else {
    plot.nowcast.ob.covid <- NULL
}

# óbitos SRAG
if (all(as.logical(df.estados$existe.ob.srag))) {
    df.ob.srag.diario <- list()
    for (estado in estados) {
        data.dir <- df.estados[estado, "data.dir"]
        df.ob.srag.diario[[estado]] <- read.csv(paste0(data.dir, "nowcasting_diario_obitos_srag_", data, ".csv"), stringsAsFactors = FALSE)
    }
    df.ob.srag.diario <- plyr::ldply(df.ob.srag.diario, .id="UF")
    plot.nowcast.ob.srag <- plot.nowcast.diario.brasil(df.ob.srag.diario)
} else {
    plot.nowcast.ob.srag <- NULL
}

print("Atualizando plots...")

plots.para.atualizar <-
    makeNamedList(
                  # covid
                  plot.nowcast.covid,
                  # srag
                  plot.nowcast.srag,
                  # obitos covid
                  plot.nowcast.ob.covid,
                  # obitos srag
                  plot.nowcast.ob.srag
    )

# pegando apenas os plots que existem mesmo
plots.true <- sapply(plots.para.atualizar, function(x) !is.null(x))
filenames <- gsub(".", "_", names(plots.para.atualizar), fixed = TRUE)
n <- 1:length(plots.para.atualizar)

for (i in n[plots.true]) {
    fig.name <- filenames[i]

    #### SVG ####
    # fazendo todos os graficos svg para o site
    graph.svg <- plots.para.atualizar[[i]] +
        # corrige a diferenca do tamanho do texto entre svg e html
        theme(axis.text = element_text(size = 6.65),
              # corrige a margem inserida pelo plotly
              plot.margin = margin(10, 0, 0, 7, "pt"))
    ggsave(paste0(plot.dir, fig.name, ".svg"), plot = graph.svg,
           device = svg, scale = 1, width = 215, height = 235, units = "mm")
    # tamanho calculado usando ppi = 141.21
    #ggsave(paste0(plot.dir, fig.name, ".svg"), plot = graph.svg,
    #       device = svg, scale = .8, width = 210, height = 142, units = "mm")
    # o tamanho do texto no placeholder deve ser um fator de 0.665 do tamanho original
    # large
    graph.lg.svg <- graph.svg +
        # corrige a diferenca do tamanho do texto entre svg e html
        theme(axis.text = element_text(size = 8.65))
    ggsave(paste0(plot.dir, fig.name, ".lg.svg"), plot = graph.lg.svg,
           device = svg, scale = 1, width = 215, height = 235, units = "mm")
    # medium
    graph.md.svg <- graph.svg +
        # corrige a diferenca do tamanho do texto entre svg e html
        theme(axis.text = element_text(size = 12.65))
    ggsave(paste0(plot.dir, fig.name, ".md.svg"), plot = graph.md.svg,
           device = svg, scale = 1, width = 215, height = 235, units = "mm")
    # small
    graph.sm.svg <- graph.svg +
        # corrige a diferenca do tamanho do texto entre svg e html
        theme(axis.text = element_text(size = 16.65))
    ggsave(paste0(plot.dir, fig.name, ".sm.svg"), plot = graph.sm.svg,
           device = svg, scale = 1, width = 215, height = 235, units = "mm")
    # extra small
    graph.ex.svg <- graph.svg +
        # corrige a diferenca do tamanho do texto entre svg e html
        theme(axis.text = element_text(size = 20.65))
    ggsave(paste0(plot.dir, fig.name, ".ex.svg"), plot = graph.ex.svg,
           device = svg, scale = 1, width = 215, height = 235, units = "mm")

    #### HTML ####
    graph.html <- ggplotly(plots.para.atualizar[[i]]) %>%
        layout(margin = list(l = 50, r = 20, b = 20, t = 20, pad = 4))
    with_dir(plot.dir,
             saveWidget(frameableWidget(graph.html),
                        file = paste0(fig.name, ".html"),
                        selfcontained = FALSE,
                        libdir = "./libs"))
    #saveWidgetFix(frameableWidget(graph.html),
    #              file = paste0(plot.dir, fig.name, ".html"),
    #              libdir="./libs") # HTML Interative Plot
}
