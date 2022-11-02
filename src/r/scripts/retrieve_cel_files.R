#! /usr/bin/env R

library(GEOquery)


outdir <- "out/r/retrieve_cel_files"
dir.create(
  outdir,
  recursive = TRUE
)
getGEOSuppFiles(
  "GSE56028",
  baseDir = outdir
)


untar(
  file.path(
    outdir,
    "GSE56028/GSE56028_RAW.tar"
  ),
  exdir = file.path(
    "GSE56028"outdir
)

cels <- list.files("data/", pattern = "[gz]")

length(cels)
sapply(paste("data", cels, sep="/"), gunzip)
cels