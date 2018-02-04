

for(i in list.files('groseqpipe/R/r.func/')){
  load(paste0('groseqpipe/R/r.func/',i))
}

Pkginstall('magrittr')
Pkginstall('ggplot2')
Pkginstall('data.table')
Pkginstall('stringr')
Pkginstall('RColorBrewer')

ImportBiopacks('org.Hs.eg.db')
ImportBiopacks('TxDb.Hsapiens.UCSC.hg19.knownGene')
ImportBiopacks('GenomicRanges')
ImportBiopacks('DESeq2')
