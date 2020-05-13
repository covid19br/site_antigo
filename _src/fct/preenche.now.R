#' Preenche NA's iniciais do vetor de estimado pelo nowcasting
#' @details O nowcasting retornado pela função NobBS usado com janela
#'     (argumento 'moving_window') ou limite máximo de atraso
#'     (argumento 'max_D') produz estimativas para os últimos dias,
#'     definidos por esses argumentos. Esta função preenche os dias
#'     anteriores com os valores de um outro vetor, normalmente o
#'     vetor de n de casos observado
#' @param vetor.now vetor com número de casos estimados pelo
#'     nowcasting, com NAs nas datas para as quais não há estimativas.
#' @param vetor.casos vetor com numero de casos o observados. Deve ter
#'     mesmo comprimento de 'vetor.now'
preenche.now <- function(vetor.now, vetor.casos) {
  if (any(is.na(vetor.now))) {
    index <- max(which(is.na(vetor.now), arr.ind = TRUE))
    vetor.now[1:index] <- vetor.casos[1:index]
  }
    return(vetor.now)
}

