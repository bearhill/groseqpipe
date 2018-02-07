
# Read args ---------------------------------------------------------------
args <- commandArgs()

# Load packages&funcs --------------------------------------------------------------
for(i in list.files('groseqpipe/R/r.func/')){
  load(paste0('groseqpipe/R/r.func/',i))
}
library(magrittr)
library(data.table)
library(DESeq2)

# Calc --------------------------------------------------------------------
countfile <- args[6]
groups <- args[7] %>% strsplit(',') %>% unlist()
ref <- args[8]

counttable <- fread(countfile,header = T,fill = T)
res.table <- DefExp(counttable,groups,ref)
res.table$feature <- NULL
res.table$score <- NULL
res.table$frame <- NULL
res.table$level2 <- NULL
res.table$havana_gene <- NULL

# write result ------------------------------------------------------------
write.table(res.table,file = 'DESeq2result.txt',quote = F,row.names = F)

