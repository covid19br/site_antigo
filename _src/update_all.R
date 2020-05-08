source("update.R")
source("update_estado.R")
source("update_modelogro.R")

municipios <- c("SP")

for (mun in municipios){
    source("update_municipio.R")
}
