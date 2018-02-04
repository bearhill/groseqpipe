#!/bin/bash
#Part2 Identify differential expressing genes.


mkdir coordinate
cd coordinate
wget ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_19/gencode.v19.annotation.gtf.gz 
gunzip gencode.v19.annotation.gtf.gz
awk -F "\t" '$3 == "gene"' OFS="\t" coordinate/gencode.v19.annotation.gtf | awk -F "\t" '$3="exon"' OFS="\t" > coordinate/gencode.v19.annotation.geneonly.gtf

###Generate count table.
cd ..
analyzeRepeats.pl coordinate/gencode.v19.annotation.geneonly.gtf hg19 -raw -strand + -d Homer.tags/* > counttable.raw.txt

module load Rstats
module load RstatsPackages

Rscript groseqpipe/Config.R
Rscript groseqpipe/CounttableConvert.R coordinate/gencode.v19.annotation.geneonly.gtf counttable.raw.txt $1
Rscript groseqpipe/DESeq2.R counttable.raw.txt $2 $3