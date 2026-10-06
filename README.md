# phylogenomic_clustering
Phylogenomic SNP clustering analysis

## Purpose
Analyse phylogenic tree clusters for _Listeria monocytogenes_ (listeria) isolates from denmark which includes available metadata. It is done using bioinformatic pipelines to process raw fastq sequences and perform variant calling on them to find variants and cluster them accoring to SNP differences in a phylogenetic tree. From here, metadata relating to the origin of the isolate is added and (type) of sampling is used to see if anything can be infered. 

One area of interrest is clinical vs. non-clinical isolates with respect to possible pathogenicity, comparison of origins: unknown origin or other and overall clustering patterns. 


## Data
The data consists of danish listeria isolates from whole genome sequencing (WGS) sequenced by Illumina NextSeq., which produces raw FASTQ files with paired end (PE)Ilumina short reads. 

It is a subsample of the data used in project: PRJEB56155 (https://www.ebi.ac.uk/ena/browser/view/PRJEB56155) belonging to DTU, which originally included data from multiple countries. 
It is available from the European Nucleotide Archive (ENA), where it can be downloaded using fastp_ftp downloadlinks. 

#### Metadata 
- something about the metadata spreadsheet and how we selected the acc.
    - skip how to get the metadata for now

The metadata was then filtered for samples taken in Denmark, which resulted in 104 isolates that subsecuencly was downloaded from ENA. 

#### Analysis where details
The bioinformatic pipeline was performed was done on DTU's HPC clusters using batch scripts running through all isolates. 

## Download data
The download process runs over all requested accession numbers (ACCs), which can be found in acc.txt (https://github.com/PernilleRenkwitz/phylogenomic_clustering/blob/main/data/acc.txt) and downloads the data using 3 overall steps:
1. Read (link to acc.txt) to get acc
2. get ENA fastq_ftp and run acc (CHECK THIS TEXT AGAIN LATER)
3. Download data using fastq_ftp and save PE FASTQ files with run acc (used before?) as name

#### 1. Read ACCs
The ACCs from Denmark selected as part of the subsample from ref(insert link) have been saved as a text file: acc.txt (insert link to gitfile), which contain one ACC and sometimes a metadata (name?) per newline. 
This files is then read 
(code segment here for while read loop start)

#### 2. ENA run accesssion and fastq_ftp links




## Clean data
The raw dastq files have been cleaned using fastp, since it performs pre-processing and quality control and is designed for (insert data type description). This type of data has some known issues which needs to be adressed using specific settings. 

like polyG tails, which stem from the 2-channel chemistry (insert source), and 
- Removing adapters
- Trim for low quality bases in 5' and 3' 
- PolyG tail removal
- correcting mismatching bases

### fastp 
fastp functions does pre-processing and quality control one-in-all and includes a lot of functions automatically for RE short read Illumina NextSeq data but some settings need to be specified. I'll shortly go over the default settings first and then explain the specific parameters used to cover specifics for the commonly seen known issues for this data type. 

#### Default parameters
- Length filtering
- Sliding window size 
- Q scores needed

#### Issue #X
- detect_adapter_for_pe
fastp performs adapter trimming automaticly for single end (SE) data and not for PE data, so this was enabled with `--detect_adapter_for_pe_` to ensure most adapters are removed. 

## SPAdes de novo Assembly
- for isolates
- PE 


## MLST
- might be good because of error in spread sheet 
- clonal complexes (CC)


