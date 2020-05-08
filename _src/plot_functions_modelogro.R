if(!require(plyr)){install.packages("plyr"); library(plyr)}
if(!require(tidyverse)){install.packages("tidyverse"); library(tidyverse)}
if(!require(lubridate)){install.packages("lubridate"); library(lubridate)}
if(!require(ggplot2)){install.packages("ggplot2"); library(ggplot2)}
if(!require(cowplot)){install.packages("cowplot"); library(cowplot)}
if(!require(patchwork)){install.packages("patchwork"); library(patchwork)}
if(!require(svglite)){install.packages("svglite"); library(svglite)}

Sys.setlocale(category = "LC_TIME", locale = "pt_BR.UTF-8")

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
    theme_cowplot() + scale_color_manual(values = c("black", "darkgreen")) +
    scale_x_date(breaks = seq(as.Date("2020-03-08"), today()+7, by = 7), date_labels = "%b %d") +
    #scale_y_continuous(breaks = seq(0, 30000, by = breaks)) +
    #background_grid(major = "xy", color.major = "grey90", size.major = 0.3) + 
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
             label = "Modelo", color = "blue", size = 6, fontface = "bold", 
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
    geom_line(aes(y = estimate), color = "blue", size = 1.5) + 
    geom_point(size=2) +
    theme_cowplot() + scale_color_manual(values = c("black", "darkgreen")) +
    scale_x_date(breaks = seq(as.Date("2020-03-08"), today()+7, by = 7), date_labels = "%b %d") +
    scale_y_continuous(breaks = seq(0, 30000, by = breaks)) +
    background_grid(major = "xy", minor = "y") + 
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

