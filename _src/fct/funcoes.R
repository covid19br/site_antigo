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
        if(class(fit)=="try-error")
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



################################################################################
## Funcao para proeparacao dos dados de nowcasting
################################################################################
#' Função para automatizar a preparação dos dados de nowcasting por unidade administrativa
#' @details Retira datas dos sufixos dos nomes das bases e identifica a maior data. Só funciona se os nomes das bases forem mantidos no padrão
#' @param tipo Caractere. Nome da base de dados para preparar. Tipos possíveis: `covid` para casos de COVID-19, `srag` para casos de SRAG, `obitos_covid` para óbitos por COVID-19 e `obitos_srag` para óbitos por SRAG
#' @param adm Caractere. Unidade administrativa `estado` ou `municipio`
#' @param sigla.adm Caractere. Sigla da unidade administrativa. Para municípios por enquanto apenas SP disponível
prepara.dados <- function(tipo = "covid", 
                          adm,
                          sigla.adm,
                          data.base) { # tipos possiveis: covid, srag, obitos_covid e obitos_srag
    casos <- c("covid", "srag")
    obitos <- c("obitos_covid", "obitos_srag")
    if (adm == "municipio") {
        if (!sigla.adm %in% c("SP", "RJ")) {
            stop("sigla de municipio invalida")
        }
    }
    nome.dir <- paste0("../dados/", adm, "_", sigla.adm, "/")
    if (missing(data.base))
    data.base <- dir(nome.dir, pattern = paste0("nowcasting", ".+", tipo,".+", "_20")) %>% 
        stringr::str_extract("(19|20)\\d\\d[_ /.](0[1-9]|1[012])[_ /.](0[1-9]|[12][0-9]|3[01])") %>% #prfct
        as.Date(format = "%Y_%m_%d") %>%
        max() %>%
        format("%Y_%m_%d")
    
    
    ## Importa dados em objetos de séries temporais (zoo)
    ## Serie completa de n de notificacoes
    n.notificados <- read.csv(paste0(nome.dir,"notificacoes_", tipo, "_", data.base,".csv"))
    
    #rename columns forever to unify the analyses
    # srm: colocando tambem condicao para definir no nome em n.sintoma
    if (tipo %in% casos) {
        n.notificados <- n.notificados %>%
            rename(dt_col = "dt_notific")
        nome.sint <- "n_casos_data_sintoma_"
    }
    if (tipo %in% obitos) {
        n.notificados <- n.notificados %>% 
            rename(dt_col = "dt_notific") #ast aqui é notific mesmo PI explicou
        nome.sint <- "n_casos_data_"
    }
    n.notificados.zoo <- with(n.notificados, zoo(n.notific, as.Date(dt_col)))#%ast aqui estou usando a renomeada
    
    ## Previsoes de nowcasting e n de casos por data de inicio do sintoma %ast aqui não precisa mudar porque tudo é onset_date
    now.pred.original <- read.csv(paste0(nome.dir, "nowcasting_", tipo, "_previstos_", data.base, ".csv"))
    now.pred.zoo.original <- zoo(now.pred.original[,c("estimate", "lower", "upper")], 
                                 as.Date(now.pred.original[,"onset_date"]))
    
    ## N de casos por data de sintoma
    n.sintoma <- read.csv(paste0(nome.dir, nome.sint, tipo, "_", data.base, ".csv"))
    # adicionando condicao para 
    if (tipo %in% casos)
        n.sintoma.zoo <- with(n.sintoma, zoo(n.casos, as.Date(dt_sin_pri)))
    if (tipo %in% obitos)
        n.sintoma.zoo <- with(n.sintoma, zoo(n.casos, as.Date(dt_evoluca)))#ast aqui igual, dt_sin_pri é dt_evoluca no caso dos obitos
    
    ## Junta todos os casos por data de sintoma com previsao do nowcasting (que só tem os ultimos 40 dias)
    ## VERIFICAR: Total de casos reportado por data do nowcasting tem diferenças com total de casos por data de sintoma tabulado
    now.pred.zoo <- merge(n.casos = n.sintoma.zoo, now.pred.zoo.original)
    ## Retira os dias para os quais há n de casos observados mas nao nowcasting
    now.pred.zoo <- window(now.pred.zoo, start = min(time(n.sintoma.zoo)), end = max(time(now.pred.zoo.original)))
    ## Adiciona variavel de novos casos merged:
    ## junta os valores corrigidos por nowcasting (que em geral vai até um certo ponto no passado)
    ## e n de casos observados antes da data em que começa a correção de nowcasting
    now.pred.zoo$estimate.merged <- with(now.pred.zoo, preenche.now(estimate, n.casos))
    now.pred.zoo$lower.merged <- with(now.pred.zoo, preenche.now(lower, n.casos))
    now.pred.zoo$upper.merged <- with(now.pred.zoo, preenche.now(upper, n.casos))
    ## Media movel da estimativa e dos limites superior e inferiors
    now.pred.zoo$estimate.merged.smooth <- rollapply(now.pred.zoo$estimate.merged, width = 10, mean, partial = TRUE)
    now.pred.zoo$lower.merged.smooth <- rollapply(now.pred.zoo$lower.merged, width = 10, mean, partial = TRUE)
    now.pred.zoo$upper.merged.smooth <- rollapply(now.pred.zoo$upper.merged, width = 10, mean, partial = TRUE)
    
    ## n cumulativo
    now.pred.zoo$estimate.merged.c <- cumsum(now.pred.zoo$estimate.merged)
    now.pred.zoo$lower.merged.c <- cumsum(now.pred.zoo$lower.merged)
    now.pred.zoo$upper.merged.c <- cumsum(now.pred.zoo$upper.merged)
    
    ## Atualiza tb o data.frame
    now.pred <- as.data.frame(now.pred.zoo)
    now.pred$onset_date <- as.Date(rownames(now.pred))
    now.pred <- now.pred[, c(11, 1:10)]
    
    ## Lista com todos os resultados no nowcasting
    ##now.lista <- readRDS(paste0(nome.dir, "nowcasting_", tipo, "_", data.base, ".rds"))

    ## Data frame com as posteriores dos parametros estimados do Nowcasting
    now.params.post <- read.csv(paste0(nome.dir, "nowcasting_", tipo, "_post_", data.base, ".csv"))
    
    # lista para salvar os objetos
    pred <- list(now.pred = now.pred, 
                 now.pred.zoo = now.pred.zoo,
                 now.params.post = now.params.post,
                 now.pred.original = now.pred.original, 
                 now.pred.zoo.original = now.pred.zoo.original
                 ##now.lista = now.lista
                 )
    
    return(pred)
}



