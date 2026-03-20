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
  # controller = crew::crew_controller_local(workers = 4, seconds_idle = 60),
  # error = "continue"
)

# source functions
tar_source("data-raw/R")


# targets -----------------------------------------------------------------

list(
  tar_target(
    sra_manifest,
    download_sra_runinfo("PRJNA1011992", "data-raw/sra/sample-manifest.csv"),
    format = "file"
  ),
  tar_target(
    samples_file,
    make_samples_tsv(sra_manifest, "data-raw/sra/samples.tsv"),
    format = "file"
  ),
  tar_target(
    quant_files,
    run_snakemake(samples_file),
    format = "file"
  ),
  NULL
)

