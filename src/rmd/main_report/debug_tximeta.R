library(fishpond)
library(tximeta)
library(org.Rn.eg.db)
library(SummarizedExperiment)
library(readxl)

index_dir <- "out/salmon/index_ensembl_with_decoys_toplevel/release-102/fasta/rattus_norvegicus/Rattus_norvegicus.Rnor_6.0"

fasta_ftp <- c(
  "ftp://ftp.ensembl.org/pub/release-102/fasta/rattus_norvegicus/cdna/Rattus_norvegicus.Rnor_6.0.cdna.all.fa.gz",
  "ftp://ftp.ensembl.org/pub/release-102/fasta/rattus_norvegicus/ncrna/Rattus_norvegicus.Rnor_6.0.ncrna.fa.gz"
)

gtf_ftp <- "ftp://ftp.ensembl.org/pub/release-102/gtf/rattus_norvegicus/Rattus_norvegicus.Rnor_6.0.102.gtf.gz"

tmp <- tempdir()
json_filepath <- file.path(
  tmp,
  paste0(
    basename(index_dir), 
    ".json"
  )
)

makeLinkedTxome(
  indexDir = index_dir,
  source = "Ensembl",
  organism = "Rattus norvegicus",
  release = "102",
  genome = "Rnor_6.0",
  fasta = fasta_ftp,
  gtf = gtf_ftp,
  jsonFile = json_filepath
)

SRP084288_metadata <- read_excel("out/py/retrieve_sra_metadata/SRP084288.xlsx")

SRP084288_metadata$files <- file.path(
  "out/salmon/quant_fastq_pe_-l_A_--validateMappings_--numGibbsSamples_20_--gcBias_salmon-index-Rnor6-ensembl-r102/sickle/pe_-t_sanger_-q_20/sra-tools/fastq-dump_pe",
  SRP084288_metadata$accession,
  "quant.sf"
)
SRP084288_metadata$names <- SRP084288_metadata$source_name

setTximetaBFC("out/TximetaBFC")

se <- tximeta(SRP084288_metadata)