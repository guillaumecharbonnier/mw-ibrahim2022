#! /usr/bin/env R

# Note: This step is outside the bookdown report because it requires a specific version of openblas, incompatible with DESeq2 analyses.

gse <- "GSE56028"

loadLibrary <- function(package) {
  if (!require(basename(package), character.only = TRUE)) BiocManager::install(package, update = FALSE)
  library(basename(package), character.only = TRUE)
}

loadLibraries <- function(packages) {
  invisible(lapply(packages, loadLibrary))
}

packages <- c(
  "oligo",
  "GEOquery",
  "AnnotationDbi",
  "ragene10sttranscriptcluster.db",
  "gprofiler2"
)

loadLibraries(packages)


outdir <- "out/r/preprocess_GSE"
dir.create(
  outdir,
  recursive = TRUE
)
getGEOSuppFiles(
  GEO = gse,
  baseDir = outdir
)

outdir_gse <- file.path(
  outdir,
  gse
)

untar(
  file.path(
    outdir,
    gse,
    paste0(
      gse,
      "_RAW.tar"
    )
  ),
  exdir = outdir_gse
)

cel_paths <- list.celfiles(
  outdir_gse,
  listGzipped = TRUE,
  full = TRUE
)

#length(cels)
#sapply(paste("data", cels, sep="/"), gunzip)
#cels

####
#### TODO: this is just a copy paste.

# https://kasperdanielhansen.github.io/genbioconductor/html/oligo.html

cel_data <- read.celfiles(cel_paths)

#sample_metadata <- sub(
#  pattern = ".CEL",
#  replacement = "",
#  x = rownames(pData(cel_data))
#)
#sample_metadata <- strsplit(
#  sample_metadata,
#  split = "-"
#)
#if (length(unique(lapply(sample_metadata, length))) != 1) {
#  stop("Input metadata is not parsed correctly because all samples do not have the same number of elements")
#}
#pData(cel_data) <- data.frame(
#  matrix(
#    unlist(sample_metadata),
#    byrow = TRUE,
#    ncol = length(sample_metadata[[1]]),
#    dimnames = list(
#      rownames(pData(cel_data)),
#      c(
#        "stress",
#        "treatment",
#        "tissue",
#        "mouse"
#      )
#    )
#  )
#)
## pData(cel_data) <- data.frame(
##   lapply(
##     sample_metadata,
##     as.factor
##   )
## )
#
rma_data <- rma(cel_data)
#
##TODO: Add filter from Surget 2009:
## Probesets with average signal intensitybelow 10 in all groups were considered at background level and were #removed, leaving 25 859 probesets for analysis.

annotations <- select(
  ragene10sttranscriptcluster.db,
  #pd.ragene.1.0.st.v1,
  keys = rownames(rma_data),
  keytype = "PROBEID",
  columns = c(
    'PROBEID',
    'ENSEMBL',
    'ENSEMBLTRANS',
    'SYMBOL'
  )
)


annotations <- select(
  ragene10sttranscriptcluster.db,
  #pd.ragene.1.0.st.v1,
  keys = rownames(rma_data),
  keytype = "PROBEID",
  columns = columns(ragene10sttranscriptcluster.db)
)



tmp <- aggregate(
  . ~ PROBEID,
  data = annotations,
  FUN = function(x) paste(x, collapse=",")
)


# There is no probeset associated to one transcript rather than another one for a given gene
# > tmp2[duplicated(tmp2$SYMBOL) & !duplicated(tmp2$ENSEMBLTRANS),]
# [1] PROBEID      ENSEMBL      ENSEMBLTRANS SYMBOL      
# <0 rows> (or 0-length row.names)

# But they did it in:
# https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-10-26

best_orth <- gorth(
  query = unique(na.omit(annotations$ENSEMBL)),
  source_organism = "rnorvegicus",
  target_organism = "hsapiens",
  mthreshold = 1
)

best_orth <- best_orth[
  ,
  !colnames(best_orth) %in% c(
    "input_number",
    "input_ensg",
    "ensg_number"
  )
]
setnames(
  best_orth,
  old = c(
    "ortholog_name",
    "ortholog_ensg"
  ),
  new = c(
    "hugo_symbol",
    "ensembl_gene_id"
  )
)

annotations2 <- merge(
  annotations,
  best_orth,
  by.x = "ENSEMBL",
  by.y = "input",
  all.x = TRUE,
  sort = FALSE
)

annotations2 <- annotations2[order(annotations2$PROBEID),]

# We keep the orignally submitted metadata
gset <- getGEO(
  GEO = gse,
  destdir = outdir
)


gset2 <- SummarizedExperiment(
  assays = list(rma=rma_data),
  rowRanges = annotations2,
  colData = pData(gset[[1]])
)


dir.create(
  "out/r/"
)

saveRDS(
  object = cel_data,
  file = "out/r/preprocess_cel_data.rds"
)
