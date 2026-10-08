#!/bin/bash

#SBATCH --job-name=fastq_down
#SBATCH --output=fastq_down_%j.out
#SBATCH --error=fastq_down_%j.err
#SBATCH --time=3:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G


# Reads ERS/accession or ERR/run accession from .txt file
# Gets query from ENA
# extract ERRxxx to get run accession for directives
# and fastq_ftp link for download
# downloads fastq files

#Hardcoded
# inputfile as acc.txt 		# at the bottom in dir with script
#filepath as data/fastq		#just below here


#data paths
DATA_DIR="/hpc/users/s204637/data/raw"
ACC_FILE="/hpc/users/s204637/data/acc.txt"

#read accession numbers, get from ENA and download
while read -r line; do
    #accession number
    acc=$(echo "$line" | awk '{print $1}')

    #ignore empty lines
    [[ -z "$acc" ]] && continue

    echo "ACC=[$acc]"
    #get url from ENA
    ena_ftp="$(curl -fsSL \
        "https://www.ebi.ac.uk/ena/portal/api/filereport?accession=${acc}&result=read_run&fields=run_accession,fastq_ftp&format=tsc" \
        | awk -F '\t' 'NR > 1 && $2 != "" {print $1"\n"$2}' \
    )"

    #seperate run_acc and fastq
    run_acc=$(echo "$ena_ftp" | sed -n '1p')
    fastq_ftp=$(echo "$ena_ftp" | sed -n '2p' | tr ';' '\n')


    #download fastq
    echo "$fastq_ftp" | while read -r ftpfile; do

        #ignore empty lines
        [[ -z "$ftpfile" ]] && continue

        #download
        wget -nc \
            -P "$DATA_DIR" "ftp://${ftpfile}"
    done <<< "$fastq_ftp"

done < "$ACC_FILE"
