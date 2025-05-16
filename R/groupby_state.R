groupby_state  <- function(data, groupby) {
  if(groupby) {
    data <- data |>
      dplyr::group_by(.data$YEAR, .data$STATE)}
  else {
    data <- data |>
      dplyr::group_by(.data$YEAR)
  }

  return(data)
}
