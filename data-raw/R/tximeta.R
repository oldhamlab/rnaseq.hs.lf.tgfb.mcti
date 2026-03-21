# tximeta.R
#
# Functions for constructing coldata and importing Salmon quantifications
# via tximeta for each experiment.


#' Build coldata for the MCTi experiment
#'
#' Parses sample names like R1CtlDMSO, R2TGFbAZD, etc. into structured
#' experimental metadata.
#'
#' @param quant_files Character vector of quant.sf file paths.
#' @param samples_file Character. Path to samples.tsv.
#' @return A tibble suitable for tximeta::tximeta().
build_coldata_mcti <- function(quant_files, samples_file) {
  samples <- readr::read_tsv(samples_file, show_col_types = FALSE)
  mcti_names <- samples$sample_name[samples$experiment == "mcti"]

  tibble::tibble(
    files = quant_files[basename(dirname(quant_files)) %in% mcti_names],
    names = basename(dirname(.data$files))
  ) |>
    dplyr::mutate(
      replicate = factor(stringr::str_extract(.data$names, "(?<=^R)\\d")),
      condition = factor(
        dplyr::if_else(
          stringr::str_detect(.data$names, "Ctl"), "CTL", "TGF\u03b2"
        ),
        levels = c("CTL", "TGF\u03b2")
      ),
      treatment = stringr::str_extract(.data$names, "(AZD|DMSO|VB|Dual)$"),
      treatment = factor(
        .data$treatment,
        levels = c("DMSO", "AZD", "VB", "Dual"),
        labels = c("VEH", "AZD", "VB", "AZD/VB")
      )
    )
}


#' Build coldata for the VB253 experiment
#'
#' Parses sample names like Con1, TGFb10, T_VB253_20, VB253_13 into
#' structured experimental metadata.
#'
#' @param quant_files Character vector of quant.sf file paths.
#' @param samples_file Character. Path to samples.tsv.
#' @return A tibble suitable for tximeta::tximeta().
build_coldata_vb253 <- function(quant_files, samples_file) {
  samples <- readr::read_tsv(samples_file, show_col_types = FALSE)
  vb253_names <- samples$sample_name[samples$experiment == "vb253"]

  tibble::tibble(
    files = quant_files[basename(dirname(quant_files)) %in% vb253_names],
    names = basename(dirname(.data$files))
  ) |>
    dplyr::mutate(
      condition = factor(
        dplyr::if_else(
          stringr::str_detect(.data$names, "(^Con|^VB253)"), "CTL", "TGF\u03b2"
        ),
        levels = c("CTL", "TGF\u03b2")
      ),
      treatment = factor(
        dplyr::if_else(
          stringr::str_detect(.data$names, "VB"), "VB253", "VEH"
        ),
        levels = c("VEH", "VB253")
      ),
      replicate = stringr::str_extract(.data$names, "\\d+$")
    )
}


#' Import Salmon quantifications with tximeta
#'
#' Runs tximeta, summarizes to gene level, and adds ENTREZID and SYMBOL
#' annotations. Column names in rowData are lowercased.
#'
#' @param coldata A tibble with at least `files` and `names` columns.
#' @return A SummarizedExperiment object.
import_tximeta <- function(coldata) {
  se <- tximeta::tximeta(coldata) |>
    tximeta::summarizeToGene()

  # Map ENSEMBL gene IDs to ENTREZID and SYMBOL via org.Hs.eg.db
  # (avoids dependency on EnsDb packages that tximeta::addIds expects)
  rd <- SummarizedExperiment::rowData(se)
  ensembl_ids <- sub("\\.\\d+$", "", rownames(se))

  rd$entrezid <- AnnotationDbi::mapIds(
    org.Hs.eg.db::org.Hs.eg.db,
    keys = ensembl_ids,
    keytype = "ENSEMBL",
    column = "ENTREZID",
    multiVals = "first"
  )

  rd$symbol <- AnnotationDbi::mapIds(
    org.Hs.eg.db::org.Hs.eg.db,
    keys = ensembl_ids,
    keytype = "ENSEMBL",
    column = "SYMBOL",
    multiVals = "first"
  )

  names(rd) <- tolower(names(rd))
  SummarizedExperiment::rowData(se) <- rd

  se
}
