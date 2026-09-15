# Script to extract the breath of each reference MAG covered by sample reads, seperate file for each sample

paste $(cat Sample_ID.txt | while IFS= read -r line || [[ -n "$line" ]];
do 
  {
    echo "$line"
    cut -f1,3 "OUT_DIR/$line/output/${line}_genome_info.tsv"
  } > "OUT_DIR/genome_infos/${line}_column.txt"
  echo "${line}_column.txt"
done < Sample_ID.txt)
