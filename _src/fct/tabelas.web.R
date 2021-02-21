# funcao para gerar tabelas que vao para o site
tabelas.web <- function(output.dir,
                        tipo,
                        df.cum, # data frame com os casos acumulados
                        df.td = NULL, # data frame com o tempo de duplicacao
                        df.re = NULL, # data frame com o r efetivo
                        data_base) { #data real da última atualização de cada objeto
  # MIN-MAX ####
  ## com n casos min e maximo na data maxima de projecao
  # minmax.casos <- data.frame(row.names = sigla.adm)
  min <- as.integer(df.cum[max(nrow(df.cum)), 'now.low.c.proj'])
  max <- as.integer(df.cum[max(nrow(df.cum)), 'now.upp.c.proj'])
  data <- format(max(as.Date(df.cum$data)), "%d/%m/%Y")
  minmax.casos <- cbind(min, max, data)
  write.table(minmax.casos,
              file = paste0(output.dir, "data_forecast_exp_", tipo, ".csv"),
              row.names = TRUE, col.names = FALSE)
  # TEMPO DE DUPLICACAO ####
  if (! is.null(df.td)) {
    #temp.dupl <- data.frame(row.names = sigla.adm)
    min.dias <- as.vector(round(df.td[max(nrow(df.td)), "ic.inf"], 1))
    max.dias <- as.vector(round(df.td[max(nrow(df.td)), "ic.sup"], 1))
    temp.dupl <- cbind(min.dias, max.dias)
    write.table(temp.dupl,
                file = paste0(output.dir, "data_tempo_dupli_", tipo, ".csv"),
                row.names = TRUE, col.names = FALSE)
  }
  #data_atualizacao
  data_atualizacao <- format(as.Date(data_base, "%Y_%m_%d"), "%d/%m/%Y")
  write.table(data_atualizacao,
              file = paste0(output.dir, "data_atualizacao_", tipo, ".csv"),
              row.names = TRUE, col.names = FALSE)

  if (tipo %in% c("covid", "srag")) { #so calcula re para covid e srag
    # R EFETIVO ####
    #Re.efe <- data.frame(row.names = sigla.adm)
    min <- as.vector(round(df.re[nrow(df.re), "Quantile.0.025.R"], 2))
    max <- as.vector(round(df.re[nrow(df.re), "Quantile.0.975.R"], 2))
    Re.efe <- cbind(min, max)
    write.table(Re.efe,
                file = paste0(output.dir, "data_Re_", tipo, ".csv"),
                row.names = TRUE, col.names = FALSE)


    lista <- list(minmax.casos = minmax.casos,
                  Re = Re.efe,
                  data_atualizacao = data_atualizacao)
    if (! is.null(df.td)) {
      lista[["temp.dupl"]] = temp.dupl
    }
  }
  if (tipo %in% c("obitos_covid", "obitos_srag", "obitos_srag_proaim")) {
    lista <- list(minmax.casos = minmax.casos,
                  data_atualizacao = data_atualizacao)
    if (! is.null(df.td)) {
      lista[["temp.dupl"]] = temp.dupl
    }
  }
  return(lista)
}
