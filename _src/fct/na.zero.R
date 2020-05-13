#' substitui NAS por zeros
na.zero <- function(x)
    ifelse(is.na(x), 0, x)
