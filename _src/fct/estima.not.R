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
