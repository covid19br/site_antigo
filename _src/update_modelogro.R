if(!require(plyr)){install.packages("plyr"); library(plyr)}
if(!require(tidyverse)){install.packages("tidyverse"); library(tidyverse)}
if(!require(lubridate)){install.packages("lubridate"); library(lubridate)}
if(!require(ggplot2)){install.packages("ggplot2"); library(ggplot2)}
if(!require(cowplot)){install.packages("cowplot"); library(cowplot)}
if(!require(patchwork)){install.packages("patchwork"); library(patchwork)}
if(!require(svglite)){install.packages("svglite"); library(svglite)}

Sys.setlocale(category = "LC_TIME", locale = "pt_BR.UTF-8")

pdf(NULL)
print_validation_plots = FALSE
format = "png"

PRJROOT =  rprojroot::find_root(criterion=rprojroot::is_git_root)  

O = function(...) file.path(PRJROOT, "/dados/municipio_SP/projecao_leitos", ...)
R = function(...) file.path(PRJROOT, "/outputs/municipio_SP/projecao_leitos/relatorios", ...)
P = function(...) file.path(PRJROOT, ...)

PLOTPATH = function(...) file.path(PRJROOT, "outputs/municipio_SP/projecao_leitos/figuras", ...)

source(P("_src/plot_functions_modelogro.R"))

hospitalized_files = sort(grep("hopitalized_2020", dir(O("hospitalizados"), full.names = TRUE), value = TRUE))
UTI_files          = sort(grep("hopitalized_UTI_2020", dir(O("hospitalizados"), full.names = TRUE), value = TRUE))

### Set if looking for specific date
#data_date = as.Date("2020-05-02")
data_date = NULL

if(is.null(data_date)){
  #stop("Target validation date not set.")
  current_hosp_table = last(hospitalized_files)
  current_UTI_table = last(UTI_files)
  data_date = as.Date(gsub(".csv", "", gsub("hopitalized_", "", last(strsplit(current_hosp_table, "/")[[1]]))), format = "%Y-%m-%d")
} else{
  current_hosp_table = grep(as.character(data_date), hospitalized_files, value = TRUE)
  current_UTI_table = grep(as.character(data_date), UTI_files, value = TRUE)
}

#######################
# reading vintage and current data
#######################

{
  hospital_data = read.csv(current_hosp_table)
  hospital_data$date = as.Date(hospital_data$date)
  
  latest_hosp_table = last(hospitalized_files)
  latest_UTI_table = last(UTI_files)
  latest_date = as.Date(gsub(".csv", "", gsub("hopitalized_", "", last(strsplit(latest_hosp_table, "/")[[1]]))), format = "%Y-%m-%d")
  
  latest_hospital_data = read.csv(latest_hosp_table)
  latest_hospital_data$date = as.Date(latest_hospital_data$date)
  
  UTI_data = read.csv(current_UTI_table)
  UTI_data$date = as.Date(UTI_data$date)
  
  latest_UTI_data = read.csv(latest_UTI_table)
  latest_UTI_data$date = as.Date(latest_UTI_data$date)
  
  FITSPATH =  paste0(O("curve_fits"), "/curve_fits_", data_date,".Rds")
  current_fits = readRDS(FITSPATH)
  
  covid = hospital_data %>% filter(type == "covid")
  latest_covid = latest_hospital_data %>% filter(type == "covid")
  
  covid_UTI = UTI_data %>% filter(type == "covid")
  latest_covid_UTI = latest_UTI_data %>% filter(type == "covid")
  
  srag = hospital_data %>% filter(type == "srag")
  latest_srag = latest_hospital_data %>% filter(type == "srag")
  
  srag_UTI = UTI_data %>% filter(type == "srag")
  latest_srag_UTI = latest_UTI_data %>% filter(type == "srag")
}
########################
# Covid
########################

########################
# Hospitalized
########################

