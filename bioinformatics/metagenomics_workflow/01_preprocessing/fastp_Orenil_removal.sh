#!/bin/bash
#SBATCH --job-name=MAGs_fastp_host
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=15
#SBATCH --mem-per-cpu=15G
#SBATCH --time=14-00:00:00
#SBATCH --qos=2weeks
#SBATCH --array=1

echo "Running fastp preprocessing"

# load fastp v0.23.4
ml fastp/0.23.4-GCC-12.3.0

# define sample for array
MYID=`cat WRK_DIR/Sample_ID.txt | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`

# make new directory for every sample
mkdir OUT_DIR/${MYID}

# define all lanes with raw sequenced shotgun reads of R1 and R2 seperatly per sample
FILELIST1=$(ls RAW_DIR/*_${MYID}_*R1*.fastq.gz)
FILELIST2=$(ls RAW_DIR/*_${MYID}_*R2*.fastq.gz)

# concatenate all R1 and R2 per sample in temporal directory
cat ${FILELIST1} > /$TMPDIR/${MYID}_R1_cat.fastq.gz
cat ${FILELIST2} > /$TMPDIR/${MYID}_R2_cat.fastq.gz

# echo which samples have been concatenated
echo ${MYID} >> OUT_DIR/conc_done.txt

# run fastp preprocessing with quality filtering and removal of adapters, no deduplications since this info is needed for binning
fastp -i $TMPDIR/${MYID}_R1_cat.fastq.gz -I $TMPDIR/${MYID}_R2_cat.fastq.gz -o $TMPDIR/${MYID}_fastp.R1.fq.gz -O $TMPDIR/${MYID}_fastp.R2.fq.gz -a -l 30 -c -g --adapter_sequence=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA --adapter_sequence_r2=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT --cut_front --cut_tail --cut_window_size 4 --cut_mean_quality 30 --qualified_quality_phred 30 --unqualified_percent_limit 30 --n_base_limit 5 --length_required 50 

# echo which samples have been preprocessed
echo ${MYID} >> OUT_DIR/fastp_done.txt

# copy the preprocessed files to the output directory
cp $TMPDIR/${MYID}_fastp.R1.fq.gz OUT_DIR/${MYID}/${MYID}_fastp.R1.fq.gz
cp $TMPDIR/${MYID}_fastp.R2.fq.gz OUT_DIR/${MYID}/${MYID}_fastp.R2.fq.gz


echo "Removal of host reads mapping to Oreochromis niloticus"

# unload all modules and load BWA v0.7.18 and SAMtools v1.20
module purge
ml BWA/0.7.18-GCCcore-13.2.0
ml SAMtools/1.20-GCC-13.2.0 

# run bwa mem to map reads to Oreochromis niloticus reference genome
bwa mem DB_DIR/NCBI_Orenil_GCF_001858045_2/ncbi-genomes-2020-01-13/GCF_001858045.2_O_niloticus_UMD_NMBU_genomic.fna $TMPDIR/${MYID}_fastp.R1.fq.gz $TMPDIR/${MYID}_fastp.R2.fq.gz > $TMPDIR/${MYID}.sam

# echo which samples have been mapped
echo ${MYID} >> OUT_DIR/nohost_done.txt

# only define sequences that did not map to the reference
samtools view -h -f 12 -F 256 -S $TMPDIR/${MYID}.sam > $TMPDIR/${MYID}_unmapped.sam

# only keep sequences that did not map to the reference
samtools fastq $TMPDIR/${MYID}_unmapped.sam -1 $TMPDIR/${MYID}_unmapped_1.fastq -2 $TMPDIR/${MYID}_unmapped_2.fastq

# compress fastq files
gzip $TMPDIR/*.fastq

# compress sam files
samtools view -bS $TMPDIR/${MYID}.sam > $TMPDIR/${MYID}.bam
samtools view -bS $TMPDIR/${MYID}_unmapped.sam > $TMPDIR/${MYID}_unmapped.bam

# Copy the required files from temporal directory to the output directory
cp $TMPDIR/${MYID}.bam OUT_DIR/${MYID}/${MYID}_orenil.bam
cp $TMPDIR/${MYID}_unmapped.bam OUT_DIR/${MYID}/${MYID}_unmapped_orenil.bam
cp $TMPDIR/${MYID}_unmapped_1.fastq.gz OUT_DIR/${MYID}/${MYID}_unmapped_orenil_1.fastq.gz
cp $TMPDIR/${MYID}_unmapped_2.fastq.gz OUT_DIR/${MYID}/${MYID}_unmapped_orenil_2.fastq.gz

# echo which samples have been copied
echo ${MYID} >> OUT_DIR/copied_done.txt
