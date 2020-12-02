# Funcao para fazer plot nowcast de casos diarios (notificado e nowcasting), com linha de tendencia atenuada e IC
plot.nowcast.diario <- function(df) {
    plot <- df %>%
        mutate(data = as.Date(data)) %>%
        ggplot(aes(x = data)) +
        geom_ribbon(aes(ymin = lower.merged.pred, ymax = upper.merged.pred),
                    fill = RColorBrewer::brewer.pal(3, "Set1")[2], alpha = 0.1) +
        geom_line(aes(y = estimate.merged), lty = 2, col = "grey") +
        geom_point(aes(y = n.casos, col = "Notificado"), size = 2) +
        geom_point(aes(y = estimate, col = "Nowcasting"), size = 2) +
        geom_line(aes(y = estimate.merged.smooth), alpha = 0.6, size = 2) +
        scale_x_date(date_breaks = "1 month", date_labels = "%b") +
        scale_color_manual(name = "", values = RColorBrewer::brewer.pal(3, "Set1")[2:1]) +
        xlab("Dia do primeiro sintoma") +
        ylab("Número de novos casos") +
        plot.formatos +
        theme(legend.position = "none")
    plot
}
