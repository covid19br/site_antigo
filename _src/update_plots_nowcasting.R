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

################################################################################
## Parsing command line arguments
################################################################################
if (sys.nframe() == 0L) {
    # Parsing command line arguments
    option_list <- list(
                        make_option("--escala", default = "municipio",
                                    help = ("Nível administrativo, um de: municipio, micro, meso, estado, drs, país"),
                                    metavar = "escala"),
                        make_option("--sigla", default = "SP",
                                    help = ("Sigla do estado a ser atualizado"),
                                    metavar = "sigla"),
                        make_option("--geocode",
                                    help = ("Geocode de município, micro-mesorregião ou estado"),
                                    metavar = "geocode"),
                        make_option("--dataBase",
                                    help = ("Data da base de dados, formato 'yyyy_mm_dd'"),
                                    metavar = "dataBase"),
                        make_option("--updateGit", default = "FALSE",
                                    help = ("Fazer git add, commit e push?"),
                                    metavar = "updateGit")
    )
    parser_object <- OptionParser(usage = "Rscript %prog [Opções] [município]\n",
                                  option_list = option_list,
                                  description = "Script para atualizar plots do site do OBSERVATORIO COVID-19 BR com resultados por escala")

    ## TO TEST INTERACTIVELY the command-line arguments
    #input <- "--escala municipio --geocode 355030"
    #command.args <- strsplit(input, " ")[[1]]
    #opt <- parse_args(parser_object, args = command.args, positional_arguments = TRUE)
    ## SKIP opt line below
    opt <- parse_args(parser_object, args = commandArgs(trailingOnly = TRUE), positional_arguments=TRUE)
    ## aliases
    escala <- opt$options$escala
    sigla <- opt$options$sigla
    geocode <- opt$options$geocode
    data <- opt$options$dataBase
    update.git <- opt$options$updateGit

    options(error = function() quit(save="no", status=1))
}

if (update.git)
    system("git pull")

if (!exists('geocode')) {
    print("Geocode não definido")
    quit(status = 1)
}
# sets paths
name_path <- check.geocode(escala = escala, geocode = geocode, sigla = sigla)
# dir para os ler os dados
data.dir <- paste0("../dados/", name_path,
                   "/tabelas_nowcasting_para_grafico/")
# dir para os outputs, separados em subpastas
plot.dir <- paste0("../web/", name_path, "/")
if (!dir.exists(plot.dir)) dir.create(plot.dir, recursive = TRUE)

# pegando a data mais recente
if (is.null(data)) {
    data <- get.last.date(data.dir)
}

print(paste0("Gerando plots ", name_path))

#####################################################################
## 1. Plot diários, acumulados, tempo de duplicação e Re
## 2. Exporta tabelas com números do dia
###################################################################

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
existe.ob.srag.proaim <- existe.nowcasting2(tipo = "obitos_srag_proaim",
                                            output.dir = data.dir,
                                            data = data)

#############
## COVID ####
#############

if (existe.covid) {
  data.covid <- data
  df.covid.diario <- read.csv(paste0(data.dir, "nowcasting_diario_covid_", data.covid, ".csv"),
                              stringsAsFactors = FALSE)
  df.covid.cum <- read.csv(paste0(data.dir, "nowcasting_acumulado_covid_", data.covid, ".csv"),
                           stringsAsFactors = FALSE)
  df.td.covid <- read.csv(paste0(data.dir, "tempo_duplicacao_covid_", data.covid, ".csv"),
                          stringsAsFactors = FALSE)
  df.re.covid <- read.csv(paste0(data.dir, "r_efetivo_covid_", data.covid, ".csv"),
                          stringsAsFactors = FALSE)
  # PLOTS ####
  ### diario
  ## N de novos casos observados e por nowcasting
  ## Com linha de média móvel
  plot.nowcast.covid <- plot.nowcast.diario(df.covid.diario)

  ### acumulado
  plot.nowcast.cum.covid <- plot.nowcast.acumulado(df.covid.cum)

  ### tempo de duplicação
  plot.tempo.dupl.covid <- plot.tempo.dupl(df.td.covid)

  ### R efetivo
  plot.estimate.R0.covid <- plot.estimate.R0(df.re.covid)

  # TABELAS ####
  ## Tabela que preenche o minimo e o maximo do nowcast, tempo de duplicacao, e r efetivo
  tabelas.web(plot.dir,
              tipo = "covid",
              df.cum = df.covid.cum,
              df.td = df.td.covid,
              df.re = df.re.covid,
              data_base = data.covid)

} else {
  plot.nowcast.covid <- NULL
  plot.nowcast.cum.covid <- NULL
  plot.estimate.R0.covid <- NULL
  plot.tempo.dupl.covid <- NULL
  data_atualizacao <- NULL
}

############
## SRAG ####
############

