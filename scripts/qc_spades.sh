#!/bin/bash

#SBATCH --job-name=spades_assembly
#SBATCH --output=out_spades_%j.out
#SBATCH --error=err_spades_%j.err
#SBATCH --time=03:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G

#paths
DATA_DIR="/hpc/users/s204637/data/assemblies"
OUT_DIR="/hpc/users/s204637/data/qc_assemblies"

#preparation
mkdir -p "$OUT_DIR"

echo " ------------ Quality Control of SPAdes ----------------"

for sample in "$DATA_DIR"; do

    run_acc=$(basename "$sample")
    #generate stats for assemblies
    seqkit stats -a "${DATA_DIR}/${run_acc}"/contig.fasta \
    --threads 8 \
    -o "${OUT_DIR}/${run_acc}"
done
