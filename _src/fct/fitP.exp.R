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
    ndias <- as.vector ( rev(max(time(zoo.obj)) - time(zoo.obj)) )
    fit <- try(glm(zoo.obj ~ ndias, family = poisson))
    if(only.coef){
            ci <- try(confint(fit))
            if(any(class(fit)=="try-error")||any(class(ci)=="try-error"))
                results <- rep(NA,6)
            else
                results <- c(coef(fit),ci[1,], ci[2,])
            names(results) <- c("intercept", "coef", "int.low", "int.upp", "coef.low", "coef.upp")
    }
    if(!only.coef){
        if(class(fit)=="try-error")
            results <- NA
        else
            results  <-  fit
    }
    return(results)
}
