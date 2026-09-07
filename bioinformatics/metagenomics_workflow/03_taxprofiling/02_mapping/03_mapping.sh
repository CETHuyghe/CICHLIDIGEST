#!/bin/bash

#SBATCH --job-name=mapfed                
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4              
#SBATCH --mem-per-cpu=5G 
#SBATCH --time=1-00:00:00 
#SBATCH --qos=1day  
#SBATCH --array=1-47

# load modules needed
ml Bowtie2/2.5.1-GCC-13.2.0
ml SAMtools/1.20-GCC-13.2.0

# define sample to map
MYID=`cat Sample_ID.txt | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`

# map fastp sequences where host was removed to MAG database
bowtie2 --threads 4 -x DB_drep_MAGs/db_drep_mags -1 fastp_preprocessing/${MYID}/${MYID}_unmapped_orenil_1.fastq.gz -2 fastp_preprocessing/${MYID}/${MYID}_unmapped_orenil_2.fastq.gz | samtools sort -o $TMPDIR/${MYID}_mag_mapped.sam 

# compress sam to bam
samtools view -bS $TMPDIR/${MYID}_mag_mapped.sam > $TMPDIR/${MYID}_mag_mapped.bam

# copy bam to output directory
cp $TMPDIR/${MYID}_mag_mapped.bam OUT_DIR/${MYID}_mag_mapped.bam
