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
