source(here::here("R/groupby_state.R"))

create_total_rec_landings <- function(data,
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
                                      return = TRUE){
  total_rec_landings <- data |>
    dplyr::rename(lbs_ab1 = HARVEST_A_B1_TOTAL_WEIGHT_LB)  |>
    dplyr::filter(STATE %in% states)  |>
    groupby_state(groupby = groupby_state) |>
    dplyr::summarise(DATA_VALUE = sum(lbs_ab1, na.rm = TRUE)) |>
    dplyr::mutate(CATEGORY = "Recreational",
                  INDICATOR_TYPE = "Socioeconomic",
                  INDICATOR_NAME = "total_recreational_landings_lbs",
                  INDICATOR_UNITS = "lbs") |>
    # dplyr::rename(YEAR = Year,
    #               STATE = State)  |>  #remove STATE = State here if want all states summed
    dplyr::ungroup()  |>
    dplyr::mutate(YEAR = as.numeric(YEAR))

  if(return) return(total_rec_landings)
}
