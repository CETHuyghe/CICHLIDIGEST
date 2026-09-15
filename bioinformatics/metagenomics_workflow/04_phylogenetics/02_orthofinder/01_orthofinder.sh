#!/bin/bash

#SBATCH --job-name=orthfindr_MAGs                
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40              
#SBATCH --mem-per-cpu=10G 
#SBATCH --time=7-00:00:00 
#SBATCH --qos=1week  
#SBATCH --array=1

# slurm script to identify orthogroups across genomes

# activate conda environment
source ~/.bashrc
conda activate orthf_env

# run orthofinder on directory containing all faa files from prokka
orthofinder -M msa -t 40 -o OUT_DIR -f FAA_DIR
