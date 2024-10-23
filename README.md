RNA seq data anslysis: downloading raw sequencing data, performing quality control, mapping, and analyzing differential expression using various bioinformatics tools.
# RNA-Seq Pipeline: 
![rnaseq_pipline](https://github.com/user-attachments/assets/213ad0a6-7fbf-4295-a6e5-e6914024248a)

### Step 1: Download Raw Data
1. **NCBI SRA**:
   - Go to [NCBI SRA](http://www.ncbi.nlm.nih.gov/sra?term=SRP028518).
   - Download the following samples:
     - Treated: SRR947912, SRR947911
     - Control: SRR947901, SRR947902

   Alternatively, you can download the FASTQ files directly from the **ENA**:
   - Visit [ENA](http://www.ebi.ac.uk/ena/submit/read-submission).

### Step 2: Download Reference Genome and GFF/GTF
- Visit [UCSC Genome Browser](https://genome.ucsc.edu/) and select the appropriate reference genome and annotation files (GFF/GTF) for your organism.

### Step 3: Install Required Software
1. **FastQC**:
   - Download from [FastQC](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/) or install via terminal:
     ```bash
     sudo apt-get install fastqc
     ```

2. **Cutadapt**:
   - Install via pip:
     ```bash
     sudo pip install cutadapt
     ```

### Step 4: Quality Control with FastQC
- Run FastQC on the downloaded FASTQ files:
  ```bash
  fastqc SRR947912.fastq SRR947911.fastq SRR947901.fastq SRR947902.fastq
  ```

### Step 5: Data Cleaning with Cutadapt (if necessary)
- If the FastQC results indicate poor quality, you may need to clean the data using Cutadapt:
  ```bash
  cutadapt -a AACCGGTT -o cutout_read1.fastq read1.fastq  # Example for trimming adapters
  cutadapt -q 10 -o cutout_read1.fastq read1.fastq  # Trimming low-quality ends
  ```

### Step 6: Mapping on Reference Genome
1. **Prepare the Reference Genome**:
   - Build the index for the genome:
     ```bash
     bowtie2-build genome.fa genome
     ```

2. **Map Reads with Tophat**:
   - For single-end reads:
     ```bash
     tophat2 -G gene.gtf genome SRR947912.fastq
     ```
   - For paired-end reads:
     ```bash
     tophat -r 250 --library-type fr-firststrand -o Tophat_SRX331525 -G gene.gtf genome R1.fastq R2.fastq
     ```

### Step 7: Cufflinks for Transcript Reconstruction
- Run Cufflinks on the accepted hits BAM file generated by Tophat:
  ```bash
  cufflinks --library-type fr-firststrand -o cufflinks_control1 -G gene.gtf Tophat_control1/accepted_hits.bam
  ```

### Step 8: Merge Transcripts and Differential Expression Analysis
1. **Merge Transcript Assemblies**:
   - Create an `assemblies.txt` file listing all Cufflinks output files:
     ```bash
     echo Cufflinks_control1/transcripts.gtf >> assemblies.txt
     echo Cufflinks_control2/transcripts.gtf >> assemblies.txt
     echo Cufflinks_treated1/transcripts.gtf >> assemblies.txt
     echo Cufflinks_treated2/transcripts.gtf >> assemblies.txt
     ```

2. **Merge Using Cuffmerge**:
   ```bash
   cuffmerge -o cuffmerge_out -s genome.fa assemblies.txt
   ```

3. **Identify Differentially Expressed Transcripts**:
   ```bash
   cuffdiff -o Cuffdiff_out -L Control,Treated -u cuffmerge_out/merged.gtf \
   Tophat_control1/accepted_hits.bam,Tophat_control2/accepted_hits.bam \
   Tophat_treated1/accepted_hits.bam,Tophat_treated2/accepted_hits.bam
   ```

### Step 9: Review Differential Expression Results
- The results will be found in the `Cuffdiff_out/` directory, particularly in the `gene_exp.diff` file, which summarizes the differential expression analysis.

