# funcao para gerar tabelas que vao para o site
tabelas.web <- function(sigla.adm, # sigla da unidade administrativa
                        output.dir, 
                        tipo,
                        df.cum, # data frame com os casos acumulados
                        df.td, # data frame com o tempo de duplicacao
                        df.re = NULL) { # data frame com o r efetivo
  # MIN-MAX ####
  ## com n casos min e maximo na data maxima de projecao
  minmax.casos <- data.frame(row.names = sigla.adm)
  min <- as.integer(df.cum[max(nrow(df.cum)), 'now.low.c.proj'])
  max <- as.integer(df.cum[max(nrow(df.cum)), 'now.upp.c.proj'])
  data <- format(max(as.Date(df.cum$data)), "%d/%m/%Y")
  minmax.casos <- cbind(minmax.casos, min, max, data)
  write.table(minmax.casos, 
              file = paste0(output.dir, "data_forecasr_exp_", adm, "_", tolower(sigla.adm), "_", tipo, ".csv"), 
              row.names = TRUE, col.names = FALSE)
  # TEMPO DE DUPLICACAO ####
  temp.dupl <- data.frame(row.names = sigla.adm)
  min.dias <- as.vector(round(df.td[max(nrow(df.td)), "ic.inf"], 1))
  max.dias <- as.vector(round(df.td[max(nrow(df.td)), "ic.inf"], 1))
  temp.dupl <- cbind(temp.dupl, min.dias, max.dias)
  write.table(temp.dupl, 
              file = paste0(output.dir, "data_tempo_dupli_", adm, "_", tolower(sigla.adm), "_", tipo, ".csv"), 
              row.names = TRUE, col.names = FALSE)
  if (tipo %in% c("covid", "srag")) { #so calcula re para covid e srag
    # R EFETIVO ####
    Re.efe <- data.frame(row.names = sigla.adm)
    min <- as.factor(round(df.re[nrow(df.re), "Quantile.0.025.R"], 1))
    max <- as.factor(round(df.re[nrow(df.re), "Quantile.0.975.R"], 1))
    Re.efe <- cbind(Re.efe, min, max)
    write.table(Re.efe, 
                file = paste0(output.dir, "data_Re_", adm, "_", tolower(sigla.adm), "_", tipo, ".csv"), 
                row.names = TRUE, col.names = FALSE)
    lista <- list(minmax.casos = minmax.casos, temp.dupl = temp.dupl, Re = Re.efe)
  } 
  if (tipo %in% c("obitos_covid", "obitos_srag", "obitos_srag_proaim")) {
    lista <- list(minmax.casos = minmax.casos, temp.dupl = temp.dupl)
  }
  return(lista)
}
