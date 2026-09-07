#!/bin/bash

#SBATCH --job-name=conc                
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=4              
#SBATCH --mem-per-cpu=5G 
#SBATCH --time=06:00:00 
#SBATCH --qos=6hours  
#SBATCH --array=1

# script to index the MAGs database for Bowtie mapping

ml Bowtie2/2.5.1-GCC-13.2.0

bowtie2-build --threads 8 db_drep_mags.fa db_drep_mags


