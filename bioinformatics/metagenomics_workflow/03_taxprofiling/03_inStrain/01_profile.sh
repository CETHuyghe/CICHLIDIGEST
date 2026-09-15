#!/bin/bash

#SBATCH --job-name=instrain_profile               
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10              
#SBATCH --mem-per-cpu=15G 
#SBATCH --time=1-00:00:00 
#SBATCH --qos=1day  
#SBATCH --array=1-505


# activate conda environment
source ~/.bashrc
conda activate inStrain_env

# make output directory
mkdir -p output

# define sample
MYID=`cat Sample_ID.txt | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`

# run inStrain profile
inStrain profile MAP_OUT_DIR/OUT_DIR/${MYID}_mag_mapped.bam DB_drep_MAGs/DB_drep_MAGs.fa -o OUT_DIR/${MYID} -p 10 -s scaftobin_all.stb
