# snakemake.R
#
# Function to launch Snakemake from a targets pipeline.
# Uses the full path to the snakemake binary from config.yaml,
# and ensures both the conda env and the base mamba installation
# are on PATH so snakemake can create per-rule environments.


#' Run the Snakemake pipeline and return quant.sf file paths
#'
#' @param samples_file Character. Path to the samples.tsv (creates a
#'   dependency edge in the targets DAG).
#' @param snakefile Character. Path to the Snakefile.
#' @param configfile Character. Path to the Snakemake config.yaml.
#' @param cores Integer. Number of cores for Snakemake job scheduling.
#' @return Character vector of quant.sf file paths (for format = "file").
run_snakemake <- function(samples_file,
                          snakefile = "data-raw/Snakefile",
                          configfile = "data-raw/config.yaml",
                          cores = 16L) {
  config <- yaml::read_yaml(configfile)

  smk <- config$snakemake_bin
  if (is.null(smk) || !file.exists(smk)) {
    stop(
      "snakemake binary not found at: ", smk, "\n",
      "Update 'snakemake_bin' in ", configfile, " with the output of:\n",
      "  mamba activate snakemake && which snakemake",
      call. = FALSE
    )
  }

  # Build PATH with both the snakemake env bin/ and the base
  # mamba bin/ so snakemake can find conda/mamba to create
  # per-rule environments.
  smk_bin_dir <- dirname(smk)

  # Derive base mamba bin from env path:
  #   .../mamba/envs/snakemake/bin -> .../mamba/bin
  mamba_base_bin <- file.path(
    sub("/envs/.*$", "", smk_bin_dir), "bin"
  )

  extra_path <- paste(smk_bin_dir, mamba_base_bin, sep = ":")
  old_path <- Sys.getenv("PATH")
  Sys.setenv(PATH = paste(extra_path, old_path, sep = ":"))
  on.exit(Sys.setenv(PATH = old_path), add = TRUE)

  args <- c(
    "-s", snakefile,
    "--configfile", configfile,
    "--sdm", "conda",
    "-c", cores
  )

  message("Running: ", smk, " ", paste(args, collapse = " "))

  result <- system2(smk, args = args, stdout = TRUE, stderr = TRUE)

  status <- attr(result, "status")
  if (!is.null(status) && status != 0L) {
    stop("Snakemake failed:\n", paste(result, collapse = "\n"), call. = FALSE)
  }

  # Return quant.sf paths so targets can track them
  quant_files <- list.files(
    config$quants_dir,
    pattern = "quant\\.sf$",
    recursive = TRUE,
    full.names = TRUE
  )

  if (length(quant_files) == 0L) {
    stop("No quant.sf files found in ", config$quants_dir, call. = FALSE)
  }

  quant_files
}
