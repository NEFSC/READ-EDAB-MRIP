
devtools::load_all("../READ-EDAB-NEesp2") # or install from github

species <- c("Atlantic cod",
              "Atlantic mackerel",
              "Black sea bass",
              "Chub mackerel",
              "Haddock",
              "Pollock",
              "Scup",
              "Striped bass",
              "Summer flounder",
              "Winter flounder")

# set up trip download ----
params <- expand.grid(region = c("north atlantic", "mid-atlantic"),
                      year = c(1981:1991, 2020:2024),
                      species = "Winter flounder")

# params <- expand.grid(region = c("mid-atlantic"),
#   year = c(1981, 1982, 1984, 1985, 1990),
#   species = "Chub mackerel")
#
# params <- expand.grid(region = c("north atlantic"),
#   year = c(1986:1988, 1990),
#   species = "Chub mackerel")

purrr::map(purrr::list_transpose(list(region = params$region,
                                      year = params$year,
                                      species = params$species)),
           ~try(NEesp2::save_trips(this_species = .x$species,
                                   this_year = .x$year,
                                   this_region = .x$region,
                                   out_folder = here::here("inputs"))))

NEesp2::save_trips(this_species = "Winter flounder",
                   this_year = 1999,
                   this_region = "north atlantic",
                   out_folder = here::here("inputs"))

#### cod ----

# download broke on cod for reasons I don't understand
params <- expand.grid(region = c("north atlantic", "mid-atlantic"),
                      year = 2003:2024,
                      species = "Atlantic cod")

purrr::map(purrr::list_transpose(list(region = params$region,
                                      year = params$year,
                                      species = params$species)),
            ~try(NEesp2::save_trips(this_species = .x$species,
                        this_year = .x$year,
                        this_region = .x$region,
                        out_folder = here::here("inputs"))))

NEesp2::save_trips(this_species = "Atlantic cod",
                   this_year = 2002,
                   this_region = "mid-atlantic",
                   out_folder = here::here("inputs"))

# save catch ----
purrr::map(species,
           ~NEesp2::save_catch(this_species = .x,
                               catch_type = "all",
                               out_folder = here::here("inputs"),
                               wait = FALSE))

# save landings ----
purrr::map(species,
           ~NEesp2::save_catch(this_species = .x,
                               catch_type = "landings",
                               out_folder = here::here("inputs"),
                               wait = FALSE))
