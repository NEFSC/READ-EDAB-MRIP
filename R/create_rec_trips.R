create_rec_trips <- function(files,
                             states = c('MAINE', 'CONNECTICUT', 'MASSACHUSETTS',
                                        'NEW HAMPSHIRE', 'NEW JERSEY', 'NEW YORK',
                                        'RHODE ISLAND', 'MARYLAND', 'DELAWARE',
                                        'NORTH CAROLINA'),
                             group_by_state_fn = groupby_state,
                             group_by_state = FALSE,
                             return = TRUE) {

  # Read and combine all csv files into one data frame
  rec_directed_trips <- purrr::map_df(files, ~ read.csv(.x, skip = 44, na.strings = "."))

  print(names(rec_directed_trips))

  rec_trips <- rec_directed_trips |>
    janitor::clean_names(case = "all_caps") |>
    dplyr::filter(STATE %in% states) |>
    group_by_state_fn(groupby = group_by_state) |>
    dplyr::summarise(DATA_VALUE = sum(DIRECTED_TRIPS, na.rm = TRUE)) |>
    dplyr::mutate(CATEGORY = "Recreational",
                  INDICATOR_TYPE = "Socioeconomic",
                  INDICATOR_NAME = "rec_trips",
                  INDICATOR_UNITS = "n")

  if (return) return(rec_trips)
}


