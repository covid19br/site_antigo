#' Forecast usando regressão Poisson sobre série dos casos acumulados
forecast.exponential <- function(zoo.obj, start, end = length(zoo.obj), days.forecast, ...){
    if(class(zoo.obj)!="zoo"|!is.null(dim(zoo.obj)))
        stop("'zoo.obj' deve ser um objeto da classe zoo com uma única variável")
    if(is.numeric(start))
        inicio <- time(zoo.obj)[start]
    else
        inicio <- start
    if(is.numeric(end))
        fim <- time(zoo.obj)[end]
    else
        fim <- end
    y <- window(zoo.obj, start = inicio, end = fim)
    if(!is.integer(y)) {
        warning("Resposta não está em inteiros, convertendo para inteiro para ajustar glm Poisson")
        y <- as.integer(y)
    }
    fit <- fitP.exp(y, only.coef = FALSE)
    datas.forecast <- fim + (1:days.forecast)
    newdata <- data.frame( ndias = as.vector( datas.forecast - inicio ) )
    pred <- predict(fit, newdata = newdata, se.fit = TRUE)
    df1 <- data.frame(lpred = pred$fit, lse = pred$se.fit)
    df1$predito <- exp(df1$lpred)
    df1$ic.low <-  with(df1, exp(lpred - 2*lse))
    df1$ic.upp <-  with(df1, exp(lpred + 2*lse))
    zoo(df1[,c("predito","ic.low","ic.upp")], datas.forecast)
}
