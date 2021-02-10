library(geofacet)

plot.nowcast.diario.brasil <- function(df) {
    plot <- df %>%
        mutate(data = as.Date(data)) %>%
        ggplot(aes(x = data)) +
        geom_ribbon(aes(ymin = lower.merged.pred, ymax = upper.merged.pred),
                    fill = RColorBrewer::brewer.pal(3, "Set1")[2], alpha = 0.3) +
        geom_line(aes(y = estimate.merged)) +
        #geom_line(aes(y = n.casos, col = "Notificado")) +
        #geom_line(aes(y = estimate, col = "Nowcasting")) +
        facet_geo(~UF, grid = "br_states_grid1", scales = "free_y") +
        scale_x_date(date_breaks = "3 months", date_labels = "%b") +
        #scale_color_manual(name = "", values = RColorBrewer::brewer.pal(3, "Set1")[2:1]) +
        xlab("Data do primeiro sintoma") +
        ylab("Número de novos casos") +
        plot.formatos +
        theme(legend.position = "none")
    plot
}
