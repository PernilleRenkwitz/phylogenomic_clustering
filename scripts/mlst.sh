#!/bin/bash

#SBATCH --job-name=spades_assembly
#SBATCH --output=out_spades_%j.out
#SBATCH --error=err_spades_%j.err
#SBATCH --time=03:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G

#paths
DATA_DIR="/hpc/users/s204637/data/assemblies"
OUT_DIR="/hpc/users/s204637/data/mlst"
DB="/hpc/data/databases/pubmlst/mlst_kma_db"

#preparation
mkdir -p "$OUT_DIR"

echo " ------------ Run MLST ----------------"
#hpc/bin/mlstfinder

#mlst loop
for sample in "$DATA_DIR"; do

    #extract contig file
    run_acc=$(basename "$sample")
    current_contig="${DATA_DIR}/${run_acc}"/contig.fasta

    #output dir
    MLST_OUT="${OUT_DIR}/${run_acc}"

    #SPAdes 
    mlstfinder \
        -i "$current_contig" \
        -d "$DB" \
        -o "$MLST_OUT" \
done


