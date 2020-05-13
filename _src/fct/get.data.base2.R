# extrai a data mais recente de nowcasting
get.data.base2 <- function(adm, sigla.adm, tipo) {
  nome.dir <- paste0("../dados/", adm, "_", sigla.adm, "/tabelas_nowcasting_para_grafico/")
  data.base <- dir(nome.dir, pattern = paste0("nowcasting_acumulado_", tipo, "_20")) %>% 
    stringr::str_extract("(19|20)\\d\\d[_ /.](0[1-9]|1[012])[_ /.](0[1-9]|[12][0-9]|3[01])") %>% #prfct
    as.Date(format = "%Y_%m_%d") %>%
    max() %>%
    format("%Y_%m_%d")
}
