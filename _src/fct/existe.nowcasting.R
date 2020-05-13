## Função para checar se existem dados de nowcasting para a unidade administrativa
existe.nowcasting <- function(adm = adm, 
                              sigla.adm = sigla.adm, 
                              tipo,
                              data = NULL) { 
  if (is.null(data)) {
    data_file <- get.data.base(adm = adm, sigla.adm = sigla.adm, tipo = tipo)}
  else data_file <- as.Date(data, format = formato.data) %>%  format("%Y_%m_%d")
    nome.dir <- paste0("../dados/", adm, "_", sigla.adm, "/")
    nowcasting.file <- list.files(path = nome.dir, 
                                  pattern = paste0("nowcasting_", tipo, ".+", data_file,".csv"))
    length(nowcasting.file) > 0
}
