#!/bin/bash

#SBATCH --job-name=Trimmomatic
#SBATCH --ntasks=1 #run on 3 tasks
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=10G
#SBATCH --time=06:00:00       
#SBATCH --qos=6hours
#SBATCH --array=1-21

# script to concatenate, filter and trimm the raw gut tissue RNA sequencing files

# load modules
ml Trimmomatic/0.39-Java-1.8


# define sample
MYID=`cat Sample_ID_redo.txt | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`


# make new directory for every sample
mkdir OUT_DIR/${MYID}

# define and concatenate raw sequencing read files of R1 and R2 seperatly
read1=$(cat fastq_files_redo.txt | grep ${MYID} | grep "R1")
read2=$(cat fastq_files_redo.txt | grep ${MYID} | grep "R2")

# run trimmomatic
java -jar Trimmomatic/0.39-Java-1.8/trimmomatic-0.39.jar PE -version -threads 4 -phred33 $read1 $read2 /OUT_DIR/${MYID}/${MYID}.1.trimmed.fastq /OUT_DIR/${MYID}/${MYID}.1un.trimmed.fastq /OUT_DIR/${MYID}/${MYID}.2.trimmed.fastq /OUT_DIR/${MYID}/${MYID}.2un.trimmed.fastq ILLUMINACLIP:Trimmomatic/0.39-Java-1.8/adapters/TruSeq3-PE.fa:2:30:10:2 SLIDINGWINDOW:4:15 MINLEN:30

# compress output
gzip *.fastq
