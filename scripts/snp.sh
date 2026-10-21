#!/bin/bash

#SBATCH --job-name=snippy
#SBATCH --output=log_snp_%j.out
#SBATCH --error=err_snp_%j.err
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G

#paths
DATA_DIR="/hpc/users/s204637/data/assemblies"
REFERENCE="/hpc/users/s204637/05_snp/ncbi_dataset/data/GCF_000196035.1/GCF_000196035.1_ASM19603v1_genomic.fna"
OUT_DIR="/hpc/users/s204637/data/snps"

#preparation
mkdir -p "$OUT_DIR"

echo "------------ SNPs ------------"

set -euo pipefail

module load Anaconda3/2025.06-1
source "$(conda info --base)/etc/profile.d/conda.sh"

conda activate /hpc/users/s204637/tools/conda_envs/snippy_env


for assembly in "$DATA_DIR"/*; do

    #get file
    run_acc=$(basename "$assembly")
    current_contig="${assembly}/contigs.fasta"

    #skip if don't exist
    if [ ! -f "$current_contig" ]; then
        echo "No contigs.fasta found for ${run_acc}, skipping."
        continue
    fi

    snippy \
        --cpus "$SLURM_CPUS_PER_TASK" \
        --outdir "$OUT_DIR/$run_acc" \
        --ref "$REFERENCE" \
        --ctgs "$assembly"
done


echo "--------- snippy core ---------------"

cd "$OUT_DIR"

snippy-core \
    --ref "$REFERENCE" \
    --prefix core \
    "$OUT_DIR"/*
