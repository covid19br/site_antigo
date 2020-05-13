#' Tempo de duplicação ao longo de uma serie temporal de n de casos
#' @details Toma uma série temporal de n de casos, ajusta a função
#'     fitP.exp a 'running windows' de n de dias fixo ao longo da
#'     série. Retorna um objeto de série temporal com os valores dos
#'     tempos de duplicação em cada janela e seus intervalos de
#'     confiança
#' @param zoo.obj objeto da classe 'zoo' com uma serie temporal
#'     univariada (n de casos)
#' @param window.width largura da janela (em unidades de tempo da
#'     serie temporal, em geral dias)
dt.rw <- function(zoo.obj, window.width){
    if(class(zoo.obj)!="zoo"|!is.null(dim(zoo.obj)))
        stop("'zoo.obj' deve ser um objeto da classe zoo com uma única variável")
    rollapply(zoo.obj,
              width = window.width,
              FUN = function(x) log(2)/fitP.exp(x)[c("coef","coef.low","coef.upp")],
              align="right")
}

