#!/bin/bash

#SBATCH --job-name=fastp
#SBATCH --output=out_fastp_%j.out
#SBATCH --error=err_fastp_%j.err
#SBATCH --time=03:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G


#paths / variables hardcoded for now
HOME_DIR="/hpc/users/s204637"
DATA_DIR="/hpc/users/s204637/data/raw"
OUT_DIR="/hpc/users/s204637/data/trimmed"
REPORT_DIR="${HOME_DIR}/02_pre_processing/reports"

#preparation
mkdir -p "$REPORT_DIR"
mkdir -p "$OUT_DIR"

#navigate dir
cd "$DATA_DIR"

# fastp of all run_acc
for r1 in "$DATA_DIR"/*_1.fastq.gz; do

	#extract names
	file=$(basename "$r1")
	run_acc="${file%_1.fastq.gz}"				#isolates only run_acc
	r2="${DATA_DIR}/${run_acc}_2.fastq.gz"

	#fastp
	fastp \
	--in1 "$r1" \
	--in2 "$r2" \
	--out1 "${OUT_DIR}/${run_acc}_trim_1.fastq.gz" \
	--out2 "${OUT_DIR}/${run_acc}_trim_2.fastq.gz" \
	--detect_adapter_for_pe \
	--trim_poly_g \
	--cut_right \
	--correction \
	--html "${REPORT_DIR}/${run_acc}_report.html"
	--json "${REPORT_DIR}/${run_acc}_report.json"
done