################################################################################
## Funcao para projecao do n acumulado de casos por data do sintoma
################################################################################
#' Funcao para projecao do n acumulado de casos por data do sintoma
#' @param pred Data frame. Objeto `now.pred.zoo` gerado em prepara_nowcasting.R
#' @param pred.original Data frame. Objeto `now.pred.original` gerado em prepara_nowcasting.R
#' @param now.lista Lista. Objeto `now.lista` gerado em prepara_dados_nowcasting.R
#' @param now.params.post Data frame. Objeto `now.params.post` gerado em gerado em prepara_dados_nowcasting.R
now.proj <- function(pred, 
                     pred.original, 
                     now.params.post,
                     n.dias = 5) {
    ## N de dias para projetar: 5 dias a partir da data atual
    ## Adiciona ao forecast dias entre a ultima data de nocasting e o dia atual
    days.to.forecast <- as.integer(Sys.Date() - max(time(pred)) + n.dias)
    ## Objeto zoo com n de casos previstos pelo nowcasting concatenados com o n de casos
    ## projetado a partir do nowcasting acumulado com regressão Poisson
    now.proj.zoo <- merge(
        now.mean.c = c(forecast.exponential(pred$estimate.merged.c,
                                            start = length(time(pred)) - 4,
                                            days.forecast = days.to.forecast)$predito,
                       pred$estimate.merged.c),
        
        now.low.c = c(forecast.exponential(pred$lower.merged.c,
                                           start = length(time(pred)) - 4,
                                           days.forecast = days.to.forecast)$predito,
                      pred$lower.merged.c),
        
        now.upp.c = c(forecast.exponential(pred$upper.merged.c,
                                           start = length(time(pred)) - 4,
                                           days.forecast = days.to.forecast)$predito,
                      pred$upper.merged.c)
    )
    ## Adiciona vetor com n de casos notificados e os previstos para os proximos dias pela projecao
    ## Previsto de casos notificados é calculado a partir das ditribuicoes de atrasos do nowcasting
    ## N de dias que foram corrigidos por nowcating
    ndias.now <- nrow(pred.original)
    now.proj.zoo$not.mean <- c(pred$n.casos,
                               estima.not(diff(now.proj.zoo$now.mean.c[(nrow(now.proj.zoo) - ndias.now):nrow(now.proj.zoo)]),
                                          NobBS.params.post = now.params.post,
                                          from = ndias.now - days.to.forecast + 1))
    now.proj.zoo$not.low <- c(pred$n.casos,
                              estima.not(diff(now.proj.zoo$now.low.c[(nrow(now.proj.zoo) - ndias.now):nrow(now.proj.zoo)]),
                                         NobBS.params.post = now.params.post,
                                         from = ndias.now - days.to.forecast + 1))
    now.proj.zoo$not.upp <- c(pred$n.casos,
                              estima.not(diff(now.proj.zoo$now.upp.c[(nrow(now.proj.zoo) - ndias.now):nrow(now.proj.zoo)]),
                                         NobBS.params.post = now.params.post,
                                         from = ndias.now - days.to.forecast + 1))
    ##Calcula n de casos cumulativos
    
    now.proj.zoo$not.mean.c <- cumsum(na.zero(now.proj.zoo$not.mean))
    now.proj.zoo$not.low.c <- cumsum(na.zero(now.proj.zoo$not.low))
    now.proj.zoo$not.upp.c <- cumsum(na.zero(now.proj.zoo$not.upp))
    return(now.proj.zoo)
}

## Função para checar se existem dados de nowcasting para a unidade administrativa
existe.nowcasting <- function(adm = adm, 
                              sigla.adm = sigla.adm, 
                              tipo) { 
    nome.dir <- paste0("../dados/", adm, "_", sigla.adm, "/")
    nowcasting.file <- list.files(path = nome.dir, 
                                  pattern = paste0("nowcasting", ".+", tipo, ".+.csv"))
    length(nowcasting.file) > 0
}

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
    nomes.cum <- c('now.mean.c', 'now.low.c', 'now.upp.c', 
                   'not.mean.c', 'not.low.c', 'not.upp.c')
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
        select(c(starts_with(nomes.cum), "data")) %>%
        mutate(data = as.Date(data))
    lista.plot <- list(diario = df.diario, acumulado = df.cum)
    return(lista.plot)
}

