#!/bin/bash
#SBATCH --job-name=calc_filt_DNA
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=3
#SBATCH --mem-per-cpu=5M
#SBATCH --time=00:30:00
#SBATCH --qos=30min
#SBATCH --array=1-458

echo "calculating the number of sequences after fastp preprocessing and host removal"

# define which sample to calculate
MYID=`cat WRK_DIR/Sample_ID.txt | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`

# copy the output files of fastp_Orenil_removal.sh to temporal directory
cp OUT_DIR/${MYID}/${MYID}_unmapped_orenil_1.fastq.gz $TMPDIR/${MYID}_1.fastq.gz
cp OUT_DIR/${MYID}/${MYID}_unmapped_orenil_2.fastq.gz $TMPDIR/${MYID}_2.fastq.gz

# count the number of lines in each file
READ1=`zcat $TMPDIR/${MYID}_1.fastq.gz | wc -l`
READ2=`zcat $TMPDIR/${MYID}_2.fastq.gz | wc -l`

# divide these lines by 4
READS1=`echo $((READ1/4))`
READS2=`echo $((READ2/4))`

# add the total number of unmapped reads for each sample to NrSeqUnMapOrenil_fastp.txt
echo ${MYID}" "${READS1}" "${READS2} >> OUT_DIR/NrSeqUnMapOrenil_fastp.txt
