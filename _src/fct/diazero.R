#' Corta uma série temporal no dia zero.
#' @details Esta função corta um objeto da classe zoo, tirando todos
#'     os valores anteriores ao primeiro valor igual a um certo limite
#'     (n.casos).
#' @param zoo.obj: objeto da classe zoo, com a série temporal
#' @param valor limite para iniciar a série. Todas as datas anteriores
#'     à primeira ocorrência desse valor serão retiradas da série.
diazero <- function(zoo.obj, limite){
    dia.zero <- min(which(zoo.obj>=limite, arr.ind=TRUE))
    zoo.obj[dia.zero:length(zoo.obj)]
}
