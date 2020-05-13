# funcao para converter zoo em df
## srm não se dá bem com zoo e write.zoo
zoo2df <- function(zoo) {
  df <- as.data.frame(zoo)
  df$data <- as.Date(row.names(df))
  return(df)
}