source("funcoes.R")
## Executa o ajuste em running windows com a largura indicada
tempos.duplicacao <- dt.rw(brasil.d0, window.width = 5)
## Conveniencia: reordena e renomeia as colunas do objeto resultante
tempos.duplicacao <- tempos.duplicacao[,c(1,3,2)]
names(tempos.duplicacao) <- c("estimativa", "ic.low", "ic.up")
