
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rnaseq.hs.lf.tgfb.mcti

<!-- badges: start -->

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19198539.svg)](https://doi.org/10.5281/zenodo.19198539)
<!-- badges: end -->

This package is a repository for human lung fibroblast RNA-seq data
obtained from cells treated with TGFβ in combination with lactate
transport inhibitors. It contains two `SummarizedExperiment` objects:

- **`mcti`** — AZD3965 (MCT1i), VB124 (MCT4i), and dual inhibition
- **`vb253`** — VB253 (MCT4i)

## Installation

You can install this package from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("oldhamlab/rnaseq.hs.lf.tgfb.mcti")
```

## Experiments

### MCT inhibitor screen (`mcti`)

Lung fibroblasts were seeded at a density of 250,000 cells per well in
35 mm dishes. The following day, they were serum starved for 24 h prior
to treatment with TGFβ (2 ng/mL) in combination with MCT1 inhibitor
AZD3965 (100 nM), MCT4 inhibitor VB124 (10 μM), or both inhibitors
combined. DMSO (0.1%) was the vehicle control. Cells were incubated for
48 h prior to harvesting RNA. RNA was purified using the Qiagen RNeasy
kit and sent to BGI Genomics for library preparation and sequencing. The
samples were analyzed using their DNBSEQ platform with 100 bp paired-end
sequencing with greater than 20 M clean reads per sample. All samples
passed quality control and mapping checks.

### VB253 (`vb253`)

In a subsequent experiment, lung fibroblasts were seeded at a density of
250,000 cells per well in 35 mm dishes. The following day, they were
serum starved for 24 h prior to treatment with TGFβ (2 ng/mL) in
combination with MCT4 inhibitor VB253 (10 μM). DMSO (0.1%) was the
vehicle control. Cells were incubated for 48 h prior to harvesting RNA.
RNA was purified using the Qiagen RNeasy kit and sent to Innomics for
library preparation and sequencing. The samples were analyzed using
their DNBSEQ platform with 150 bp paired-end sequencing with greater
than 20 M clean reads per sample. All samples passed quality control and
mapping checks.

## Processing

For both experiments, reads were aligned to transcript sequences from
GENCODE release 47 using `salmon` v1.10.2 and imported into R as
`SummarizedExperiment` objects via `tximeta`. The full processing
pipeline, including read download from SRA, quantification, and
annotation, is documented in the `data-raw` folder of the package
source. Raw sequences are available from the NIH Sequence Read Archive
(SRA) under BioProject
[PRJNA1011992](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA1011992).

## Usage

``` r
library(SummarizedExperiment)

# MCT inhibitor screen
data(mcti)
colData(mcti)
assay(mcti, "counts")[1:5, 1:5]

# VB253 experiment
data(vb253)
colData(vb253)
```
