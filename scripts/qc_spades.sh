#!/bin/bash

#SBATCH --job-name=qc_spades
#SBATCH --output=out_qc_spades_%j.out
#SBATCH --error=err_qc_spades_%j.err
#SBATCH --time=06:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --nodelist=fremen

#paths
DATA_DIR="/hpc/users/s204637/data/assemblies"
OUT_DIR="/hpc/users/s204637/03_spades/report_qc_assemblies"

#files
files=("$DATA_DIR"/*/contigs.fasta)

#preparation
mkdir -p "$OUT_DIR"

echo " ------------ Quality Control of SPAdes using seqkit stats ----------------"

#check if files exist
if [ ! -e "${files[0]}" ]; then
	echo "No contigs file found."
	exit 1
fi

#run when file exists
seqkit stats -a -T \
	--threads 8 \
	"${files[@]}" \
	> "${OUT_DIR}/assembly_stats.tsv"


echo "---------------- Assembly QC done ------------------------"


#change names in file (awk) from path to run_acc
#tab seperated file
awk -F'\t' '
BEGIN { OFS="\t" }
NR==1 { print; next }
{
	n=split($1,a,"/")
	$1=a[n-1]
	print
}' "$OUT_DIR/assembly_stats.tsv" \
> "$OUT_DIR/assembly_stats_clean.tsv"


echo "---------------- changed names from path to run_acc -------"






