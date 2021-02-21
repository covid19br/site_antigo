# Funcao para fazer o plot de nowcasting acumulado, com valores estimados e notificados, com projecao para os proximos 5 dias
plot.nowcast.acumulado <- function(df){
    plot <- df %>%
        mutate(data = as.Date(data)) %>%
        ggplot(aes(x = data)) +
        # ic
        geom_ribbon(aes(ymin = now.low.c.proj, ymax = now.upp.c.proj), fill = "lightgrey") +
        # ic
        geom_ribbon(aes(ymin = not.low.c.proj, ymax = not.upp.c.proj), fill = "lightgrey") +
        # linha e ponto
        geom_line(aes(y = now.mean.c, color = "Estimados"), size = 1) +
        #geom_point(aes(y = now.mean.c, color = "Estimados"), size = 1) +
        # linha e ponto projecao
        geom_line(aes(y = now.mean.c.proj, color = "Estimados"), lty = "longdash") +
        #geom_point(aes(y = now.mean.c.proj, color = "Estimados")) +
        # linha e ponto
        geom_line(aes(y = not.mean.c, color = "Notificados"), size = 1) +
        #geom_point(aes(y = not.mean.c, color = "Notificados"), size = 1) +
        # linha e ponto projecao
        geom_line(aes(y = not.mean.c.proj, color = "Notificados"), lty = "longdash") +
        #geom_point(aes(y = not.mean.c.proj, color = "Notificados"), size = 1) +
        scale_x_date(date_breaks = "1 month", date_labels = "%b") +
        plot.formatos +
        scale_color_discrete(name = "") +
        scale_color_manual(name = "", values = RColorBrewer::brewer.pal(3, "Set1")[1:2]) +
        xlab("Data do primeiro sintoma") +
        ylab("Número acumulado de casos") +
        theme(legend.position = "none") +
        scale_y_log10()
    plot
}
