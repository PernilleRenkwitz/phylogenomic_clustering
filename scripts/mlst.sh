#!/bin/bash

#SBATCH --job-name=download_mlst_db
#SBATCH --output=out_down_mlst_db_%j.out
#SBATCH --error=err_down_mlst_db_%j.err
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --nodelist=fremen

#paths
DATA_DIR="/hpc/users/s204637/data/assemblies"
OUT_DIR="/hpc/users/s204637/04_mlst/report_test"
DB="/hpc/data/databases/pubmlst/mlst_kma_db/mlst"

#files
#files=("$DATA_DIR"/*/contigs.fasta) 

#preparation
mkdir -p "$OUT_DIR"

echo " ------------ Run MLST ----------------"
#hpc/bin/mlstfinder

#try with one file at a time

for sample in "$DATA_DIR"/*; do

    #only name
    run_acc=$(basename "$sample")
    current_contig="${sample}/contigs.fasta"

    #skip if don't exist
    if [ ! -f "$current_contig" ]; then
        echo "No contigs.fasta found for ${run_acc}, skipping."
        continue
    fi

    #output
    MLST_OUT="${OUT_DIR}/${run_acc}"

    #run
    echo "Processing ${run_acc}"

    mlstfinder \
        -i "$current_contig" \
        -d "$DB" \
        -o "$MLST_OUT"

done

echo "------------ MLST complete ------------"

files=("$DATA_DIR"/*/contigs.fasta) 

'''
#check if files exist
if [ ! -e "${files[0]}" ]; then
	echo "No contigs file found."
	exit 1
fi


#mlst
mlstfinder \
    -i "${files[@]}" \
    -d "$DB" \
    -o "$OUT_DIR" 

'''

"""
#test for few files
mlstfinder \
    -i "${files[0]}" "${files[1]}" "${files[2]}" \
    -d "$DB" \
    -o "$OUT_DIR/test"

"""


#!/bin/bash

#SBATCH --job-name=snp
#SBATCH --output=log_snp_%j.out
#SBATCH --error=err_snp_%j.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G



### SNIPPY


#!/bin/bash
#SBATCH --job-name=snippy
#SBATCH --output=snippy_%j.log
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G

set -euo pipefail

module load Anaconda3/2025.06-1
source "$(conda info --base)/etc/profile.d/conda.sh"


conda activate /hpc/users/.../tools/conda_envs/snippy

ASSEMBLY_DIR="/path/to/assemblies"
REFERENCE="/path/to/reference.fasta"
OUT_DIR="path/to/snippy_output"

mkdir -p "$OUT_DIR"

for ASSEMBLY in "$ASSEMBLY_DIR"/*.fasta; do

    SAMPLE=$(basename "$ASSEMBLY" .fasta)

    snippy \
        --cpus "$SLURM_CPUS_PER_TASK" \
        --outdir "$OUT_DIR/$SAMPLE" \
        --ref "$REFERENCE" \
        --ctgs "$ASSEMBLY"

done

cd "$OUT_DIR"

snippy-core \
    --ref "$REFERENCE" \
    --prefix core \
    "$OUT_DIR"/*



#### tree 

#!/bin/bash
#SBATCH --job-name=tree
#SBATCH --output=log_tree_%j.log
#SBATCH --error=err_tree_%j.err
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G


module load FastTree

FastTree \
    -nt \
    -gtr \
    core.full.aln \
    > snp_tree.newick


#iTOL
