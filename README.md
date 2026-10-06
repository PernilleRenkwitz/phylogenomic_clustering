# phylogenomic_clustering
Phylogenomic SNP clustering analysis

## Purpose
Analyse phylogenic tree clusters for listeria isolates from denmark which includes available metadata. It is done using bioinformatic pipelines to process raw fastq sequences and perform variant calling on them to find variants and cluster them accoring to SNP differences in a phylogenetic tree, where metadata relating to the origin of the isolate and type of sampling is used to see if anything can be infered. 
One area of interrest is clinical vs. non-clinical isolates with respect to possible pathogenicity, comparison of origins: unknown origin or other and overall clustering patterns. 


## Data


It is L. monocytogenes isolates as paired end (PE) short reads extracted by whole genome sequencing (WGS) using Illumina. The PE short reads where sequenced on NextSeq 500. 

- Nextera XT Library Prep Kit has been used for sequencing libraries
- NextSeq 500 

- From ENA SRA database
- listeria ioslates from denmark
- PE reads
- metadata (create table to contain type of data)
- collected by? (look into)


## Download data
- steps
- where from 
- how to get acc
- 

## Clean data
The raw dastq files have been cleaned using fastp, since it performs preprocessing and quality control and is designed for (insert data type description). This type of data has some known issues which needs to be adressed using specific settings. 

####

like polyG tails, which stem from the 2-channel chemistry (insert source), and 
- Removing adapters
- Trim for low quality bases in 5' and 3' 
- PolyG tail removal
- correcting mismatching bases

### fastp 

Options selected: 

Default parameters not specifed: 
- Length filtering
- 

- detect_adapter_for_pe
fastp performs adapter trimming automaticly for single end (SE) data and not for PE data, so this was enabled with `--detect_adapter_for_pe_` to ensure most adapters are removed. 

## SPAdes de novo Assembly
- for isolates
- PE 

