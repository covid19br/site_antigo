# Libraries
library(widgetframe)
library(tidyverse)
library(plotly)
library(lubridate)
library(optparse)
library(Hmisc)
library(stringr)
library(withr)

##############################################################################
# Helper Functions ###########################################################
##############################################################################
## lista de nomes
makeNamedList <- function(...) {
  structure(list(...), names = as.list(substitute(list(...)))[-1L])
}
##############################################################################

# if executed from command line, look for arguments
# else variable `mun` is assumed to be defined
if (sys.nframe() == 0L) {
  # Parsing command line arguments
  option_list <- list(
    make_option("--escala", default = "municipio",
                help = ("Selecione uma escala administrativa: estado, municipio"),
                metavar = "escala"),
    make_option("--sigla", default = "SP",
                help = ("Estado a ser atualizado"),
                metavar = "sigla"),
    make_option("--dataBase", default = "NULL",
                help = ("Data da base de dados, formato 'yyyy-mm-dd'"),
                metavar = "dataBase"),
    make_option("--formatoData", default = "%Y-%m-%d",
                help = ("Formato do campo de datas no csv, confome padrão da função as.Date"),
                metavar = "formatoData")
  )
  #ö checar os detalles do parse usage aqui
  parser_object <- OptionParser(usage = "Rscript %prog [Opções] [sigla UF]\n",
                                option_list = option_list,
                                description = "Script para atualizar análise e plots do site do OBSERVATORIO COVID-19 BR com resultados por município ou estado")
  
  opt <- parse_args(parser_object, args = commandArgs(trailingOnly = TRUE), 
                    positional_arguments = TRUE)
  
  ## aliases
adm <- opt$options$escala
sigla.adm <- opt$options$sigla
data.base <- opt$options$dataBase
formato.data <- opt$options$formatoData
#ö: isto ficou assim porque municipio SP ainda está independente o terminal vai perguntar estado e sigla. mas isso não muda a parametrizaçãõ de adm e sigla.adm
}

#if you are going to run this interactively uncomment: 
#adm <- "municipio"
#sigla.adm <- "SP"
#data.base <- NULL #"2020-05-13"
#formato.data <- "%Y-%m-%d"
if (!exists('sigla.adm')) {
  print("Sigla do estado não definida")
  quit(status = 1)
}
print(paste("Atualizando", adm , sigla.adm))

sigla.municipios <- c(SP = "São Paulo",
                      RJ = "Rio de Janeiro")

estados <- read.csv("../dados/estados_code.csv", row.names = 1,
                    stringsAsFactors = F)
sigla.estados <- estados$nome
names(sigla.estados) <- estados$sigla
#só mantendo o formato de sigla.municipios

if (adm == "estado" & !sigla.adm %in% names(sigla.estados) |
    adm == "municipio" & !sigla.adm %in% names(sigla.municipios)) {
  print(paste(Hmisc::capitalize(adm), sigla.adm, "não consta na lista de suportados."))
  #quit(status = 1)
}
if (adm == "estado")
  nome.adm <- sigla.estados[sigla.adm]
if (adm == "municipio")
  nome.adm <- sigla.municipios[sigla.adm]

# agora prepara_dados* e analises* moram no repo nowcasting
#source('prepara_dados_nowcasting.R')
#source('analises_nowcasting.R')
source('plots_nowcasting.R')

## Data de Atualizacao
print("Atualizando data de atualizacao...")
web.path <- paste0("../web/", adm, "_", sigla.adm, "/")  
file <- file(paste0(web.path, "last.update.", adm, "_", tolower(sigla.adm), ".txt")) # coloco o nome do municipio?#coloquei para diferenciar do de estados
writeLines(c(paste(now())), file)
close(file)

################################################################# ###############
## Atualiza gráficos por estado
################################################################################
print("Atualizando plots...")

# Graficos a serem atualizados
plots.para.atualizar <- makeNamedList(
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
  
  # SVG ####
  # fazendo todos os graficos svg para o site 
  graph.svg <- plots.para.atualizar[[i]] + theme(axis.text = element_text(size = 6.65), # corrige a diferenca do tamanho do texto entre svg e html
                                                 plot.margin = margin(10, 0, 0, 7, "pt")) # corrige a margem inserida pelo plotly
  ggsave(paste(web.path, ".svg", sep = ""),  plot = graph.svg, device = svg, scale = 1, width = 215, height = 146, units = "mm")
  # tamanho calculado usando ppi = 141.21
  # o tamanho do texto no placeholder deve ser um fator de 0.665 do tamanho original
  # large
  graph.sm.svg <- graph.svg + theme(axis.text = element_text(size = 8.65)) # corrige a diferenca do tamanho do texto entre svg e html
  ggsave(paste(web.path, ".lg.svg", sep = ""),  plot = graph.sm.svg, device = svg, scale = 1, width = 215, height = 146, units = "mm")
  # medium
  graph.sm.svg <- graph.svg + theme(axis.text = element_text(size = 12.65)) # corrige a diferenca do tamanho do texto entre svg e html
  ggsave(paste(web.path,".md.svg",sep = ""), plot = graph.sm.svg, device = svg, scale = 1, width = 215, height = 146, units = "mm")
  # small
  graph.sm.svg <- graph.svg + theme(axis.text = element_text(size = 16.65)) # corrige a diferenca do tamanho do texto entre svg e html
  ggsave(paste(web.path,".sm.svg", sep = ""), plot = graph.sm.svg, device = svg, scale = 1, width = 215, height = 146, units = "mm")
  # extra small
  graph.sm.svg <- graph.svg + theme(axis.text = element_text(size = 20.65)) # corrige a diferenca do tamanho do texto entre svg e html
  ggsave(paste(web.path,".ex.svg", sep = ""), plot = graph.sm.svg, device = svg, scale = 1, width = 215, height = 146, units = "mm")
  
  # HTML ####
  graph.html <- ggplotly(plots.para.atualizar[[i]]) %>%
    layout(margin = list(l = 50, r = 20, b = 20, t = 20, pad = 4))
  with_dir(web.path, 
           saveWidget(frameableWidget(graph.html), 
                      file = paste0(fig.name, ".html"),
                      selfcontained = FALSE,
                      libdir = "./libs")) # HTML Interative Plot
  ggsave(paste(web.path, fig.name, ".svg", sep = ""), 
         plot = graph.svg, device = svg, scale = .8, width = 210, height = 142, units = "mm")
}

