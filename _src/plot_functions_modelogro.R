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
    geom_ribbon(fill="black", data = fits$lower$pred[mask,],
                aes(x = date, y = fits$estimate$pred$mean[mask],
                    ymin = fits$lower$pred[mask, "X20."],
                    ymax = fits$upper$pred[mask, "X80."]), alpha=0.15,
                color = "transparent") +
    geom_ribbon(fill="#E41A1C",
                aes(ymin=lower, ymax=upper), alpha=0.15,
                color = "transparent") +
    geom_line(aes(y = estimate), size = 1, color = "#E41A1C") +
    geom_point(data = latest_data, size = 0.7, color = "#377EB8") +
    geom_line(data = latest_data, color = "#377EB8") +
    geom_line(data = fits$lower$pred, aes(y = X20.), colour = "black", linetype= "dotted") +
    geom_line(data = fits$upper$pred, aes(y = X80.), colour = "black", linetype= "dotted") +
    geom_line(data = fits$estimate$pred, aes(y = mean), colour = "black") +
    theme_cowplot() +
    scale_x_date(breaks = seq(as.Date("2020-03-08"), today()+7, by = 15), date_labels = "%b %d") +
    scale_y_continuous(labels = label_number_si()) +
    #background_grid(major = "xy", color.major = "grey90", size.major = 0.3) +
    annotate("text",
             x = min(data$date) + (0.5 * diff(range(data$date))),
             y = max(fits$upper$pred[fits$estimate$pred$date == (last_date+5), "X80."],
                     data[data$date == (last_date),"upper"],
                     data[data$date == (last_date),"observed"]) * 1.1,
             label = "Correção\natraso", color = "#E41A1C", size = 4, fontface = "bold",
             vjust = "top") +
    annotate("text", x = min(data$date) + (0.75 * diff(range(data$date))),
             y = max(fits$upper$pred[fits$estimate$pred$date == (last_date+5), "X80."],
                     data[data$date == (last_date),"upper"],
                     data[data$date == (last_date),"observed"]) * 1.1,
             label = "Modelo", color = "black", size = 4, fontface = "bold",
             vjust = "top") +
    annotate("text", x = min(data$date) + (0.25 * diff(range(data$date))),
             y = max(fits$upper$pred[fits$estimate$pred$date == (last_date+5), "X80."],
                     data[data$date == (last_date),"upper"],
                     data[data$date == (last_date),"observed"]) * 1.1,
             label = "Observado", color = "#377EB8", size = 4, fontface = "bold",
             vjust = "top") +
    theme(legend.position = "none") +
    labs(x = "Data", y = ylabel) +
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

make_ggplot_no_model = function(data, latest_data = NULL, disease ="covid", ylabel = "Hospitalizados",
                       title = "Previsões", breaks = 1000){
  last_date = last(filter(data, type == disease)$date)
  plot = ggplot(filter(data, type == disease), aes(date, observed)) +
    geom_ribbon(fill="#E41A1C",
                aes(ymin=lower, ymax=upper), alpha=0.15,
                color = "transparent") +
    geom_line(aes(y = estimate), size = 1, color = "#E41A1C") +
    geom_point(data = latest_data, size = 0.7, color = "#377EB8") +
    geom_line(data = latest_data, color = "#377EB8") +
    theme_cowplot() +
    scale_x_date(breaks = seq(as.Date("2020-03-08"), today()+7, by = 15), date_labels = "%b %d") +
    scale_y_continuous(labels = label_number_si()) +
    #background_grid(major = "xy", color.major = "grey90", size.major = 0.3) +
    annotate("text",
             x = min(data$date) + (0.5 * diff(range(data$date))),
             y = max(data[data$date == (last_date),"upper"],
                     data[data$date == (last_date),"observed"]) * 1.1,
             label = "Correção\natraso", color = "#E41A1C", size = 4, fontface = "bold",
             vjust = "top") +
    annotate("text", x = min(data$date) + (0.25 * diff(range(data$date))),
             y = max(data[data$date == (last_date),"upper"],
                     data[data$date == (last_date),"observed"]) * 1.1,
             label = "Observado", color = "#377EB8", size = 4, fontface = "bold",
             vjust = "top") +
    theme(legend.position = "none") +
    labs(x = "Data", y = ylabel) +
    ggtitle(title)
  list(current = plot)
}

