
devtools::load_all("../READ-EDAB-NEesp2") # or install from github

#### for stephanie to run ----
# try downloading scup, striped bass, and summer flounder
# "Scup",
# "Striped bass",
# "Summer flounder",

params <- expand.grid(region = c("north atlantic", "mid-atlantic"),
                      year = 1981:2024,
                      species = "Scup") # replace species name

purrr::map(purrr::list_transpose(list(region = params$region,
                                      year = params$year,
                                      species = params$species)),
           ~try(NEesp2::save_trips(this_species = .x$species,
                                   this_year = .x$year,
                                   this_region = .x$region,
                                   out_folder = here::here("inputs"))))
