# helpers.R

do_test <- function() 1 + 1

fetch_sra_runinfo <- function(bioproject, out_file) {
  fs::dir_create(fs::path_dir(out_file))

  cmd <-
    paste(
      "esearch -db sra -query", shQuote(bioproject),
      "| efetch -format runinfo >", shQuote(out_file)
    )

  processx::run(
    command = "bash",
    args = c("-lc", cmd),
    echo = TRUE,
    error_on_status = TRUE
  )

  normalizePath(out_file, mustWork = TRUE)
}
