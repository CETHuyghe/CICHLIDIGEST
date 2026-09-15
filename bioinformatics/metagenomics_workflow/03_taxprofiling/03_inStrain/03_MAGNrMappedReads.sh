# script to extract the total number of sample read pairs that mapped to each MAG, for each sample seperately

paste $(cat Sample_ID.txt | while IFS= read -r line || [[ -n "$line" ]];
do 
  {
    echo "$line"
    cut -f1,27 "OUT_DIR/$line/output/${line}_genome_info.tsv"
  } > "OUT_DIR/genome_infos/${line}_column_totalreads.txt"
  echo "${line}_column_totalreads.txt"
done < Sample_ID.txt)
