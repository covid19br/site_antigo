library(zoo)

#' Ajusta um modelo exponencial para n de casos em função de n de dias
#' passados desde o início da série.
#' @details Ajusta um modelo generalizado misto para contagens
#'     (Poisson) dos valores de uma série temporal em função do número
#'     de dias transcorridos desde o início da série. Como o modelo
#'     Poisson tem função de ligação log, equivale a ajustar uma
#'     função de crescimento exponencial às contagens, mas com erro
#'     não gaussianos e sim Poisson.
#' @param zoo.obj objeto da classe zoo com série temporal univariada
#' @param family nome da distribuição de erros a usar no modelo linear
#'     (ver ajuda em stats::family)
#' @param only.coef se TRUE a função retorna um vetor coms
#'     coeficientes da regressão e seus intervalos de confiança. Se
#'     FALSE retorna o objeto do modelo ajustado, da classe glm.
fitP.exp <- function(zoo.obj, only.coef = TRUE){
    ## Nao funciona com rollaply
    ## if(class(zoo.obj)!="zoo"|!is.null(ncol(zoo.obj)))
    ##    stop("'zoo.obj' deve ser um objeto da classe zoo com uma única variável")
    ndias <- rev(max(time(zoo.obj)) - time(zoo.obj))
    fit <- glm(zoo.obj ~ ndias, family = poisson)
    if(only.coef){
        ci <- confint(profile(fit)) 
        results <- c(coef(fit),ci[1,], ci[2,])
        names(results) <- c("intercept", "coef", "int.low", "int.upp", "coef.low", "coef.upp")
    }
    else
        results  <-  fit
    return(results)
}

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

#' Tempo de duplicação ao longo de uma serie temporal de n de casos
#' @details Toma uma série temporal de n de casos, ajusta a função
#'     fitP.exp a 'running windows' de n de dias fixo ao longo da
#'     série. Retorna um objeto de série temporal com os valores dos
#'     tempos de duplicação em cada janela e seus intervalos de
#'     confiança
#' @param zoo.obj objeto da classe 'zoo' com uma serie temporal univariada (n de casos)
#' @param window.width largura da janela (em unidades de tempo da serie temporal, em geral dias)
dt.rw <- function(zoo.obj, window.width){
    if(class(zoo.obj)!="zoo"|!is.null(dim(zoo.obj)))
        stop("'zoo.obj' deve ser um objeto da classe zoo com uma única variável")
    rollapply(brasil.d0,
              width = window.width,
              FUN = function(x) log(2)/fitP.exp(x)[c("coef","coef.low","coef.upp")],
              align="right")
}
