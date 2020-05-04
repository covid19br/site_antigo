if(!require(plyr)){install.packages("plyr"); library(plyr)}
if(!require(tidyverse)){install.packages("tidyverse"); library(tidyverse)}
if(!require(lubridate)){install.packages("lubridate"); library(lubridate)}
if(!require(ggplot2)){install.packages("ggplot2"); library(ggplot2)}
if(!require(cowplot)){install.packages("cowplot"); library(cowplot)}
if(!require(patchwork)){install.packages("patchwork"); library(patchwork)}
if(!require(svglite)){install.packages("svglite"); library(svglite)}

Sys.setlocale(category = "LC_TIME", locale = "pt_BR.UTF-8")

pdf(NULL)
print_plots = FALSE
format = "svg"

PRJROOT =  rprojroot::find_root(criterion=rprojroot::is_git_root)  

O = function(...) file.path(PRJROOT, "/dados/municipio_SP/projecao_leitos", ...)
R = function(...) file.path(PRJROOT, "/outputs/municipio_SP/projecao_leitos/relatorios", ...)
P = function(...) file.path(PRJROOT, ...)

PLOTPATH = function(...) file.path(PRJROOT, "outputs/municipio_SP/projecao_leitos/figuras", ...)

make_ggplot = function(data, latest_data = NULL, fits, disease ="covid", ylabel = "Hospitalizados", 
                       title = "Previsões", breaks = 1000){
  last_date = last(filter(data, type == disease)$date)
  mask = fits$estimate$pred$date >= last_date
  plot = ggplot(filter(data, type == disease), aes(date, observed)) + 
    geom_ribbon(fill="blue", data = fits$lower$pred[mask,],
                aes(x = date, y = fits$estimate$pred$mean[mask], 
                    ymin = fits$lower$pred[mask, "X20."], 
                    ymax = fits$upper$pred[mask, "X80."]),alpha=0.15, color = 0) + 
    geom_ribbon(fill="indianred3", 
                aes(ymin=lower, ymax=upper),alpha=0.15, color = 0) +
    geom_point(data = latest_data, size = 1.5, ) + 
    geom_line(data = latest_data) + 
    geom_line(aes(y = estimate), size = 1, color = "indianred3") + 
    geom_line(data = fits$lower$pred, aes(y = X20.), colour = "blue", linetype= "dotted") + 
    geom_line(data = fits$upper$pred, aes(y = X80.), colour = "blue", linetype= "dotted") + 
    geom_line(data = fits$estimate$pred, aes(y = mean), colour = "blue", size = 1) + 
    theme_bw() + scale_color_manual(values = c("black", "darkgreen")) +
    scale_x_date(breaks = seq(as.Date("2020-03-08"), today()+7, by = 7), date_labels = "%b %d") +
    #scale_y_continuous(breaks = seq(0, 30000, by = breaks)) +
    annotate("text", 
             x = min(data$date) + (0.5 * diff(range(data$date))), 
             y = max(fits$upper$pred[fits$estimate$pred$date == (last_date+5), "X80."], 
                     data[data$date == (last_date),"upper"], 
                     data[data$date == (last_date),"observed"]) * 1.1, 
             label = "Correção\natraso", color = "indianred3", size = 6, fontface = "bold", 
             vjust = "top") +
    annotate("text", x = min(data$date) + (0.75 * diff(range(data$date))), 
             y = max(fits$upper$pred[fits$estimate$pred$date == (last_date+5), "X80."], 
                     data[data$date == (last_date),"upper"], 
                     data[data$date == (last_date),"observed"]) * 1.1,
             label = "Projeção", color = "blue", size = 6, fontface = "bold", 
             vjust = "top") +
    annotate("text", x = min(data$date) + (0.25 * diff(range(data$date))), 
             y = max(fits$upper$pred[fits$estimate$pred$date == (last_date+5), "X80."], 
                     data[data$date == (last_date),"upper"], 
                     data[data$date == (last_date),"observed"]) * 1.1,
             label = "Observado", color = "black", size = 6, fontface = "bold", 
             vjust = "top") +
    theme(legend.position = "none") + 
    labs(x = "Dia", y = ylabel) + 
    ggtitle(title)
  if(!is.null(latest_data)){
    latest_last_date = last(filter(latest_data, type == disease)$date)
    plot_validation = plot + geom_ribbon(fill="orange",data = latest_data,
                                         aes(ymin=lower, ymax=upper),alpha=0.1, color = 0) +
      geom_line(data = latest_data, aes(y = estimate), color = "orange", size = 1) +
      annotate("text", x = min(data$date) + (1 * diff(range(data$date))), 
               y = max(fits$upper$pred[fits$estimate$pred$date == (last_date+5), "X80."], 
                       data[data$date == (last_date),"upper"], 
                       data[data$date == (last_date),"observed"]) * 1.1,
               label = "Correção\natual", color = "orange", size = 6, fontface = "bold", 
               vjust = "top")  
    plot_validation
  } else
    plot_validation = NULL
  list(current = plot, validation = plot_validation)
}

