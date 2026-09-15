#!/bin/bash

#SBATCH --job-name=STAR_mapping_50_Trimmomatic
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=20G 
#SBATCH --time=1-00:00:00
#SBATCH --qos=1day 
#SBATCH --array=1-21

# slurm script to estimate read count for every gene per sample

# load your required modules below
ml SAMtools/1.12-foss-2018b
ml HTSeq/0.11.2-foss-2018b-Python-3.6.6

# define sample
MYID=`cat Sample_ID_redo.txt | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`

# make output directory
mkdir OUT_DIR/${MYID}

# index STAR bam output
samtools index STAR_DIR/${MYID}/${MYID}.STARAligned.sortedByCoord.out.bam

# convert bam to sam
samtools view STAR_DIR/${MYID}/${MYID}.STARAligned.sortedByCoord.out.bam > $TMPDIR/${MYID}.STARAligned.sortedByCoord.out.sam

# run htseq
htseq-count -f sam -r pos -s no -m union -s no -t gene $TMPDIR/${MYID}.STARAligned.sortedByCoord.out.sam /REF_DIR/FASTA_GTF_GFF/otilapia/GCF_001858045.1_ASM185804v2_genomic_gene.gtf > /OUT_DIR/${MYID}.count.txt
