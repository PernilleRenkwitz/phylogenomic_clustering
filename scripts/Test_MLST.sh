#!/usr/bin/env bash
#SBATCH --job-name=MLST_CC
#SBATCH --time=00:15:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --output=MLST_CC_%j.log

set -Eeuo pipefail

GENOME="$1"
OUT="${GENOME%.*}_MLST_CC.tsv"

MLST_DIR="/hpc/users/s204637/04_mlst/MLST"
PROFILE="${MLST_DIR}/BIGSdb_997543_9092596014_53335.txt"

LOCI=(abcZ bglA cat dapE dat ldh lhkA)

module load BLAST/2.11.0-Linux_x86_64


# Identify MLST alleles
ALLELES=()

for LOCUS in "${LOCI[@]}"; do

    HIT="$(
        blastn \
            -query "${MLST_DIR}/${LOCUS}.fas" \
            -subject "${GENOME}" \
            -task blastn \
            -dust no \
            -num_threads "${SLURM_CPUS_PER_TASK}" \
            -outfmt '6 qseqid pident length qlen mismatch gaps' |
        awk '$2 == 100 && $3 == $4 && $5 == 0 && $6 == 0 {
            print $1
            exit
        }'
    )"

    if [[ "${HIT}" =~ ([0-9]+)$ ]]; then
        ALLELES+=("${BASH_REMATCH[1]}")
    else
        ALLELES+=("NA")
    fi

done


# Match allele profile to ST, CC and Lineage
awk -F '\t' -v OFS='\t' \
    -v sample="$(basename "${GENOME}")" \
    -v alleles="${ALLELES[*]}" '
BEGIN {
    split(alleles, a, " ")
    ST = CC = lineage = "NA"

    print "sample", "abcZ", "bglA", "cat", "dapE",
          "dat", "ldh", "lhkA", "ST", "CC", "Lineage"
}

NR == 1 {
    for (i = 1; i <= NF; i++)
        col[$i] = i
    next
}

{
    match_profile = 1

    loci[1] = "abcZ"
    loci[2] = "bglA"
    loci[3] = "cat"
    loci[4] = "dapE"
    loci[5] = "dat"
    loci[6] = "ldh"
    loci[7] = "lhkA"

    for (i = 1; i <= 7; i++) {
        if (a[i] == "NA" || $(col[loci[i]]) != a[i]) {
            match_profile = 0
            break
        }
    }

    if (match_profile) {
        ST = $(col["ST"])
        CC = $(col["CC"])
        lineage = $(col["Lineage"])
        exit
    }
}

END {
    print sample, a[1], a[2], a[3], a[4],
          a[5], a[6], a[7], ST, CC, lineage
}
' "${PROFILE}" > "${OUT}"
