#! /usr/bin/env R

# Note: This step is outside the bookdown report because it requires a specific version of openblas, incompatible with DESeq2 analyses.

library(oligo)

# https://kasperdanielhansen.github.io/genbioconductor/html/oligo.html
celfiles <- list.celfiles(
  "inp/UCMS_Array_Surget_2009",
  full = TRUE
)
Surget_2009 <- read.celfiles(celfiles)

sample_metadata <- sub(
  pattern = ".CEL",
  replacement = "",
  x = rownames(pData(Surget_2009))
)
sample_metadata <- strsplit(
  sample_metadata,
  split = "-"
)
if (length(unique(lapply(sample_metadata, length))) != 1) {
  stop("Input metadata is not parsed correctly because all samples do not have the same number of elements")
}
pData(Surget_2009) <- data.frame(
  matrix(
    unlist(sample_metadata),
    byrow = TRUE,
    ncol = length(sample_metadata[[1]]),
    dimnames = list(
      rownames(pData(Surget_2009)),
      c(
        "stress",
        "treatment",
        "tissue",
        "mouse"
      )
    )
  )
)
# pData(Surget_2009) <- data.frame(
#   lapply(
#     sample_metadata,
#     as.factor
#   )
# )

Surget_2009 <- rma(Surget_2009)

#TODO: Add filter from Surget 2009:
# Probesets with average signal intensitybelow 10 in all groups were considered at background level and were removed, leaving 25 859 probesets for analysis.


dir.create(
  "out/r/"
)

saveRDS(
  object = Surget_2009,
  file = "out/r/preprocess_Surget_2009.rds"
)
