# vb253.R

#' VB253 RNA-seq Data
#'
#' RNA was harvested from lung fibroblasts serum starved for 24 h prior to
#' treatment with TGFβ (2 ng/mL) in combination with MCT4 inhibitor VB253 (10
#' μM). DMSO (0.1%) was the vehicle (VEH) control. After 48 h of treatment, RNA
#' was extracted using the Qiagen RNeasy kit and submitted for sequencing by
#' Innomics. The samples were analyzed using their DNBSEQ platform with 150 bp
#' paired-end sequencing with greater than 20 M clean reads per sample. All
#' samples passed quality control and mapping checks. Reads were aligned to
#' transcript sequences from GENCODE release 47 using `salmon`. Processing
#' details are outlined in the `data-raw` folder of the package source. The
#' cleaned sequences are available from the NIH short read archive (SRA) as
#' project number PRJNA1011992.
#'
#' Phenotype data can be accessed with `colData(vb253)`:
#'
#'  \describe{
#'   \item{names}{sample id}
#'   \item{condition}{
#'       `CTL` = Control\cr
#'       `TGFβ` = TGFβ 2 ng/mL for 48 h}
#'   \item{treatment}{
#'       `VEH` = DMSO 0.1% \cr
#'       `VB253` = VB253 10 μM}
#'   \item{replicate}{biological replicate}
#'  }
#'
#' Gene annotation information can be accessed with `rowData(vb253)`.
#'
"vb253"
