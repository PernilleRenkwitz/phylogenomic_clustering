#!/bin/bash

#SBATCH --job-name=spades_assembly
#SBATCH --output=out_spades_%j.out
#SBATCH --error=err_spades_%j.err
#SBATCH --time=03:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G

#paths
DATA_DIR="/hpc/users/s204637/data/trimmed"
OUT_DIR="/hpc/users/s204637/data/assemblies"

#preparation
mkdir -p "$OUT_DIR"

echo " ------------ Run Spades ----------------"

#assembly/spades loop
for r1 in "$DATA_DIR"/*_trim_1.fastq.gz; do

    #extract names
    file=$(basename "$r1")
    run_acc="${file%_trim_1.fastq.gz}"
    r2="${DATA_DIR}/${run_acc}_trim_2.fastq.gz"

    #output dir
    assemble_out="${OUT_DIR}/${run_acc}"

    #skip complete assemblies
    if [ -f "${assemble_out}/contigs.fasta" ]; then
        echo "$run_acc alredy assembled. Skipping."
        continue
    fi

    #SPAdes 
    spades.py \
        -1 "$r1" \
        -2 "$r2" \
        -o "$OUT_DIR"/"$run_acc" \
        --isolate
done
