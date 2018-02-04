# Read args ---------------------------------------------------------------
args <- commandArgs()

# Load packages&funcs --------------------------------------------------------------
for(i in list.files('groseqpipe/R/r.func/')){
  load(paste0('groseqpipe/R/r.func/',i))
}
require(GenomicRanges)
require(magrittr)
require(data.table)
require(stringr)

# Read Args ---------------------------------------------------------------
coordinate <- args[6]
counttable.raw.file <- args[7]
groupn <- args[8]

# Change transcripts to GR -------------------------------------------------
transcripts.gr <- GTF2GR(coordinate) 

# Infomation from raw counttable -----------------------------------------------------
counttable <- fread(counttable.raw.file)
Info <- colnames(counttable)[1]

# combine coordinate info
counttable <- makeGRangesFromDataFrame(counttable[,-1],keep.extra.columns = T) %>%sort()
counttable <- cbind(as.data.table(transcripts.gr),mcols(counttable)[,tail(seq(ncol(mcols(counttable))),as.numeric(groupn))]) %>%
  as.data.table()
file.remove(counttable.raw.file)
write.table(counttable,file = 'counttable.raw.txt',row.names = F)

q(save = 'no')