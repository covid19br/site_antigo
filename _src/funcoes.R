library(zoo)
library(EpiEstim)

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
        if(any(class(fit)=="try-error"))
            results <- NA
        else
            results  <-  fit
    }
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


#' Médias e ICs das probabilidades de notificação a cada dia
#' @param NobBS.output objeto retornado pela função NobBS do pacote de
#'     mesmo nome Este argumento é ignorado se o argumento
#'     NobBS.params.post é usado.
#' @param NobBS.params.post data frame com as distribuicoes
#'     posteriores dos parâmetros estimados pela função NobBS. Está
#'     contido na lista que é retornada pela função.
#' @return data frame com média e quantis 2.5% e 97.5% das
#'     distribuições a posteriori dos parâmetros de atraso de
#'     notificação pelo método de nowcasting da função NobBS. Os
#'     valores estão convertidos para escala de probabilidade, e
#'     portanto podem ser interpretado como a probabilidade de um caso
#'     ser notificado D dias após o dias o primeiro sintoma, sendo que
#'     vai de zero ao máximo definido pelos argumentos do nowcasting
beta.summary <- function(NobBS.output, NobBS.params.post){
    if(missing(NobBS.params.post))
        df <- NobBS.output$params.post
    else
        df <- NobBS.params.post
    df1 <- df[, names(df)[grepl("Beta",names(df))]]
    data.frame(atraso = as.integer(substr(names(df1), 6, 8)),
               mean = exp(apply(df1, 2, mean)),
               lower = exp(apply(df1, 2, quantile, 0.025)),
               upper = exp(apply(df1, 2, quantile, 0.975)),
               row.names = names(df1))    
}

#' Estima numero de notificacoes por dia a partir de um vetor de n de
#' casos novos e da distribuição de probabilidades de notificação do
#' nowcasting
#' @param vetor.casos objeto da classe zoo com n de casos
#' @param NobBS.output objeto retornado pela função NobBS do pacote de
#'     mesmo nome. Este argumento é ignorado se o argumento
#'     NobBS.params.post é usado.
#' @param NobBS.params.post data frame com as distribuicoes
#'     posteriores dos parâmetros estimados pela função NobBS. Está
#'     contido na lista que é retornada pela função.
#' @param from posicao do vetor de casos a partir da qual estimar o
#'     numero de notificacões
estima.not <- function(vetor.casos, NobBS.output, NobBS.params.post, from = length(vetor.casos)-30){
    if(missing(NobBS.params.post))
        betas <- beta.summary(NobBS.output)$mean
    else
        betas <- beta.summary(NobBS.params.post = NobBS.params.post)$mean
    i <- length(vetor.casos)-length(betas)
    if(i<0) stop(paste("vetor.casos deve ter comprimento maior ou igual a", length(betas))) 
    else if(i>0)
        y <- vetor.casos[(i+1):length(vetor.casos)]
    else
        y <- vetor.casos
    z <- as.vector(y)
    pred <- rev(cumsum(rev(z*rev(betas))))
    zoo(pred[from:length(z)], time(y)[from:length(z)])
}

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
preenche.now <- function(vetor.now, vetor.casos){
    index <- max(which(is.na(vetor.now), arr.ind=TRUE))
    vetor.now[1:index] <- vetor.casos[1:index]
    return(vetor.now)
}

#' Inverso da funcao logito
inv.logit <- function(x)
    exp(x)/(1+exp(x))

#' substitui NAS por zeros
na.zero <- function(x)
    ifelse(is.na(x), 0, x)

###############################################################################
# Estimating R accounting for uncertainty on the serial interval distribution #
###############################################################################
## - the mean of the SI comes from a Normal(4.8, 0.71), truncated at 3.8 and 6.1
## - the sd of the SI comes from  a Normal(2.3, 0.58), truncated at 1.6 and 3.5
## 
##   day0 : day to start the analysis
##   delay : 7 #number of days
estimate.R0 <- function(novos.casos, day0=8, delay=7, ...){
    config <- make_config(list(si_parametric_distr = "L",
                               mean_si = 4.8, std_mean_si = 0.71,
                               min_mean_si = 3.8, max_mean_si = 6.1,
                               std_si = 2.3, std_std_si = 0.58,
                               min_std_si = 1.6, max_std_si = 3.5,
                               t_start = seq(day0,length(novos.casos)-delay),
                               t_end = seq(delay+day0,length(novos.casos))))
    estimate_R(novos.casos, method = "uncertain_si", config = config)
}

#' Calcula R efetivo sobre a estimativas de nowcasting retornadas pela função NobBS::NobBS
#' @param ncasos vetor de número de novos casos
#' @param datas vetor de datas dos novos casos
Re.com.data <- function(ncasos, datas, dia0 = min(datas), delay = 5){
    if(length(ncasos)!=length(datas)) stop("ncasos e ndatas devem ter o mesmo comprimento")
    day0 <- min(which(datas >= dia0, arr.ind=TRUE))
    if(day0 < delay)
        day0 = delay + 1
    Re <- estimate.R0(as.integer(na.zero(ncasos)), day0 = day0, delay = delay)
    names(Re$R) <- gsub("\\(R\\)", ".R", names(Re$R))
    Re$R$data.inicio <- datas[Re$R$t_start]
    Re$R$data.fim <- datas[Re$R$t_end]
    return(Re)
}
