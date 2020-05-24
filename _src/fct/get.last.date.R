get.last.date <- function(dir) {
  data.base <- list.files(dir) %>%
    # regex para catar data
    stringr::str_extract("(19|20)\\d\\d[_ /.](0[1-9]|1[012])[_ /.](0[1-9]|[12][0-9]|3[01])") %>%
    as.Date(format = "%Y_%m_%d") %>%
    max(na.rm = TRUE) %>%
    format("%Y_%m_%d")
}
