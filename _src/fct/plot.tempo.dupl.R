# Funcao para calcular o tempo de duplicacao
plot.tempo.dupl <- function(df.td) {#data.frame com tempo de duplicacao
    plot <- df.td %>%
        mutate(data = as.Date(data)) %>% 
        ggplot(aes(x = data, y = estimativa)) +
        geom_ribbon(aes(ymin = ic.inf, ymax = ic.sup), fill = "lightgrey") +
        geom_line(size = 1.25, colour = RColorBrewer::brewer.pal(3, "Dark2")[1]) +
        scale_x_date(date_labels = "%d/%b", name = "") +
        ##coord_cartesian(ylim = c(0, 50)) +
        ylab("Tempo de duplicação (dias)") +
        ylim(0, max(df.td$ic.sup)) +
        plot.formatos 
    plot    
}
