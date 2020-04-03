## Ajuste de modelo exponencial à fase de crescimento e seu uso para projetar a curto prazo
source("funcoes.R")

## Executa o ajuste em running windows com a largura indicada
## Retorna o tempo de duplicacao a cada data final de cada running window
tempos.duplicacao <- dt.rw(brasil.d0, window.width = 5)
## Conveniencia: reordena e renomeia as colunas do objeto resultante
tempos.duplicacao <- tempos.duplicacao[,c(1,3,2)]
names(tempos.duplicacao) <- c("estimativa", "ic.inf", "ic.sup")

## Ajusta modelos exponencial aos ultimos cinco dias da série
## e projeta para os próximos 5 dias
exp.5d <- forecast.exponential(brasil[,2],
                               start = length(time(brasil))-4,
                               days.forecast = 5)

# salva tabela de previsões pra 5d
write.zoo(exp.5d, file="../outputs/prev.5d.csv", sep=",")
# salva tabela de tempos de duplicação
write.zoo(tempos.duplicacao, file="../outputs/tempos.duplicacao.csv", sep=",")

# ajuste de R0 usando EpiEstim
res.uncertain.si <- estimate.R0(brasil.raw$novos.casos, day0 = 8, delay = 7)
res.uncertain.si.zoo <- zoo(res.uncertain.si$R, as.Date(brasil.raw$data, "%d-%m-%Y")[res.uncertain.si$R$t_end])
names(res.uncertain.si.zoo) <- gsub("\\(R\\)", ".R", names(res.uncertain.si.zoo))

estados.tempos.duplicacao <- list()
estados.exp.5d <- list()
for (st in names(estados.d0)){
    ## Executa o ajuste em running windows com a largura indicada
    ## Retorna o tempo de duplicacao a cada data final de cada running window
    estados.tempos.duplicacao[[st]] <- dt.rw(estados.d0[[st]], window.width = 5)
    ## Conveniencia: reordena e renomeia as colunas do objeto resultante
    estados.tempos.duplicacao[[st]] <- estados.tempos.duplicacao[[st]][,c(1,3,2)]
    names(estados.tempos.duplicacao[[st]]) <- c("estimativa", "ic.inf", "ic.sup")
    
    ## Ajusta modelos exponencial aos ultimos cinco dias da série
    ## e projeta para os próximos 5 dias
    estados.exp.5d[[st]] <- forecast.exponential(estados[[st]][,2],
                                   start = length(time(estados[[st]]))-4,
                                   days.forecast = 5)
    
    # salva tabela de previsões pra 5d
    write.zoo(estados.exp.5d[[st]],
              file=paste0("../outputs/", st, ".prev.5d.csv"), sep=",")
    # salva tabela de tempos de duplicação
    write.zoo(estados.tempos.duplicacao[[st]],
              file=paste0("../outputs/", st, ".tempos.duplicacao.csv"), sep=",")

    # TODO: Re por estado precisa de um dia de início, que foi feito à mão para
    # o Brasil - escolher diazero com mesmo critério?
}
