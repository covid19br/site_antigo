library(rmarkdown)

estados.para.atualizar <- c('SP', 'RJ')

source('prepara_dados.R')
source('ajuste_projecao_exponencial.R')
source('plots.R')

sigla.estado <- c(AC="Acre", AL="Alagoas", AP="Amapá", AM="Amazonas",
                  BA="Bahia", CE="Ceará", DF="Distrito Federal", ES="Espírito Santo",
                  GO="Goiás", MA="Maranhão", MT="Mato Grosso",
                  MS="Mato Grosso do Sul", MG="Minas Gerais", PA="Pará", PB="Paraíba",
                  PR="Paraná", PE="Pernambuco", PI="Piauí", RJ="Rio de Janeiro",
                  RN="Rio Grande do Norte", RS="Rio Grande do Sul",
                  RO="Rondônia", RR="Roraima", SC="Santa Catarina",
                  SP="São Paulo", SE="Sergipe", TO="Tocantins")

dynamic_pages <- c('index.Rmd', 'informacoes.Rmd', 'projecao.Rmd')
# 'propagacao.Rmd', 'transmissao.Rmd'
# 'casos.Rmd', 

for (f in dynamic_pages){
    rmarkdown::render(f, output_dir='../')
}

for (st in estados.para.atualizar){
    rmarkdown::render('estado.Rmd', output_dir='../',
                      output_file=paste0('../', st, '.html'))
}