{
    pce = make_ggplot(covid, latest_covid, current_fits$covid$Exp, 
                      ylabel = "Número de casos COVID-19 hospitalizados",
                      title = "COVID-19 - Leitos Totais - Exponencial") 
    print(plot_grid(pce$current, pce$validation))
    save_plot(PLOTPATH(paste0("/covid_in_hospital_nowcast_Exponential_predictions_", data_date, ".svg")),
              pce$current, base_height = 6.5, base_asp = 1.7, scale = 0.8)
    if(print_validation_plots)
      save_plot(filename = PLOTPATH(paste0("/covid_in_hospital_nowcast_Exponential_predictions_", data_date, "_validation.", format)),
                pce$validation, base_height = 6.5, base_asp = 1.7, scale = 0.8)
} 

{
    pcl = make_ggplot(covid, latest_covid, current_fits$covid$Logist, 
                      ylabel = "Número de casos COVID-19 hospitalizados",
                      title = "COVID-19 - Leitos Totais - Logistica")  
    print(plot_grid(pcl$current, pcl$validation))
    save_plot(PLOTPATH(paste0("covid_in_hospital_nowcast_Logistic_predictions_", data_date, ".", format)),
              pcl$current, base_height = 6.5, base_asp = 1.7)
    if(print_validation_plots)
      save_plot(PLOTPATH(paste0("covid_in_hospital_nowcast_Logistic_predictions_", data_date, "_validation.", format)),
                pcl$validation, base_height = 6.5, base_asp = 1.7)
}

########################
# UTI
########################


{
    pceU = make_ggplot(covid_UTI, latest_covid_UTI, current_fits$covid$UTIExp, breaks = 500,
                       ylabel = "Número de casos COVID-19 hospitalizados em UTI",
                       title = "COVID-19 - Leitos UTI - Exponencial") 
    print(plot_grid(pceU$current, pceU$validation))
    
    save_plot(PLOTPATH(paste0("covid_in_UTI_nowcast_Exponential_predictions_", data_date, ".", format)),
              pceU$current, base_height = 6.5, base_asp = 1.7)
    if(print_validation_plots)
      save_plot(PLOTPATH(paste0("covid_in_UTI_nowcast_Exponential_predictions_", data_date, "_validation.", format)),
              pceU$validation, base_height = 6.5, base_asp = 1.7)
}

{
    pclU = make_ggplot(covid_UTI, latest_covid_UTI, current_fits$covid$UTILogist, breaks = 500,
                       ylabel = "Número de casos COVID-19 hospitalizados em UTI",
                       title = "COVID-19 - Leitos UTI - Logistico") 
    print(plot_grid(pclU$current, pclU$validation))
    
    save_plot(PLOTPATH(paste0("covid_in_UTI_nowcast_Logistic_predictions_", data_date, ".", format)),
              pclU$current, base_height = 6.5, base_asp = 1.7)
    if(print_validation_plots)
      save_plot(PLOTPATH(paste0("covid_in_UTI_nowcast_Logistic_predictions_", data_date, "_validation.", format)),
                pclU$validation, base_height = 6.5, base_asp = 1.7)
}


########################
# SRAG
########################

#######################
# Hospitalized
########################


{
    pse = make_ggplot(srag, latest_srag, current_fits$srag$Exp, disease = "srag",
                      ylabel = "Número de casos SRAG hospitalizados",
                      title = "SRAG - Leitos totais - Exponencial")
    print(plot_grid(pse$current, pse$validation))
    
    save_plot(filename = PLOTPATH(paste0("srag_in_hospital_nowcast_Exponential_predictions_", data_date, ".", format)),
              pse$current, base_height = 6.5, base_asp = 1.7)
    if(print_validation_plots)
      save_plot(filename = PLOTPATH(paste0("srag_in_hospital_nowcast_Exponential_predictions_", data_date, "_validation.", format)),
                pse$validation, base_height = 6.5, base_asp = 1.7)
}         

