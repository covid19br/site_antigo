#####################################################################
## 1. Plot diários, acumulados, tempo de duplicação e Re
## 2. Exporta tabelas com números do dia
###################################################################

# testando se existe nowcasting
existe.covid <- existe.nowcasting2(tipo = "covid",
                                   output.dir = data.dir,
                                   data = data)
existe.srag <- existe.nowcasting2(tipo = "srag",
                                  output.dir = data.dir,
                                  data = data)
existe.ob.covid <- existe.nowcasting2(tipo = "obitos_covid",
                                      output.dir = data.dir,
                                      data = data)
existe.ob.srag <- existe.nowcasting2(tipo = "obitos_srag",
                                     output.dir = data.dir,
                                     data = data)
existe.ob.srag.proaim <- existe.nowcasting2(tipo = "obitos_srag_proaim",
                                            output.dir = data.dir,
                                            data = data)

#############
## COVID ####
#############

if (existe.covid) {
    df.covid.diario <- read.csv(paste0(data.dir, "nowcasting_diario_covid_", data, ".csv"))
    df.covid.cum <- read.csv(paste0(data.dir, "nowcasting_acumulado_covid_", data, ".csv"))
    df.td.covid <- read.csv(paste0(data.dir, "tempo_duplicacao_covid_", data, ".csv"))
    df.re.covid <- read.csv(paste0(data.dir, "r_efetivo_covid_", data, ".csv"))
        # PLOTS #### 
    ### diario
    ## N de novos casos observados e por nowcasting
    ## Com linha de média móvel
    plot.nowcast.covid <- plot.nowcast.diario(df.covid.diario)
    
    ### acumulado
    plot.nowcast.cum.covid <- plot.nowcast.acumulado(df.covid.cum)
    
    ### tempo de duplicação
    plot.tempo.dupl.covid <- plot.tempo.dupl(df.td.covid)
    
    ### R efetivo
    plot.estimate.R0.covid <- plot.estimate.R0(df.re.covid)
    
    # TABELAS ####
    ## Tabela que preenche o minimo e o maximo do nowcast, tempo de duplicacao, e r efetivo
    tabelas.web(plot.dir, 
                tipo = "covid",
                df.covid.cum, 
                df.td.covid,
                df.re.covid)
    
} else {
    plot.nowcast.covid <- NULL
    plot.nowcast.cum.covid <- NULL
    plot.estimate.R0.covid <- NULL
    plot.tempo.dupl.covid <- NULL
}

############
## SRAG ####
############

if (existe.srag) {
    df.srag.diario <- read.csv(paste0(data.dir, "nowcasting_diario_srag_", data, ".csv"))
    df.srag.cum <- read.csv(paste0(data.dir, "nowcasting_acumulado_srag_", data, ".csv"))
    df.td.srag <- read.csv(paste0(data.dir, "tempo_duplicacao_srag_", data, ".csv"))
    df.re.srag <- read.csv(paste0(data.dir, "r_efetivo_srag_", data, ".csv"))
    # PLOTS ####
    ### diario
    ## N de novos casos observados e por nowcasting
    ## Com linha de média móvel
    plot.nowcast.srag <- plot.nowcast.diario(df.srag.diario)
    
    ### acumulado
    plot.nowcast.cum.srag <- plot.nowcast.acumulado(df.srag.cum)
    
    ### tempo de duplicação
    # ö fazendo o filtro na mão para todo mundo, mas depois pode sair daqui ja está no repo nowcasting
    # R: ops, não podia, não
    df.td.srag <- df.td.srag %>%
        filter(data > "2020-03-15")
    df.re.srag <- df.re.srag %>%
        filter(data > "2020-03-15")
    
    plot.tempo.dupl.srag <- plot.tempo.dupl(df.td.srag)
    
    ### R efetivo
    plot.estimate.R0.srag <- plot.estimate.R0(df.re.srag)
    
    # TABELAS ####
    tabelas.web(plot.dir, 
                tipo = "srag",
                df.srag.cum, 
                df.td.srag,
                df.re.srag)  
} else {
    plot.nowcast.srag <- NULL
    plot.nowcast.cum.srag <- NULL
    plot.estimate.R0.srag <- NULL
    plot.tempo.dupl.srag <- NULL
}

#####################
## OBITOS COVID ####
#####################

