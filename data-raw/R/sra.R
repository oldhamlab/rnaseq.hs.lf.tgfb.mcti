# sra.R
#
# Functions for downloading SRA run info and generating the sample manifest
# consumed by Snakemake.


#' Download SRA run info for a BioProject
#'
#' Queries NCBI via rentrez and saves the result as a CSV.
#' Returns the file path (for use with targets format = "file").
#'
#' @param bioproject Character. BioProject accession (e.g., "PRJNA1011992").
#' @param outfile Character. Path to write the CSV.
#' @return The path to the written CSV file.
download_sra_runinfo <- function(bioproject, outfile) {
  dir.create(dirname(outfile), showWarnings = FALSE, recursive = TRUE)

  ids <- rentrez::entrez_search(db = "sra", term = bioproject, retmax = 500)
  runinfo <- rentrez::entrez_fetch(
    db = "sra",
    id = ids$ids,
    rettype = "runinfo",
    retmode = "text"
  )
  writeLines(runinfo, outfile)
  outfile
}


#' Generate a samples.tsv for Snakemake from the SRA run info CSV
#'
#' Reads the run info, selects relevant columns, and writes a tab-delimited
#' file mapping sample names to SRR accessions.
#'
#' @param runinfo_file Character. Path to the SRA run info CSV.
#' @param outfile Character. Path to write the samples TSV.
#' @return The path to the written TSV file.
make_samples_tsv <- function(runinfo_file, outfile) {
  runinfo <- readr::read_csv(runinfo_file, show_col_types = FALSE)

  samples <- runinfo |>
    dplyr::filter(.data$Run != "") |>
    dplyr::select(
      run = "Run",
      sample_name = "SampleName",
      submission = "Submission",
      avg_length = "avgLength"
    ) |>
    dplyr::mutate(
      experiment = dplyr::if_else(
        .data$submission == "SRA1704114", "mcti", "vb253"
      )
    ) |>
    dplyr::select("sample_name", "run", "experiment")

  dir.create(dirname(outfile), showWarnings = FALSE, recursive = TRUE)
  readr::write_tsv(samples, outfile)
  outfile
}
