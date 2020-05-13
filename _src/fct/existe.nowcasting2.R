## Função para checar se existem dados de nowcasting para a unidade administrativa
existe.nowcasting2 <- function(adm = adm, 
                              sigla.adm = sigla.adm, 
                              tipo,
                              data = NULL) { 
  if (is.null(data)) {
    data_file <- get.data.base2(adm = adm, sigla.adm = sigla.adm, tipo = tipo)}
  else data_file <- as.Date(data, format = formato.data) %>%  format("%Y_%m_%d")
  nome.dir <- paste0("../dados/", adm, "_", sigla.adm, "/tabelas_nowcasting_para_grafico")
  nowcasting.file <- list.files(path = nome.dir, 
                                pattern = paste0("nowcasting_acumulado_", tipo, "_20"))
  length(nowcasting.file) > 0
}
