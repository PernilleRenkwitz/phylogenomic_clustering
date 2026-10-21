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


