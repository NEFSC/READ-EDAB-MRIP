# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
# library(tarchetypes) # Load other packages as needed.

# remotes::install_github("NEFSC/READ-EDAB-NEesp2")

# Run the R scripts in the R/ folder with your custom functions:
# tar_source()
# tar_source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
list(
  #### species data for mapping
  targets::tar_target(species,
                      "Black sea bass"),

  #### TODO: reformat this to work with function updates
  #### TODO: add code to download recent year data




  #### read in data
  targets::tar_target(mrip_trips,
                      # list.files(
                      #   path = here::here("inputs/mrip_directed_trips"),
                      #   pattern = glob2rx("mrip*.csv"),
                      #   full.names = TRUE
                      # ),
                      purrr::map(list.dirs(path = here::here("inputs"),
                                           recursive = FALSE),
                                 ~list.files(.x,
                                             pattern =  "[0-9].Rds",
                                             full.names = TRUE,
                                             recursive = TRUE,
                                             include.dirs = TRUE)),
                      format = "file"
  ),
  targets::tar_target(mrip_landing,
                      list.files(
                        path = here::here("inputs"),
                        pattern = glob2rx("catch_all_*.Rds"),
                        full.names = TRUE
                      ),
                      format = "file"
  ),
  targets::tar_target(mrip_catch,
                      list.files(
                        path = here::here("inputs"),
                        pattern = glob2rx("catch_landings_*.Rds"),
                        full.names = TRUE
                      ),
                      format = "file"
  ),

  #### calculate time series
  targets::tar_target(
    rec_trips,
    NEesp2::create_rec_trips(files = mrip_trips)
  ),
  targets::tar_target(
    total_rec_landings,
    NEesp2::create_total_rec_landings(mrip_landing |>
                                        read.csv(
                                          skip = 46, # of rows you want to ignore
                                          na.strings = "."
                                        ) |>
                                        janitor::clean_names(case = "all_caps"))
  ),

  #### save data
  targets::tar_target(
    save_rec_trips,
    write.csv(rec_trips,
              file = here::here("outputs", paste0("mrip_trips_", Sys.Date(), ".csv")))
  ),
  targets::tar_target(
    save_rec_landings,
    write.csv(total_rec_landings,
              file = here::here("outputs", paste0("mrip_landings_", Sys.Date(), ".csv")))
  )
)

# targets::tar_visnetwork()
# targets::tar_make()
