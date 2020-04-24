source("update.R")
source("update_estado.R")

municipios <- c("SP")

for (mun in municipios){
    source("update_municipio.R")
}