{
    psl = make_ggplot(srag, latest_srag, current_fits$srag$Logist, disease = "srag",
                      ylabel = "Número de casos SRAG hospitalizados",
                      title = "SRAG - Leitos totais - Logistico")
    print(plot_grid(psl$current, psl$validation))
    
    save_plot(PLOTPATH(paste0("srag_in_hospital_nowcast_Logistic_predictions_", data_date, ".", format)),
              psl$current, base_height = 6.5, base_asp = 1.7)
    if(print_validation_plots)
      
      save_plot(PLOTPATH(paste0("srag_in_hospital_nowcast_Logistic_predictions_", data_date, "_validation.", format)),
                psl$validation, base_height = 6.5, base_asp = 1.7)
}

########################
# UTI
########################


{
    pseU = make_ggplot(srag_UTI, latest_srag_UTI, current_fits$srag$UTIExp, disease = "srag",
                       ylabel = "Número de casos SRAG hospitalizados em UTI",
                       title = "SRAG - Leitos UTI - Exponencial")
    print(plot_grid(pseU$current, pseU$validation))
    
    save_plot(PLOTPATH(paste0("srag_in_UTI_nowcast_Exponential_predictions_", data_date, ".", format)),
              pseU$current, base_height = 6.5, base_asp = 1.7)
    if(print_validation_plots)
      save_plot(PLOTPATH(paste0("srag_in_UTI_nowcast_Exponential_predictions_", data_date, "_validation.", format)),
                pseU$validation, base_height = 6.5, base_asp = 1.7)
}

{
    pslU = make_ggplot(srag_UTI, latest_srag_UTI, current_fits$srag$UTILogist, disease = "srag",
                       ylabel = "Número de casos SRAG hospitalizados em UTI",
                       title = "SRAG - Leitos UTI - Logistico")
    print(plot_grid(pslU$current, pslU$validation))
    
    save_plot(PLOTPATH(paste0("srag_in_UTI_nowcast_Logistic_predictions_", data_date, ".", format)),
              pslU$current, base_height = 6.5, base_asp = 1.7)
    if(print_validation_plots)
      save_plot(PLOTPATH(paste0("srag_in_UTI_nowcast_Logistic_predictions_", data_date, "_validation.", format)),
                pslU$validation, base_height = 6.5, base_asp = 1.7)
}


# p_srag = make_ggplot_no_model(srag, disease = "srag",  ylabel = "Número de casos SRAG hospitalizados",
#                               title ="SRAG - Leitos totais", breaks = 2000)
# p_srag_uti = make_ggplot_no_model(srag_UTI, disease = "srag",  ylabel = "Número de casos SRAG hospitalizados em UTI",
#                                   title ="SRAG - Leitos UTI")
# ps = plot_grid(p_srag, p_srag_uti, scale = 0.96)
# format = "png"
# save_plot(filename = PLOTPATH(paste0("srag_hospitalizados.", format)), ps, base_asp = 1.2, base_height = 5.5, ncol = 2)

print("Atualizando data de atualizacao...")
file <- file("../web/last.update.modelogro.txt") # coloco o nome do municipio?
writeLines(c(paste(now())), file)
close(file)

# Graficos a serem atualizados
plots.para.atualizar <- makeNamedList(plots.criados)
filenames <- names(plots.para.atualizar)
n <- length(plots.para.atualizar)

for (i in 1:n){
  graph.html <- ggplotly(plots.para.atualizar.municipio[[i]]) %>% layout(margin = list(l = 50, r = 20, b = 20, t = 20, pad = 4))
  graph.svg <- plots.para.atualizar.municipio[[i]] + theme(axis.text = element_text(size=11, family="Arial", face="plain"), # ticks
                                                           axis.title = element_text(size=14, family="Arial", face="plain")) # title
  filepath <- paste(P("web/"),filenames[i],sep="")
  saveWidget(frameableWidget(graph.html), file = paste(filepath,".html",sep=""), libdir="./libs") # HTML Interative Plot
  ggsave(paste(filepath,".svg",sep=""), plot = graph.svg, device = svg, scale= .8, width= 210, height = 142, units = "mm")
}
