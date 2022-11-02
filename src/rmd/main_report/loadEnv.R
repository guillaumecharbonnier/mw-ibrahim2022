# Load all R files in the "r" folder.
# Mostly my favourite functions and variables I rely on for Rmd docs
r_files <- c(
  list.files(
    path = "r",
    pattern = ".R$",
    full.names = TRUE
  )
)
lapply(r_files, source)

packages <- c(
  "data.table",
  "pbapply",
  "yaml",
  "ggpubr",
  "ggbeeswarm",
  "ggrepel",
  "ggcorrplot",
  "ggh4x",
  "NMF",
  "ComplexHeatmap",
  "circlize",
  "dendextend",
  "dendsort",
  # "pheatmap",
  "yaml",
  "httr",
  "styler",
  "GenomicRanges",
  "RColorBrewer",
  "GEOquery",
  "AnnotationDbi",
  "mouse4302.db",
  "ragene10sttranscriptcluster.db",
  "org.Hs.eg.db",
  "org.Mm.eg.db",
  "org.Rn.eg.db",
  "oligo",
  "limma",
  "edgeR",
  "DESeq2",
  "apeglm",
  "EnhancedVolcano",
  #"MetaVolcanoR",
  "fishpond",
  "tximeta",
  "SummarizedExperiment",
  # "WGCNA",
  "CEMiTool",
  "gprofiler2",
  #' pdftools',
  "openxlsx",
  "readxl",
  #' biomaRt',
  "clusterProfiler",
  "enrichplot",
  "ReactomePA",
  #' GOplot',
  #' plotly',
  "factoextra",
  "umap",
  "plyr",
  #' ggcorrplot',
  #' GGally',
  #' scales',
  #' UpSetR',
  #' reticulate',
  "DT",
  "R.utils", # load bz2 with fread
  "knitr"
)

loadLibraries(packages)

theme_set(theme_bw())

# Retrieve the relative path used by Bookdown as output folder
book_from_rmd <- read_yaml("_bookdown.yml")$output_dir
mw_from_rmd <- sub("/[^\\.].*$", "", book_from_rmd)
book_from_mw <- gsub("\\.\\./", "", book_from_rmd)
dir.create(
  file.path(book_from_rmd, "plots"),
  recursive = TRUE,
  showWarnings = FALSE
)
geo_dir <- file.path(book_from_rmd, "geo")
dir.create(
  geo_dir,
  showWarnings = FALSE
)
xlsx_dir <- file.path(book_from_rmd, "xlsx")
dir.create(
  xlsx_dir,
  showWarnings = FALSE
)

symnumargs <- list(
  cutpoints = c(0, 1e-04, 0.001, 0.01, 0.05, 1),
  symbols = c("∗∗∗∗", "∗∗∗", "∗∗", "∗", "ns")
)
human_cols <- c(
  "ensembl_gene_id",
  "hugo_symbol",
  "baseMean",
  "log2FoldChange",
  "pvalue",
  "padj"
)
rat_cols <- c(
  "rat_ensembl_gene_id",
  "rat_symbol",
  human_cols
)
mouse_cols <- c(
  "mouse_ensembl_gene_id",
  "mouse_symbol",
  human_cols
)

# symnumargs <- list(cutpoints = c(0,  1e-10,  1e-09,  1e-08,  1e-07,  1e-06,  1e-05,  1e-04, 0.001, 0.01, 0.05, 1), symbols = c("∗∗∗∗", "∗∗∗", "∗∗", "∗", "ns"))

max_threads <- 4

megablast_columns <- c(
  "query_acc.ver",
  "subject_acc.ver",
  "pct_identity",
  "alignment_length",
  "mismatches",
  "gap_opens",
  "q._start",
  "q._end",
  "s._start",
  "s._end",
  "evalue",
  "bit_score"
)

standard_cols_for_tT <- c(
  "ID",
  "adj.P.Val",
  "P.Value",
  "t",
  "B",
  "logFC",
  "Gene.stable.ID",
  "Gene.name",
  "Gene.symbol",
  "Gene.title"
)

cols_to_for_integration_original_specie <- c(
  "Gene.name",
  "baseMean",
  "log2FoldChange",
  "pvalue",
  "padj",
  "project",
  "comparison"
)