if (existe.srag) {
  data.srag <- data
  df.srag.diario <- read.csv(paste0(data.dir, "nowcasting_diario_srag_", data.srag, ".csv"),
                             stringsAsFactors = FALSE)
  df.srag.cum <- read.csv(paste0(data.dir, "nowcasting_acumulado_srag_", data.srag, ".csv"),
                          stringsAsFactors = FALSE)
  df.td.srag <- read.csv(paste0(data.dir, "tempo_duplicacao_srag_", data.srag, ".csv"),
                         stringsAsFactors = FALSE)
  df.re.srag <- read.csv(paste0(data.dir, "r_efetivo_srag_", data.srag, ".csv"),
                         stringsAsFactors = FALSE)
  # PLOTS ####
  ### diario
  ## N de novos casos observados e por nowcasting
  ## Com linha de média móvel
  plot.nowcast.srag <- df.srag.diario %>%
    dplyr::filter(data > "2020-03-15") %>%
    plot.nowcast.diario()

  ### acumulado
  plot.nowcast.cum.srag <- df.srag.cum %>%
    dplyr::filter(data > "2020-03-15") %>%
    plot.nowcast.acumulado()

  ### tempo de duplicação
  plot.tempo.dupl.srag <- df.td.srag %>%
    dplyr::filter(data > "2020-03-15") %>%
    plot.tempo.dupl()

  ### R efetivo
  plot.estimate.R0.srag <- df.re.srag %>%
    dplyr::filter(data > "2020-03-15") %>%
    plot.estimate.R0()

  # TABELAS ####
  tabelas.web(plot.dir,
              tipo = "srag",
              df.cum = df.srag.cum,
              df.td = df.td.srag,
              df.re = df.re.srag,
              data_base = data.srag)
} else {
  plot.nowcast.srag <- NULL
  plot.nowcast.cum.srag <- NULL
  plot.estimate.R0.srag <- NULL
  plot.tempo.dupl.srag <- NULL
  data_atualizacao <- NULL
}

#####################
## OBITOS COVID ####
#####################

if (existe.ob.covid) {
  data.ob.covid <- data
  df.ob.covid.diario <- read.csv(paste0(data.dir, "nowcasting_diario_obitos_covid_", data.ob.covid, ".csv"),
                                 stringsAsFactors = FALSE)
  df.ob.covid.cum <- read.csv(paste0(data.dir, "nowcasting_acumulado_obitos_covid_", data.ob.covid, ".csv"),
                              stringsAsFactors = FALSE)
  df.td.ob.covid <- read.csv(paste0(data.dir, "tempo_duplicacao_obitos_covid_", data.ob.covid, ".csv"),
                             stringsAsFactors = FALSE)
  ### diario
  ## N de novos casos observados e por nowcasting
  ## Com linha de média móvel
  plot.nowcast.ob.covid <- plot.nowcast.diario(df.ob.covid.diario) +
    xlab("Dia") +
    ylab("Número de novos óbitos")

  ### acumulado
  plot.nowcast.cum.ob.covid <- plot.nowcast.acumulado(df.ob.covid.cum) +
    xlab("Dia") +
    ylab("Número acumulado de óbitos")

  ### tempo de duplicação
  plot.tempo.dupl.ob.covid <- plot.tempo.dupl(df.td.ob.covid)

  # TABELAS ####
  tabelas.web(plot.dir,
              tipo = "obitos_covid",
              df.cum = df.ob.covid.cum,
              df.td = df.td.ob.covid,
              data_base = data.ob.covid)
} else {
  plot.nowcast.ob.covid <- NULL
  plot.nowcast.cum.ob.covid <- NULL
  plot.tempo.dupl.ob.covid <- NULL
  data_atualizacao <- NULL
}

####################
## OBITOS SRAG ####
####################

if (existe.ob.srag) {
  data.ob.srag <- data
  df.ob.srag.diario <- read.csv(paste0(data.dir, "nowcasting_diario_obitos_srag_", data.ob.srag, ".csv"),
                                stringsAsFactors = FALSE)
  df.ob.srag.cum <- read.csv(paste0(data.dir, "nowcasting_acumulado_obitos_srag_", data.ob.srag, ".csv"),
                             stringsAsFactors = FALSE)
  df.td.ob.srag <- read.csv(paste0(data.dir, "tempo_duplicacao_obitos_srag_", data.ob.srag, ".csv"),
                            stringsAsFactors = FALSE)
  ### diario
  ## N de novos casos observados e por nowcasting
  ## Com linha de média móvel
  plot.nowcast.ob.srag <- df.ob.srag.diario %>%
    dplyr::filter(data > "2020-03-15") %>%
    plot.nowcast.diario() +
    xlab("Dia") +
    ylab("Número de novos óbitos")

  ### acumulado
  plot.nowcast.cum.ob.srag <- df.ob.srag.cum %>%
    dplyr::filter(data > "2020-03-15") %>%
    plot.nowcast.acumulado() +
    xlab("Dia") +
    ylab("Número acumulado de óbitos")

  ### tempo de duplicação
  plot.tempo.dupl.ob.srag <- df.td.ob.srag %>%
    dplyr::filter(data > "2020-03-15") %>%
    plot.tempo.dupl()

  # TABELAS ####
    tabelas.web(plot.dir,
                tipo = "obitos_srag",
                df.cum = df.ob.srag.cum,
                df.td = df.td.ob.srag,
                data_base = data.ob.srag)
} else {
  plot.nowcast.ob.srag <- NULL
  plot.nowcast.cum.ob.srag <- NULL
  plot.tempo.dupl.ob.srag <- NULL
  data_atualizacao <- NULL
}