make_ggplot_no_model = function(data, disease ="covid", ylabel = "Hospitalizados", 
                       title = "Previsões", breaks = 1000){
  last_date = last(filter(data, type == disease)$date)

  plot = ggplot(filter(data, type == disease), aes(date, observed)) + 
    geom_ribbon(fill="blue", 
                aes(ymin=lower, ymax=upper),alpha=0.15, color = 0) +
    geom_line(aes(y = estimate), color = "blue", size = 1.5) + 
    geom_point(size=2) +
    theme_bw() + scale_color_manual(values = c("black", "darkgreen")) +
    scale_x_date(breaks = seq(as.Date("2020-03-08"), today()+7, by = 7), date_labels = "%b %d") +
    scale_y_continuous(breaks = seq(0, 30000, by = breaks)) +
    annotate("text", x = last_date - 6, 
             y = data[data$date == (last_date-6),"estimate"] * 1.2, 
             label = "Corrigido", color = "blue", size = 4.5) +
    annotate("text", x = last_date-2, 
             y = data[data$date == (last_date-1),"observed"] * 0.83, 
             label = "Observado", color = "black", size = 4.5)  +
    theme(legend.position = "none") + 
    labs(x = "Dia", y = ylabel) + 
    ggtitle(title)
  

  return(plot)
}

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

########################
# Covid
########################

########################
# Hospitalized
########################

covid = hospital_data %>% filter(type == "covid")
latest_covid = latest_hospital_data %>% filter(type == "covid")

{
    pce = make_ggplot(covid, latest_covid, current_fits$covid$Exp, 
                      ylabel = "Número de casos COVID-19 hospitalizados",
                      title = "COVID-19 - Leitos Totais - Exponencial") 
    print(plot_grid(pce$current, pce$validation))
    save_plot(PLOTPATH(paste0("/covid_in_hospital_nowcast_Exponential_predictions_", data_date, ".svg")),
              pce$current, base_height = 6.5, base_asp = 1.7, scale = 0.8)
    if(print_plots)
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
    if(print_plots)
      save_plot(PLOTPATH(paste0("covid_in_hospital_nowcast_Logistic_predictions_", data_date, "_validation.", format)),
                pcl$validation, base_height = 6.5, base_asp = 1.7)
}

########################
# UTI
########################

covid_UTI = UTI_data %>% filter(type == "covid")
latest_covid_UTI = latest_UTI_data %>% filter(type == "covid")

{
    pceU = make_ggplot(covid_UTI, latest_covid_UTI, current_fits$covid$UTIExp, breaks = 500,
                       ylabel = "Número de casos COVID-19 hospitalizados em UTI",
                       title = "COVID-19 - Leitos UTI - Exponencial") 
    print(plot_grid(pceU$current, pceU$validation))
    
    save_plot(PLOTPATH(paste0("covid_in_UTI_nowcast_Exponential_predictions_", data_date, ".", format)),
              pceU$current, base_height = 6.5, base_asp = 1.7)
    if(print_plots)
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
    if(print_plots)
      save_plot(PLOTPATH(paste0("covid_in_UTI_nowcast_Logistic_predictions_", data_date, "_validation.", format)),
                pclU$validation, base_height = 6.5, base_asp = 1.7)
}


########################
# SRAG
########################

#######################
# Hospitalized
########################

srag = hospital_data %>% filter(type == "srag")
latest_srag = latest_hospital_data %>% filter(type == "srag")

{
    pse = make_ggplot(srag, latest_srag, current_fits$srag$Exp, disease = "srag",
                      ylabel = "Número de casos SRAG hospitalizados",
                      title = "SRAG - Leitos totais - Exponencial")
    print(plot_grid(pse$current, pse$validation))
    
    save_plot(filename = PLOTPATH(paste0("srag_in_hospital_nowcast_Exponential_predictions_", data_date, ".", format)),
              pse$current, base_height = 6.5, base_asp = 1.7)
    if(print_plots)
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
    if(print_plots)
      save_plot(PLOTPATH(paste0("srag_in_hospital_nowcast_Logistic_predictions_", data_date, "_validation.", format)),
                psl$validation, base_height = 6.5, base_asp = 1.7)
}

########################
# UTI
########################

srag_UTI = UTI_data %>% filter(type == "srag")
latest_srag_UTI = latest_UTI_data %>% filter(type == "srag")

{
    pseU = make_ggplot(srag_UTI, latest_srag_UTI, current_fits$srag$UTIExp, disease = "srag",
                       ylabel = "Número de casos SRAG hospitalizados em UTI",
                       title = "SRAG - Leitos UTI - Exponencial")
    print(plot_grid(pseU$current, pseU$validation))
    
    save_plot(PLOTPATH(paste0("srag_in_UTI_nowcast_Exponential_predictions_", data_date, ".", format)),
              pseU$current, base_height = 6.5, base_asp = 1.7)
    if(print_plots)
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
    if(print_plots)
      save_plot(PLOTPATH(paste0("srag_in_UTI_nowcast_Logistic_predictions_", data_date, "_validation.", format)),
                pslU$validation, base_height = 6.5, base_asp = 1.7)
}


# p_srag = make_ggplot_no_model(srag, disease = "srag",  ylabel = "Número de casos SRAG hospitalizados",
#                               title ="SRAG - Leitos totais", breaks = 2000)
# p_srag_uti = make_ggplot_no_model(srag_UTI, disease = "srag",  ylabel = "Número de casos SRAG hospitalizados em UTI",
#                                   title ="SRAG - Leitos UTI") 
# ps = plot_grid(p_srag, p_srag_uti, scale = 0.96)
# save_plot(filename = PLOTPATH("srag_hospitalizados.", format), ps, base_asp = 1.2, base_height = 5.5, ncol = 2)

