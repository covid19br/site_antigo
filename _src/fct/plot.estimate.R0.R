# Funcao para plot do R efetivo
plot.estimate.R0 <- function(df.re){ # df com r efetivo
    plot <- df.re %>%
        mutate(data = as.Date(data)) %>%
        ggplot(aes(x = data, y = Mean.R)) +
        geom_ribbon(aes(ymin = Quantile.0.025.R, ymax = Quantile.0.975.R), fill = "lightgrey") +
        geom_line(size = 1.25, colour = RColorBrewer::brewer.pal(4, "Dark2")[3]) +
        scale_x_date(date_breaks = "1 month", date_labels = "%b", name = "") +
        ylim(min(c(0.8, min(df.re$Quantile.0.025.R))), max(df.re$Quantile.0.975.R)) +
        geom_hline(yintercept = 1, linetype = "dashed", col = "red", size = 1) +
        ylab("Número de reprodução da epidemia") +
        xlab("Data") +
        plot.formatos
    plot
}
