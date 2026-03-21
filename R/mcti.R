# mcti.R

#' MCTi RNA-seq Data
#'
#' RNA was harvested from lung fibroblasts serum starved for 24 h prior to
#' treatment with TGFβ (2 ng/mL) in combination with MCT1 inhibitor AZD3965
#' (100 nM), MCT4 inhibitor VB124 (10 μM), or both. DMSO (0.1%) was the vehicle
#' (VEH) control. After 48 h of treatment, RNA was extracted using the Qiagen
#' RNeasy kit and submitted for sequencing by BGI Genomics. The samples were
#' analyzed using their DNBSEQ platform with 100 bp paired-end sequencing with
#' greater than 20 M clean reads per sample. All samples passed quality control
#' and mapping checks. Reads were aligned to transcript sequences from GENCODE
#' release 47 using `salmon`. Processing details are outlined in the `data-raw`
#' folder of the package source. The cleaned sequences are available from the
#' NIH short read archive (SRA) as project number PRJNA1011992.
#'
#' Phenotype data can be accessed with `colData(mcti)`:
#'
#'  \describe{
#'   \item{names}{sample id}
#'   \item{replicate}{biological replicate}
#'   \item{condition}{
#'       `CTL` = Control\cr
#'       `TGFβ` = TGFβ 2 ng/mL for 48 h}
#'   \item{treatment}{
#'       `VEH` = DMSO 0.1% \cr
#'       `AZD` = AZD3965 100 nM \cr
#'       `VB` = VB124 10 μM \cr
#'       `AZD/VB` = Both inhibitors together}
#'  }
#'
#' Gene annotation information can be accessed with `rowData(mcti)`.
#'
"mcti"
