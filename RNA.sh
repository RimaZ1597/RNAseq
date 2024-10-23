## pipeline for RNA seq. ##
# STEP1: To check the quality of raw data: fastqc

fastqc *.fastqc

# Parameters to focus on fastqc repoort:
#a) per base sequence quality:
#b) overrepresented sequences:
#c) adapter content:

# STEP2: Trimming and cleaning of data: cutadapt

#for single end data:

cutadapt -b TGCATGAAAGTGAAAGGTGAAAGTGAAGTTGCTCAGTCGTGC -q 30,30 -m 20 -o trim_control1.fastq control1.fastq

cutadapt -b TGCATGAAAGTGAAAGGTGAAAGTGAAGTTGCTCAGTCGTGC -q 30,30 -m 20 -o
trim_control2.fastq control2.fastq


# for paired end data:

cutadapt -b xyz_F.fastq -B xyz_R.fastq -q 30,30 -m 20 -o trim_f.fastq -p trim_R.fastq f.fastq R.fastq

# step3: Recheck the quality of raw data: fastqc

fastqc trim_control1.fastq trim_control2.fastq

# step4: mapping of data with reference genome:
#a) Indexing of genome seq:bowtie2

bowtie2-build genome.fa genome

#b) Mapping of data with reference indexed genome:tophat2

tophat2 -o tophat_control1.fastq -G bos_tau_chr1.gtf genome control1.fastq

tophat2 -o tophat_control2.fastq -G bos_tau_chr1.gtf genome control2.fastq

tophat2 -o tophat_Treated1.fastq -G bos_tau_chr1.gtf genome Treated1.fastq

tophat2 -o tophat_Treated2.fastq -G bos_tau_chr1.gtf genome Treated2.fastq

# STEP5: Cufflinks: normalization of mapped data.

cufflinks -o cuufflinks_c1 -G bos_tau_chr1.gtf /home/rima/Desktop/RNA_seq/tophat_control1.fastq/accepted_hits.bam

cufflinks -o cuufflinks_c2 -G bos_tau_chr1.gtf /home/rima/Desktop/RNA_seq/tophat_control2.fastq/accepted_hits.bam

cufflinks -o cuufflinks_T1 -G bos_tau_chr1.gtf /home/rima/Desktop/RNA_seq/tophat_Treated1.fastq/accepted_hits.bam

cufflinks -o cuufflinks_T2 -G bos_tau_chr1.gtf /home/rima/Desktop/RNA_seq/tophat_Treated2.fastq/accepted_hits.bam

# STEP6: cuffmerge: it will merge all the tx. together.

gedit assemble.txt

cuffmerge -o cuffmerge_out -g bos_tau_chr1.gtf assemble.txt 

# STEP7: cuffdiff: we will get differemtial expression of genes. (T VS C)

cuffdiff -o cuffdiff_out -L control,Treated -u /home/rima/Desktop/RNA_seq/cuffmerge_out/merged.gtf /home/rima/Desktop/RNA_seq/tophat_control1.fastq/accepted_hits.bam,/home/rima/Desktop/RNA_seq/tophat_control2.fastq/accepted_hits.bam /home/rima/Desktop/RNA_seq/tophat_Treated1.fastq/accepted_hits.bam,/home/rima/Desktop/RNA_seq/tophat_Treated2.fastq/accepted_hits.bam 










