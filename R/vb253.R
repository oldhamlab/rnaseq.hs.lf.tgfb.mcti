# vb253.R

#' VB253 RNA-seq Data
#'
#' RNA was harvested from lung fibroblasts serum starved for 24 h prior to
#' treatment with TGFβ (2 ng/mL) in combination with MCT4 inhibitor VB253 (10
#' μM). DMSO (0.1%) was the vehicle control. After 48 h of treatment, RNA was
#' extracted using the Qiagen RNeasy kit and submitted for sequencing by
#' Innomics. The samples were analyzed using their DNBSEQ platform with 150 bp
#' paired-end sequencing with greater than 20 M clean reads per sample. All
#' samples passed quality control and mapping checks. Reads were aligned to
#' transcript sequences from GENCODE release 47 using \code{salmon} v1.10.2.
#' Processing details are outlined in the \code{data-raw} folder of the package
#' source. The cleaned sequences are available from the NIH Sequence Read
#' Archive (SRA) as BioProject
#' \href{https://www.ncbi.nlm.nih.gov/bioproject/PRJNA1011992}{PRJNA1011992}.
#'
#' Phenotype data can be accessed with \code{colData(vb253)}:
#'
#'  \describe{
#'   \item{names}{sample id}
#'   \item{condition}{
#'       \code{CTL} = Control\cr
#'       \code{TGFβ} = TGFβ 2 ng/mL for 48 h}
#'   \item{treatment}{
#'       \code{VEH} = DMSO 0.1% \cr
#'       \code{VB253} = VB253 10 μM}
#'   \item{replicate}{biological replicate}
#'   \item{num_processed}{Total fragments processed by Salmon}
#'   \item{num_mapped}{Number of fragments mapped}
#'   \item{num_decoy}{Number of fragments mapped to decoy sequences}
#'   \item{mapping_rate}{Salmon mapping rate (proportion)}
#'   \item{percent_mapped}{Salmon mapping rate (percent)}
#'  }
#'
#' Gene annotation information can be accessed with \code{rowData(vb253)}.
#'
#' @format A \code{\link[SummarizedExperiment]{RangedSummarizedExperiment}}
#'   with 16 samples.
#'
#' @source Innomics; BioProject PRJNA1011992
"vb253"
