# _targets.R

# setup -------------------------------------------------------------------

# pipeline packages
suppressPackageStartupMessages({
  library(targets)
})

# targets options
tar_option_set(
  # packages = c(
  #   "SummarizedExperiment",
  #   "extrafont"
  # ),
  format = "qs",
  controller = crew::crew_controller_local(workers = 4, seconds_idle = 60),
  # error = "continue"
)

# source functions
tar_source("data-raw/R")


# targets -----------------------------------------------------------------

list(
  tar_target(
    test,
    do_test()
  )
)

