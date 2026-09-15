#!/bin/bash

#SBATCH --job-name=STAR_mapping_50_Trimmomatic
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8 
#SBATCH --mem-per-cpu=18G 
#SBATCH --time=1-00:00:00
#SBATCH --qos=1day 
#SBATCH --array=1-21

# script to align reads to an annotated reference genome

# load your required modules below
ml STAR/2.7.3a-foss-2018b

# define sample
MYID=`cat Sample_ID_redo.txt | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`

# make output directory
mkdir OUT_DIR/${MYID}

# define preprocessed fastq files
read1=$(cat list_of_fastq.txt | grep ${MYID} | grep "1.trimmed")
read2=$(cat list_of_fastq.txt | grep ${MYID} | grep "2.trimmed")

# align with STAR
STAR --outFilterMultimapNmax 1 --genomeDir REF_DIR/STAR_genome/otilapia_50 --readFilesIn <(gunzip -c $read1) <(gunzip -c $read2) --outSAMtype BAM SortedByCoordinate --outReadsUnmapped Fastx --runThreadN 8 --limitBAMsortRAM 40000000000 --outFileNamePrefix OUT_DIR/${MYID}/${MYID}.STAR

# compress fastq files
gzip *.fastq
