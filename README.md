# groseqpipe
tools requirement:
cutadapt/bowtie2/Homer.

Usage:
1. Make a directory of your project. 
2. Copy your fastq files into this directory.
3. Git lone this groseqpipe into your directory.
4. Edit the first line of groseqpipe/gromapping.sh. Change YOUR_DIRECTORY to the full path of your project directory.
5. Edit the `#SBATCH --mail-user=` line. Change the email address to your own one.
6. Edit the `#SBATCH -t` line according to your file size. One fastq file needs about 2 hours.
7. Run `sbatch groseqpipe/gromapping.sh` under your directory. 

8. After your jobs are done. You can calculate the differentail expressing gene with following command:
   `sh groseqpipe/diffexp.sh NUMBER GROUPS REFGROUP`. `FILENUMBE`R is the number of your samples. `GROUPS` is the real sample groups with quote, for example: `"siCTL,siCTL,siGENEA,siGENEA"`. `REFGROUP` is the name control group name, for example `"siCTL"`
   
Note: 
1.There should be human hg19 index under the directory of $WORK/bowtie_index/. Otherwise, please modify the gromapping.sh accordingly.
