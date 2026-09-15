#!/bin/bash

#SBATCH --job-name=IQ-Tree_MAGs                
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20              
#SBATCH --mem-per-cpu=20G 
#SBATCH --time=7-00:00:00 
#SBATCH --qos=1week  
#SBATCH --array=1

# slurm script to construct phylogenetic IQ tree from the species tree alignment of orthofinder
# number-to-genome file can be found in OUT_DIR_ORTHOF/RESULTS/WorkingDirectory/SpeciesIDs.txt

# activate conda environment
source ~/.bashrc
conda activate iqtree_env

# run iqtree
iqtree -s OUT_DIR_ORTHOF/RESULTS/WorkingDirectory/Alignments_ids/SpeciesTreeAlignment.fa -B 1000 -alrt 1000 -T 20