#########################
# OBITOS SRAG PROAIM ####
#########################

if (existe.ob.srag.proaim) {
    df.ob.srag.diario.proaim <- read.csv(paste0(data.dir, "nowcasting_diario_obitos_srag_proaim_",
                                                data, ".csv"))
    df.ob.srag.cum.proaim <- read.csv(paste0(data.dir, "nowcasting_acumulado_obitos_srag_proaim_",
                                             data, ".csv"))
    df.td.ob.srag.proaim <- read.csv(paste0(data.dir, "tempo_duplicacao_obitos_srag_proaim_", data, ".csv"))
    ### diario
    ## N de novos casos observados e por nowcasting
    ## Com linha de média móvel
    plot.nowcast.ob.srag.proaim <- plot.nowcast.diario(df.ob.srag.diario.proaim) +
        xlab("Dia") +
        ylab("Número de novos óbitos")

    ### acumulado
    plot.nowcast.cum.ob.srag.proaim <- plot.nowcast.acumulado(df.ob.srag.cum.proaim) +
        xlab("Dia") +
        ylab("Número acumulado de óbitos")

    ### tempo de duplicação
    plot.tempo.dupl.ob.srag.proaim <- plot.tempo.dupl(df.td.ob.srag.proaim)
    # TABELAS ####
    tabelas.web(plot.dir,
                tipo = "obitos_srag_proaim",
                df.ob.srag.cum.proaim,
                df.td.ob.srag.proaim)
} else {
    plot.nowcast.ob.srag.proaim <- NULL
    plot.nowcast.cum.ob.srag.proaim <- NULL
    plot.tempo.dupl.ob.srag.proaim <- NULL
}

## Data de Atualizacao
print("Atualizando data de atualizacao...")
file <- file(paste0(plot.dir, "last.update.txt"))
writeLines(c(paste(now())), file)
close(file)

################################################################# ###############
## Atualiza gráficos por estado
################################################################################
print("Atualizando plots...")

# Graficos a serem atualizados
plots.para.atualizar <-
    makeNamedList(
                  # covid
                  plot.nowcast.covid,
                  plot.nowcast.cum.covid,
                  plot.estimate.R0.covid,
                  plot.tempo.dupl.covid,
                  # srag
                  plot.nowcast.srag,
                  plot.nowcast.cum.srag,
                  plot.estimate.R0.srag,
                  plot.tempo.dupl.srag,
                  # obitos covid
                  plot.nowcast.ob.covid,
                  plot.nowcast.cum.ob.covid,
                  plot.tempo.dupl.ob.covid,
                  # obitos srag
                  plot.nowcast.ob.srag,
                  plot.nowcast.cum.ob.srag,
                  plot.tempo.dupl.ob.srag,
                  #obitos srag.proaim
                  plot.nowcast.ob.srag.proaim,
                  plot.nowcast.cum.ob.srag.proaim,
                  plot.tempo.dupl.ob.srag.proaim
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
           device = svg, scale = 1, width = 215, height = 146, units = "mm")
    # tamanho calculado usando ppi = 141.21
    #ggsave(paste0(plot.dir, fig.name, ".svg"), plot = graph.svg,
    #       device = svg, scale = .8, width = 210, height = 142, units = "mm")
    # o tamanho do texto no placeholder deve ser um fator de 0.665 do tamanho original
    # large
    graph.lg.svg <- graph.svg +
        # corrige a diferenca do tamanho do texto entre svg e html
        theme(axis.text = element_text(size = 8.65))
    ggsave(paste0(plot.dir, fig.name, ".lg.svg"), plot = graph.lg.svg,
           device = svg, scale = 1, width = 215, height = 146, units = "mm")
    # medium
    graph.md.svg <- graph.svg +
        # corrige a diferenca do tamanho do texto entre svg e html
        theme(axis.text = element_text(size = 12.65))
    ggsave(paste0(plot.dir, fig.name, ".md.svg"), plot = graph.md.svg,
           device = svg, scale = 1, width = 215, height = 146, units = "mm")
    # small
    graph.sm.svg <- graph.svg +
        # corrige a diferenca do tamanho do texto entre svg e html
        theme(axis.text = element_text(size = 16.65))
    ggsave(paste0(plot.dir, fig.name, ".sm.svg"), plot = graph.sm.svg,
           device = svg, scale = 1, width = 215, height = 146, units = "mm")
    # extra small
    graph.ex.svg <- graph.svg +
        # corrige a diferenca do tamanho do texto entre svg e html
        theme(axis.text = element_text(size = 20.65))
    ggsave(paste0(plot.dir, fig.name, ".ex.svg"), plot = graph.ex.svg,
           device = svg, scale = 1, width = 215, height = 146, units = "mm")

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
