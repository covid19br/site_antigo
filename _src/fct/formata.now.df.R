## Funcao para formatar data.frame para o grafico de nowcasting casos diarios e acumulados
formata.now.df <- function(now.pred.zoo, 
                           now.proj.zoo,
                           lista) { # aceita "caso" para casos diarios ou "cum" para acumulados
    # Helper function
    end.time <- function(pred.zoo, pred.zoo.original){
        if (min(time(pred.zoo.original)) < min(time(pred.zoo))) {
            end.time <- min(time(pred.zoo))
        } else {
            end.time <- min(time(pred.zoo.original))
        }
        return(end.time)
    }
    ## PARA O PLOT CASOS DIARIOS ####
    end.time.now <- end.time(now.pred.zoo, lista$now.pred.zoo.original)
    time.now <- time(now.pred.zoo)
    df.zoo <- cbind(as.data.frame(now.pred.zoo), data = as.character(time.now))
    # notificados
    df.not <- as.data.frame(window(now.pred.zoo, end = end.time.now))
    df.not$tipo <- "Notificado"
    df.not$data <- row.names(df.not)
    # nowcasting
    df.now <- as.data.frame(window(now.pred.zoo, start = min(time(lista$now.pred.zoo.original)) + 1))
    df.now$tipo <- "Nowcasting"
    df.now$data <- row.names(df.now)
    # predict
    df.pred <- as.data.frame(window(now.pred.zoo, start = min(time(lista$now.pred.zoo.original)) + 1))
    names(df.pred) <- paste0(names(df.pred), ".pred")
    df.pred$data <- row.names(df.pred)
    ## finalmente gera o df diario
    df.diario <- full_join(df.not[, c('data', 'n.casos')], df.now[, c('data', 'estimate')]) %>%
        full_join(., df.zoo[, c('data', 'estimate.merged', 'estimate.merged.smooth')]) %>%
        full_join(., df.pred[, c('data', 'lower.merged.pred', 'upper.merged.pred')]) %>%
        mutate(data = as.Date(data))
    # PARA O PLOT CASOS ACUMULADOS
    select.cols <- c("data", 
                     'now.mean.c', 
                     'now.mean.c.proj', 'now.low.c.proj', 'now.upp.c.proj',
                     'not.mean.c', 
                     'not.mean.c.proj', 'not.low.c.proj', 'not.upp.c.proj')
    # estimados
    df.cum1 <- as.data.frame(window(now.proj.zoo, end = max(time(now.pred.zoo))))
    df.cum1$data <- row.names(df.cum1)
    # notificados
    df.cum2 <- as.data.frame(window(now.proj.zoo, start = max(time(now.pred.zoo))))
    names(df.cum2) <- paste0(names(df.cum2), ".proj")
    df.cum2$data <- row.names(df.cum2)
    # gera o df para casos acumulados
    df.cum <- full_join(df.cum1, 
                        df.cum2) %>%
        select(select.cols) %>%
        mutate(data = as.Date(data)) %>%
        mutate_all(funs(round(., 0)))
    lista.plot <- list(diario = df.diario, acumulado = df.cum)
    return(lista.plot)
}
