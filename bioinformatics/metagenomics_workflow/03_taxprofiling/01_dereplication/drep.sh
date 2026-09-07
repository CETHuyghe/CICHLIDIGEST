#!/bin/bash

#SBATCH --job-name=dRep               
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10              
#SBATCH --mem-per-cpu=10G 
#SBATCH --time=1-00:00:00 
#SBATCH --qos=1day  
#SBATCH --array=1

# load conda environment
source ~/.bashrc
conda activate dRep_env

# run drep to dereplicate all MAGs
dRep dereplicate OUT_DIR/ -g MAG_DIR/*.fa -comp 50 -con 5 -p 10


