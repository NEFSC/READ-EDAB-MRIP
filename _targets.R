# Created by use_targets().

# Load required packages
library(targets)
library(tarchetypes)
library(here)
library(janitor)
library(testthat)
# remotes::install_github("NEFSC/READ-EDAB-NEesp2")


# Source function scripts
source(here::here("R/create_rec_trips.R"))
source(here::here("R/create_total_rec_landings.R"))

# Define the target pipeline
list(

  #### species data for mapping
  targets::tar_target(species,
                      "Black sea bass"),

   #### Read in data
  tar_target(
    mrip_trips,
    list.files(
      path = here("inputs/mrip_directed_trips"),
      pattern = glob2rx("mrip*.csv"),
      full.names = TRUE
    ),
    format = "file"
  ),
  tar_target(
    mrip_landing,
    here("inputs/mrip_BLACK_SEA_BASS_harvest_update040325.csv"),
    format = "file"
  ),

  #### Calculate time series
  tar_target(
    rec_trips,
    create_rec_trips(files = mrip_trips)
  ),
  tar_target(
    total_rec_landings,
    create_total_rec_landings(
      mrip_landing |>
        read.csv(
          skip = 46,
          na.strings = "."
        ) |>
        clean_names(case = "all_caps")
    )
  ),

  #### Run tests
  # tar_target(
  #   test_rec_trips,
  #   testthat::test_dir("tests/testthat", filter = "rec_trips"),
  #   cue = tar_cue(mode = "always") # Always rerun tests for fresh results
  # ),
  tar_target(
    test_total_rec_landings,
    testthat::test_dir("tests/testthat", filter = "total_rec_landings"),
    cue = tar_cue(mode = "always")
  ),

  #### Save results
  tar_target(
    save_rec_trips,
    write.csv(
      rec_trips,
      file = here("outputs", paste0("mrip_trips_", Sys.Date(), ".csv")),
      row.names = FALSE
    )
  ),
  tar_target(
    save_rec_landings,
    write.csv(
      total_rec_landings,
      file = here("outputs", paste0("mrip_landings_", Sys.Date(), ".csv")),
      row.names = FALSE
    )
  )
)

# targets::tar_visnetwork()
# targets::tar_make()