if (existe.ob.covid) {
    df.ob.covid.diario <- read.csv(paste0(data.dir, "nowcasting_diario_obitos_covid_", data, ".csv"))
    df.ob.covid.cum <- read.csv(paste0(data.dir, "nowcasting_acumulado_obitos_covid_", data, ".csv"))
    df.td.ob.covid <- read.csv(paste0(data.dir, "tempo_duplicacao_obitos_covid_", data, ".csv"))
    ### diario
    ## N de novos casos observados e por nowcasting
    ## Com linha de média móvel
    plot.nowcast.ob.covid <- plot.nowcast.diario(df.ob.covid.diario) +
        xlab("Dia") +
        ylab("Número de novos óbitos")
    
    ### acumulado
    plot.nowcast.cum.ob.covid <- plot.nowcast.acumulado(df.ob.covid.cum) +
        xlab("Dia") +
        ylab("Número acumulado de óbitos")
    
    ### tempo de duplicação
    plot.tempo.dupl.ob.covid <- plot.tempo.dupl(df.td.ob.covid)
    
    # TABELAS ####
    tabelas.web(plot.dir, 
                tipo = "obitos_covid",
                df.ob.covid.cum, 
                df.td.ob.covid)  
} else {
    plot.nowcast.ob.covid <- NULL
    plot.nowcast.cum.ob.covid <- NULL
    plot.tempo.dupl.ob.covid <- NULL
}

####################
## OBITOS SRAG ####
####################

if (existe.ob.srag) {
    df.ob.srag.diario <- read.csv(paste0(data.dir, "nowcasting_diario_obitos_srag_", data, ".csv"))
    df.ob.srag.cum <- read.csv(paste0(data.dir, "nowcasting_acumulado_obitos_srag_", data, ".csv"))
    df.td.ob.srag <- read.csv(paste0(data.dir, "tempo_duplicacao_obitos_srag_", data, ".csv"))
    ### diario
    ## N de novos casos observados e por nowcasting
    ## Com linha de média móvel
    plot.nowcast.ob.srag <- plot.nowcast.diario(df.ob.srag.diario) +
        xlab("Dia") +
        ylab("Número de novos óbitos")
    
    ### acumulado
    plot.nowcast.cum.ob.srag <- plot.nowcast.acumulado(df.ob.srag.cum) +
        xlab("Dia") +
        ylab("Número acumulado de óbitos")
    
    ### tempo de duplicação
    plot.tempo.dupl.ob.srag <- plot.tempo.dupl(df.td.ob.srag)
    # TABELAS ####
    tabelas.web(plot.dir, 
                tipo = "obitos_srag",
                df.ob.srag.cum, 
                df.td.ob.srag)  
} else {
    plot.nowcast.ob.srag <- NULL
    plot.nowcast.cum.ob.srag <- NULL
    plot.tempo.dupl.ob.srag <- NULL
}

#########################
# OBITOS SRAG PROAIM ####
#########################

if (existe.ob.srag.proaim) {
    df.ob.srag.diario.proaim <- read.csv(paste0(data.dir, "nowcasting_diario_obitos_srag_proaim_", 
                                                data, ".csv"))
    df.ob.srag.cum.proaim <- read.csv(paste0(data.dir, "nowcasting_acumulado_obitos_srag_proaim_", 
                                             data, ".csv"))
    df.td.ob.srag.proaim <- read.csv(paste0(data.dir, "tempo_duplicacao_obitos_srag_proaim_", data, ".csv"))
    ### diario
    ## N de novos casos observados e por nowcasting
    ## Com linha de média móvel
    plot.nowcast.ob.srag.proaim <- plot.nowcast.diario(df.ob.srag.diario.proaim) +
        xlab("Dia") +
        ylab("Número de novos óbitos")
    
    ### acumulado
    plot.nowcast.cum.ob.srag.proaim <- plot.nowcast.acumulado(df.ob.srag.cum.proaim) +
        xlab("Dia") +
        ylab("Número acumulado de óbitos")
    
    ### tempo de duplicação
    plot.tempo.dupl.ob.srag.proaim <- plot.tempo.dupl(df.td.ob.srag.proaim)
    # TABELAS ####
    tabelas.web(plot.dir, 
                tipo = "obitos_srag_proaim",
                df.ob.srag.cum.proaim, 
                df.td.ob.srag.proaim)  
} else {
    plot.nowcast.ob.srag.proaim <- NULL
    plot.nowcast.cum.ob.srag.proaim <- NULL
    plot.tempo.dupl.ob.srag.proaim <- NULL
}
