#!/bin/bash
#----------------------------------------------------
# Sample SLURM job script
#   for TACC Stampede2 KNL nodes
#
#   *** Serial Job on Normal Queue ***
#
# Last revised: 27 Jun 2017
#
# Notes:
#
#   -- Copy/edit this script as desired.  Launch by executing
#      "sbatch knl.serial.slurm" on a Stampede2 login node.
#
#   -- Serial codes run on a single node (upper case N = 1).
#        A serial code ignores the value of lower case n,
#        but slurm needs a plausible value to schedule the job.
#
#   -- For a good way to run multiple serial executables at the
#        same time, execute "module load launcher" followed
#        by "module help launcher".

#----------------------------------------------------

#SBATCH -J gromapping        # Job name
#SBATCH -o output       # Name of stdout output file
#SBATCH -e err       # Name of stderr error file
#SBATCH -p normal         # Queue (partition) name
#SBATCH -N 1              # Total # of nodes (must be 1 for serial)
#SBATCH -n 1              # Total # of mpi tasks (should be 1 for serial)
#SBATCH -t 8:00:00       # Run time (hh:mm:ss)
#SBATCH --mail-user=xiong.feng.90@gmail.com
#SBATCH --mail-type=fail   # Send email at begin and end of job

# Other commands must follow all #SBATCH directives...


# Launch serial code...



#Upload fastq file.------------------------------------
cd YOUR_DIRECTORY
mkdir fastq
cp mv *.fastq fastq/

#Fastq file trimming and mapping. # Need to install bowtie2 cutadapt------------------------------------------
mkdir bam
mkdir bigwig
mkdir Homer.tags
for i in `ls fastq | grep "fastq.gz"`
do
	cutadapt -a 'A{19}' -m 20 -o fastq/${i%.f*}_trimed.fastq fastq/$i
	cutadapt --nextseq-trim=20 -m 20 -o fastq/${i%.f*}_trimed2.fastq fastq/${i%.f*}_trimed.fastq
	rm fastq/${i%.f*}_trimed.fastq
	bowtie2 -5 2 -p 60 -x $WORK/bowtie_index/hg19 fastq/${i%.f*}_trimed2.fastq | samtools view -1 | samtools sort > ./bam/${i%.f*}.sorted.bam
	makeTagDirectory Homer.tags/${i%.f*}/ -tbp 3 -fragLength 100 ./bam/${i%.f*}.sorted.bam
	makeBigWig.pl Homer.tags/${i%.f*}/ hg19 -norm 1e6 -strand -webdir ./bigwig -url https://s3.amazonaws.com/
    makeUCSCfile Homer.tags/${i%.f*}/ -norm 1e6 -strand separate -o auto
done
cat err | grep -v "Warning" | grep -v "Generating" > Log.txt
rm err
