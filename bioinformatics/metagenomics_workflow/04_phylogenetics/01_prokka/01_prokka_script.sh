#!/bin/bash

#SBATCH --job-name=prokka_MAGs               
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2              
#SBATCH --mem-per-cpu=1G
#SBATCH --time=1-00:00:00 
#SBATCH --qos=1day  
#SBATCH --array=1-1708

# slurm script to annotate all (non-dereplicated by dRep) MAGs together with closely related genomes from databases

# activate conda environment
source ~/.bashrc
conda activate prokka_env

# define MAG or genome
MYID=`cat MAGs_ID.txt | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`

# make output directory
mkdir -p OUT_DIR

# run prokka
prokka --kingdom Bacteria --outdir OUT_DIR/${MYID} --prefix ${MYID} MAG_DIR/${MYID}.fa
