library(optparse)
library(rmarkdown)

## Parsing command line arguments
option_list <- list(
    make_option("--municipio", 
        help = ("Arquivo dbf com base sivep gripe"),
        metavar = "mun"),
    )

parser_object <- OptionParser(usage = "Rscript %prog [Opções] [ARQUIVO]\n", 
                              option_list = option_list, 
                              description = "Script para atualizar análise e plots do site do OBSERVATORIO COVID-19 BR com resultados por município")

opt <- parse_args(parser_object, args = commandArgs(trailingOnly = TRUE), positional_arguments=TRUE)

## aliases
mun <- opt$options$mun

sigla.municipios <- c(SP="São Paulo")

if (! mun %in% names(sigla.municipios)){
    print(paste0("Município ", mun, " não consta na lista de suportados."))
    quit(status=1)
}
municipio <- sigla.municipios[mun]

# preparação dos dados específica por município?
# este arquivo deve se encarregar de procurar na pasta certa pelo arquivo com a
# data mais recente
source(paste0('prepara_dados_municipio_', mun, '.R'))

# códigos de análise e plot genéricos (mas pode usar as variáveis `mun` e
# `municipio` pra títulos de plot etc.
source('ajuste_projecao_exponencial_municipio.R')
source('plots_municipio.R')

rmarkdown::render('municipio.Rmd', output_dir='../',
                  output_file=paste0('../municipio_', mun, '.html'))
