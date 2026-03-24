# _targets.R

# setup -------------------------------------------------------------------

# pipeline packages
suppressPackageStartupMessages({
  library(targets)
})

# targets options
tar_option_set(
  packages = c(
    "org.Hs.eg.db"
  ),
  format = "qs"
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
  tar_target(
    mcti,
    build_coldata_mcti(quant_files, samples_file) |>
      import_tximeta() |>
      add_mapping_rates(quant_files)
  ),
  tar_target(
    vb253,
    build_coldata_vb253(quant_files, samples_file) |>
      import_tximeta() |>
      add_mapping_rates(quant_files)
  ),
  tar_target(
    export_mcti,
    {
      usethis::use_data(mcti, overwrite = TRUE, compress = "xz", version = 3)
      "data/mcti.rda"
    },
    format = "file"
  ),
  tar_target(
    export_vb253,
    {
      usethis::use_data(vb253, overwrite = TRUE, compress = "xz", version = 3)
      "data/vb253.rda"
    },
    format = "file"
  )
)

