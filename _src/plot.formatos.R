if(!require(ggplot2)){install.packages("ggplot2"); library(ggplot2)}
plot.formatos <- theme_bw() +
                 theme(axis.text= element_text(size=10, face="plain"),
                       axis.title = element_text(size=10, face="plain"),
                       legend.text = element_text(size=12),
                       title = element_text(size = 12),
                       plot.margin = margin(0, 0, 0, 0, "pt"),
                       panel.border = element_blank(),
                       panel.grid = element_line(size = 0.25),
                       panel.grid.minor = element_blank(),
                       panel.grid.major.x = element_blank())

################################################################################
## Funcao para calculo do prefixo na label (modificacao de scales lib) 
################################################################################
library(scales)

force_all <- function(...) list(...)

label_number_si <- function(accuracy = 1, unit = NULL, sep = NULL, ...) {
  sep <- if (is.null(unit)) "" else " "
  force_all(accuracy, ...)

  function(x) {
    breaks <- c(0, 10^c(" mil" = 3, " milhão" = 6, B = 9, T = 12))

    n_suffix <- cut(abs(x),
      breaks = c(unname(breaks), Inf),
      labels = c(names(breaks)),
      right = FALSE
    )
    n_suffix[is.na(n_suffix)] <- ""
    suffix <- paste0(sep, n_suffix, unit)

    scale <- 1 / breaks[n_suffix]
    # for handling Inf and 0-1 correctly
    scale[which(scale %in% c(Inf, NA))] <- 1

    number(x,
      accuracy = accuracy,
      scale = unname(scale),
      suffix = suffix,
      ...
    )
  }
}