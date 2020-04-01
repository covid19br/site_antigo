library(dplyr)

# download data
#dados_curr <- read.csv(paste0("https://covid.saude.gov.br/assets/files/BRnCov19_", format(Sys.Date(), "%d%m%Y"), ".csv"), as.is = TRUE, sep = ";")
dados_curr <- read.csv(paste0("https://covid.saude.gov.br/assets/files/COVID19_", format(Sys.Date(), "%Y%m%d"), ".csv"), as.is = TRUE, sep = ";")
dados_curr$data <- as.Date(dados_curr$data, format = "%d/%m/%y")
write.csv(dados_curr, file = paste0("../dados/brutos/BRnCov19_", format(max(dados_curr$data), "%Y%m%d"), ".csv"), row.names = FALSE)

colnames(dados_curr)  <- c("regiao", "estado", "data", "novos.casos",
                           "casos.acumulados", "obitos.novos",
                           "obitos.acumulados")
write.csv(dados_curr, file = "../dados/EstadosCov19.csv", row.names = FALSE)

# dados Brasil
dados_curr %>% group_by(data) %>% summarise(novos.casos=sum(novos.casos), casos.acumulados=sum(casos.acumulados), obitos.novos=sum(obitos.novos), obitos.acumulados=sum(obitos.acumulados)) -> brasil
brasil <- as.data.frame(brasil)
write.csv(brasil, file = "../dados/BrasilCov19.csv", row.names = FALSE)

