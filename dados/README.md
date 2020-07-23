# Metadados das planilhas dos gráficos do site Observatório COVID-19 BR

Descrição das tabelas usadas nos gráficos das seções
[Estados](https://covid19br.github.io/estados.html),
[DRS](https://covid19br.github.io/drs.html) e
[Municípios](https://covid19br.github.io/municipios.html) do site do
Observatório.

## Base de dados utilizada e métodos

Todas as planilhas aqui descritas resultam da análise de **casos
graves** (SRAG) suspeitos e confirmados para COVID-19, obtidos da base
de notificações **SIVEP-Gripe**. A cada atualização da SIVEP que
obtemos novas planilhas são adicionadas. 

Informações sobre os métodos
estatísticos usados estão seção [Informações
Técnicas](https://covid19br.github.io/informacoes.html) do site.

## Diretórios raiz onde estão os dados
* `estado/`: um subdiretório para cada estado do Brasil
* `DRS/`: Delegacias Regionais de Saúde ou divisão equivalente para estados selecionados. Organizado como `[sigla do estado]/[nome da DRS]`
* `municipios/`: municípios selecionados de todo Brasil. Organizado como `[sigla do estado]/[nome do município]`

## Nomes dos arquivos de dados

Ao fim de cada diretório haverá sempre um diretório
`tabelas_nowcasting_para_grafico`, com arquivos .csv separados por
vírgula, separador de decimal ponto. Os últimos A data indica a data
de geração da análise.

Os últimos 10 caracteres do nome de cada arquivo, antes da sua
extensão (".csv") indicam a data da extração da base SIVEP utilizada,
em formato `YYYY_MM_DD`, sendo `YYYY`ano em 4 dígitos, `MM`mês com
dois dígitos e `DD`dia em dois dígitos.

Os arquivos e seus campos estão relacionados a seguir.


## Planilhas com casos e óbitos acumulados até cada dia

* `nowcasting_acumulado_srag_YYYY_MM_DD.csv`: casos de SRAG acumulados
  por data de primeiro sintoma, e projeção para os próximos 5 dias.
 * `nowcasting_acumulado_obitos_srag_YYYY_MM_DD.csv`: óbitos de casos
  de SRAG acumulados por data do óbitos, e projeção para os próximos 5 dias.
 * `nowcasting_acumulado_covid_YYYY_MM_DD.csv`: casos de SRAG
  confirmados para COVID, acumulados por data de primeiro sintoma, e projeção para os
  próximos 5 dias.
 * `nowcasting_acumulado_obitos_covid_YYYY_MM_DD.csv`: óbitos de casos de SRAG
  confirmados para COVID, acumulados por data do óbito, e projeção para o
  próximos 5 dias.

### Colunas destas planilhas:
  * `data` - data do dia do primeiro sintoma (casos) ou do dia do óbito (óbitos), em formato ISO 8601 YYYY-MM-DD.
  * `now.mean.c` - casos acumulados até a data, corrigidos com nowcasting.
  * `now.mean.c.proj` - projeção do número de casos corrigidos para os 5 dias
    seguintes ao final da série.
  * `now.low.c.proj` - intervalo de credibilidade inferior para a projeção dos casos corrigidos.
  * `now.upp.c.proj` - intervalo de credibilidade superior para a projeção dos casos corrigidos.
  * `not.mean.c`- casos notificados acumulado até a data. 
  * `not.mean.c.proj`- projeção do número de casos notificados para os 5 dias
    seguintes ao final da série.
  * `not.mean.c.proj` - intervalo de credibilidade inferior para a projeção dos casos notificados.
  * `not.upp.c.proj` - intervalo de credibilidade superior para a projeção dos casos notificados.

## Planilhas com número de novos casos e óbitos por dia

 * `nowcasting_diario_srag_YYYY_MM_DD.csv`: novos casos de SRAG diarios
  por data do primeiro sintoma, notificados e corrigidos com *nowcasting*.
 * `nowcasting_diario_obitos_srag_YYYY_MM_DD.csv`: óbitos de casos
  de SRAG diarios por data do óbito, notificados e corrigidos com *nowcasting*.
 * `nowcasting_diario_covid_YYYY_MM_DD.csv`: casos de SRAG
  confirmados para COVID, diarios por data do primeiro sintoma, notificados e corrigidos com *nowcasting*.
 * `nowcasting_diario_obitos_covid_YYYY_MM_DD.csv`: óbitos de casos de SRAG
  confirmados para COVID, diarios por data por data do óbito, notificados e corrigidos com *nowcasting*.

### Colunas destas planilhas:
  * `data` - data do dia do primeiro sintoma (casos) ou do dia do
    óbito (óbitos), em formato ISO 8601 YYYY-MM-DD.
  * `n.casos` - número de novos casos notificados
  * `estimate` - número de novos casos corrigidos por
    *nowcasting*. São corrigidos apenas os casos do final da série de
    dados.
  * `estimate.merged` - concatenação do número de casos notificados com
    o número corrigido por nowcasting, para compor a série completa
    com correção ao final.
  * `estimate.merged.smooth` - média móvel de 7 dias da série completa corrigida (coluna anterior).
  * `lower.merged.pred` - intervalo de credibilidade inferior do nowcasting.
  * `upper.merged.pred` - intervalo de credibilidade superior do nowcasting.


## Planilhas com estimativas do R efetivo

 * `r_efetivo_srag_YYYY_MM_DD.csv` : R efetivo por dia dos casos SRAG, calculado da
   série de novos casos diários corrigida por nowcasting (coluna
   `estimate.merged` da planilha (`nowcasting_diario_srag*.csv`).
 * `r_efetivo_covid_YYYY_MM_DD.csv` : R efetivo por dia dos casos SRAG
   confirmados para COVID, calculado da série de novos casos diários
   corrigida por nowcasting (coluna
   `estimate.merged` da planilha (`nowcasting_diario_covid*.csv`).

### Colunas destas planilhas:
  * `"t_start` e `t_end` -  índices numéricos inicial e final da janela de dias
    usada no cálculo do R efetivo (ver detalhes no help da função `epiEstim:estimate_R`).
  * `Mean.R` - estimativa de R (média da distribuição *posteriori*).
  * `Std.R` - desvio-padrão da estimativa de R (dp da distribuição *posteriori*)
  * `Quantile.0.025.R` a `Quantile.0.975.R` - quantis acumulados da distribuição *a posteriori* do R estimado.
  * `Median.R`: mediana da distribuição *a posteriori* do R.
  * `data` - data em formato ISO 8601 YYYY-MM-DD do final da janela de dias usada no cálculo do R (`t_end`).
