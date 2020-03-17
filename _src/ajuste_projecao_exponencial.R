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
exp.5d <- forecast.exponential(brasil[,1],
                               start = length(time(brasil))-4,
                               days.forecast = 5)

