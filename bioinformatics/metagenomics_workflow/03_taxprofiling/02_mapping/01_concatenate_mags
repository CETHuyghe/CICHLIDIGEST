#!/bin/bash

#SBATCH --job-name=conc                
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4              
#SBATCH --mem-per-cpu=5G 
#SBATCH --time=06:00:00 
#SBATCH --qos=6hours  
#SBATCH --array=1

# script to concatenate all dereplicated MAGs into one file to make mapping reference database

for sample in $(cat drep_MAG_ID.txt);
do

cat dereplicated_genomes/${sample}.fa | sed 's/>/>'${sample}'_/' >> mapping/DB_drep_MAGs/db_drep_mags.fa

done
