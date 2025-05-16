create_rec_trips <- function(files,
                             states = c('MAINE',
                                        'CONNECTICUT',
                                        'MASSACHUSETTS',
                                        'NEW HAMPSHIRE',
                                        'NEW JERSEY',
                                        'NEW YORK',
                                        'RHODE ISLAND',
                                        'MARYLAND',
                                        'DELAWARE',
                                        'NORTH CAROLINA'),
                             groupby_state = FALSE,
                             return = TRUE) {
  rec_directed_trips <- c()
  for (i in files) {
    this_dat <- read.csv(i,
                         skip = 44,# was 24 is now 44
                         na.strings = "."
    )
    # message(unique(this_dat$Year))
    rec_directed_trips <- rbind(rec_directed_trips, this_dat)
  }

  rec_trips <- rec_directed_trips  |>
    janitor::clean_names(case = "all_caps")  |>
    dplyr::filter(STATE %in% states)  |>
    groupby_state(groupby = groupby_state) |>
    dplyr::summarise(DATA_VALUE = sum(DIRECTED_TRIPS, na.rm = TRUE)) |>
    dplyr::mutate(CATEGORY = "Recreational",
                  INDICATOR_TYPE = "Socioeconomic",
                  INDICATOR_NAME = "rec_trips",
                  INDICATOR_UNITS = "n")

  if(return) return(rec_trips)

}
