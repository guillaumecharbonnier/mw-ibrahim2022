# SRA Db is obsolete and so is this script
# Check src/py/retrieve_sra_metadata.py instead
library(SRAdb)

srp_ids <- c(
  "SRP057486",
  "SRP131063",
  "SRP056481"
)
outdir <- "out/r/retrieve_sra_metatadata"
dir.create(
  path = outdir,
  recursive = TRUE
)
setwd(outdir)
#Did not work when tried on 2021-04-30
# Hang each time around 900 mb downloaded
#getSRAdbFile(destdir = outdir)

sqlfile <- 'SRAmetadb.sqlite'
sqlfile <- '../mw-antares-data/inp/SRAmetadb.sqlite.gz'

# fail too:
# > system("wget https://s3.amazonaws.com/starbuck1/sradb/SRAmetadb.sqlite.gz")
# system("gunzip SRAmetadb.sqlite.gz")
# sqlfile <- 'SRAmetadb.sqlite'
# --2021-04-30 15:44:40--  https://s3.amazonaws.com/starbuck1/sradb/SRAmetadb.sqlite.gz
# Resolving s3.amazonaws.com (s3.amazonaws.com)... 52.216.226.107
# Connecting to s3.amazonaws.com (s3.amazonaws.com)|52.216.226.107|:443... connected.
# HTTP request sent, awaiting response... 200 OK
# Length: 2664552708 (2.5G) [binary/octet-stream]
# Saving to: ‘SRAmetadb.sqlite.gz.1’

# SRAmetadb.sqlite.gz.1                                 100%[======================================================================================================================>]   2.48G  15.8MB/s    in 2m 48s  

# 2021-04-30 15:47:28 (15.1 MB/s) - ‘SRAmetadb.sqlite.gz.1’ saved [2664552708/2664552708]


# gzip: SRAmetadb.sqlite.gz: unexpected end of file

# if (!file.exist(sqlfile)) {
#   system("wget https://s3.amazonaws.com/starbuck1/sradb/SRAmetadb.sqlite.gz")
#   system("gunzip SRAmetadb.sqlite.gz")
# }

file.info(sqlfile)

sra_con <- dbConnect(
  SQLite(),
  sqlfile
)

sra_tables <- dbListTables(sra_con)
sra_tables

dbListFields(
  sra_con,
  "study"
)

conversion <- sraConvert(
  c(
    'SRP001007',
    'SRP000931'
    ),
  sra_con = sra_con
)

