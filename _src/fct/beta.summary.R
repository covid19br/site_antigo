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
