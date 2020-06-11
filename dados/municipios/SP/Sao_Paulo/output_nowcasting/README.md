# Estrutura de nomes de arquivos 

As estimativas de casos corrigidas por *nowcasting* estão nos arquivos `nowcasting_*.csv` 
Os dados observados (não corrigidos) por data de sintoma estão nos arquivos `n_casos_data_sintoma_*.csv`
Os dados observados (não corrigidos) por data de notificação estão em `notificações_*_data.csv`

Os tipos possíveis (`*`) são: covid, srag, obitos_covid e obitos_srag

Data é a data do dia mais recente para o qual há dados, 

ex. 
+ nowcasting_srag_2020_05_07.csv
+ nowcasting_covid_2020_05_07.csv
+ notificacoes_srag_2020_05_07.csv 
+ notificacoes_covid_2020_05_07.csv
+ n_casos_data_sintoma_srag_2020_05_07.csv
+ n_casos_data_sintoma_covid_2020_05_07.csv

## Conteúdo das tabelas de nowcasting
Os arquivos `nowcasting_*` sempre têm as colunas:

  "estimate","lower","upper","onset_date","n.reported"

`onset_date` é a data do caso - usando a data de **primeiro sintoma** para casos, e **de óbito** para óbitos, `estimate` contém a estimativa de casos por *nowcasting* para essa data, `lower` e `upper` têm o mínimo e o máximo das estimativas de casos por *nowcasting* (intervalo de confiança de 95%), e *n.reported* contém o número de casos reportados naquele dia (de novo, por data de sintoma). Esta última coluna é redundante com o arquivo `n_casos_data_sintoma_*`, mas este último é mais completo, porque tem os dados de toda a série, no arquivo de nowcasting tem apenas a parte final, que foi corrigida.

