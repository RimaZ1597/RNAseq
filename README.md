![RNA-seq-based-transcriptome-analysis](https://github.com/user-attachments/assets/2be3c79f-3d3f-4fc0-8222-3e2d78c66f1a)

RNA seq data anslysis: downloading raw sequencing data, performing quality control, mapping, and analyzing differential expression using various bioinformatics tools.
# RNA-Seq Pipeline: 
![rnaseq_pipline](https://github.com/user-attachments/assets/213ad0a6-7fbf-4295-a6e5-e6914024248a)

### Step 1: Download Raw Data
1. **NCBI SRA**:
   - [NCBI SRA](http://www.ncbi.nlm.nih.gov/sra?term=SRP028518).
   - Downloaded Data:
     - Treated: SRR947912, SRR947911
     - Control: SRR947901, SRR947902

   Alternative Option **ENA**:
   - [ENA](http://www.ebi.ac.uk/ena/submit/read-submission).

### Step 2: Download Reference Genome and GFF/GTF
- [UCSC Genome Browser](https://genome.ucsc.edu/) and select the appropriate reference genome and annotation files (GFF/GTF) for your organism.

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

### DEGene_list

| GENES List           | log2FC    |
|----------------------|-----------|
| ADCY2                | 2.05903   |
| ANK3                 | 1.94077   |
| BRAF                 | 1.81269   |
| CACNA1C              | 1.63721   |
| CD47                 | 1.58002   |
| FSTL5                | 1.46532   |
| GRIN2A               | 1.40470   |
| KANSL3               | 1.19405   |
| LOC440300            | 1.13504   |
| LSM12                | 0.94086   |
| MEF2BNB-MEF2B        | 0.80679   |
| MYRF                 | 0.77111   |
| NISCH                | 0.76708   |
| OTUD7B               | 0.76063   |
| PABPC1L              | 0.72402   |
| RNU5E-1              | 0.68801   |
| RPS6KA2              | 0.68139   |
| SART1                | 0.62743   |
| SCN2A                | 0.60810   |
| SHANK2               | 0.60228   |
| SNAP23               | 0.58468   |
| SPTBN2               | 0.47516   |
| SRPK2                | 0.47127   |
| STK4                 | 0.46363   |
| THSD7A               | 0.41049   |
| TRANK1               | 0.34955   |
| XPNPEP1              | 0.19945   |
| ZCCHC2               | -0.47836  |
| C11orf80             | -0.49229  |
| CACNA1C-AS4          | -0.50319  |
| CSRNP3               | -0.50706  |
| EIF1AD               | -0.51653  |
| FER1L5               | -0.52421  |
| G6PC3                | -0.62841  |
| IFT57                | -0.64395  |
| KCNS1                | -0.65685  |
| LOC100505933         | -0.67612  |
| LOC388152            | -0.76105  |
| LRRC57               | -0.89122  |
| MEF2BNB              | -0.89422  |
| MRPS33               | -1.03935  |
| PUS7                 | -1.07966  |
| RNU5D-1              | -1.08913  |
| SHANK2-AS1           | -1.31352  |
| STAB1                | -1.85545  |
| TMEM258              | -2.21351  |
| TOMM34               | 2.05903   |
| VPS45                | 1.94077   |
| ACOT12               | 1.81269   |
| ADD3                 | 1.63721   |
| BANF1                | 1.58002   |
| CACNA1C-IT3          | 1.46532   |
| HAUS2                | 1.40470   |
| HDAC5                | 1.19405   |
| LMAN2L               | 1.13504   |
| LOC642423            | 0.94086   |
| MIR611               | 0.80679   |
| NT5DC2               | 0.77111   |
| PLEKHO1              | 0.76708   |
| RCE1                 | 0.76063   |
| RFXANK               | 0.72402   |
| STK4-AS1             | 0.68801   |
| TMEM178B             | 0.68139   |
| WFDC5                | 0.62743   |
| ASB16                | 0.60810   |
| CA14                 | 0.60228   |
| CATSPER1             | 0.58468   |
| DNM1P41              | 0.47516   |
| FADS1                | 0.47127   |
| KCNS1                | 0.46363   |
| LRFN4                | 0.41049   |
| MIR3127              | 0.34955   |
| NCAN                 | 0.19945   |
| PBRM1                | -0.47836  |
| PI3                  | -0.49229  |
| ANP32E               | -0.50319  |
| C17orf53             | -0.50706  |
| CNNM4                | -0.51653  |
| CST6                 | -0.52421  |
| FEN1                 | -0.62841  |
| GOLGA6L4             | -0.64395  |
| NR2C2AP              | -0.65685  |
| PC                   | -0.67612  |
| SMIM4                | -0.76105  |
| SSBP2                | -0.89122  |
| STARD9               | -0.89422  |
| STK4                 | -1.03935  |
| WFDC12               | -1.07966  |
| CNNM3                | -1.08913  |
| ANKRD23              | -1.31352  |
| WFDC5                | -1.85545  |
| WFDC12               | -2.21351  |
| APH1A                | -1.21351  |
| C1orf54              | -0.21351  |
| C1orf51              | 0.78649   |
| GAL3ST3              | 1.78649   |
| SF3B2                | 2.78649   |
| PACS1                | 3.78649   |
| KLC2                 | 4.78649   |
| RAB1B                | 5.78649   |
| CNIH2                | 1.40470   |
| YIF1A                | 1.19405   |
| TMEM151A             | 1.13504   |
| CD248                | 0.94086   |
| RIN1                 | 0.80679   |
| BRMS1                | 0.77111   |
| GNL3                 | 0.76708   |
| SNORD19              | 0.76063   |
| SNORD19B             | 0.72402   |
| SNORD69              | 0.68801   |
| GLT8D1               | 0.68139   |
| SPCS1                | 0.62743   |
| NEK4                 | 0.60810   |
| ITIH1                | 0.60228   |
| ITIH3                | 0.58468   |
| ITIH4                | 0.47516   |
| MUSTN1               | 0.47127   |
| TMEM110-MUSTN1       | 0.46363   |
| TMEM110              | 0.41049   |
| MIR1908              | 0.34955   |
| FADS2                | 0.19945   |
| FADS3                | -0.47836  |
| HAPLN4               | -0.49229  |
| TM6SF2               | -0.50319  |
| SUGP1                | -0.50706  |
| MAU2                 | -0.51653  |
| GATAD2A              | -0.52421  |
| TSSK6                | -0.62841  |
| NDUFA13              | -0.64395  |
| YJEFN3               | -0.65685  |
| CILP2                | -0.67612  |
| PBX4                 | -0.76105  |
| LPAR2                | -0.89122  |
| GMIP                 | -0.89422  |
| ATP13A1              | -1.03935  |
| ASB16-AS1            | -1.07966  |
| TMUB2                | -1.08913  |
| ATXN7L3              | -1.31352  |
| UBTF                 | -1.85545  |
| SLC4A1               | -2.21351  |
| GOLGA6L5             | 2.05903   |
| UBE2Q2P1             | 1.94077   |
| LOC100506874         | 1.81269   |
| ZSCAN2               | 1.63721   |
| SCAND2P              | 1.58002   |
| WDR73                | 1.46532   |
| NMB                  | 1.40470   |
| SEC11A               | 1.19405   |
| ZNF592               | 1.13504   |
| RPL6P3               | 0.94086   |
| STX12P               | 0.80679   |
| CERS2                | 0.77111   |
| CLU                  | 0.76708   |
| C14orf92             | 0.76063   |
| PSMB8                | 0.72402   |
| ATP1A4               | 0.68801   |
| GADD45B              | 0.68139   |
| CAPN2                | 0.62743   |
| RPL12                | 0.60810   |
| XIRP2                | 0.60228   |
| RPL31                | 0.58468   |
| NOL3                 | 0.47516   |
| NCL                  | 0.47127   |
| OTX1                 | 0.46363   |
| SP7                  | 0.41049   |
| HDAC1                | 0.34955   |
| SYNJ1                | 0.19945   |
| UBL3                 | -0.47836  |
| HSPB1                | -0.49229  |
| ANK3                 | -0.50319  |
| C17orf67             | -0.50706  |
| C12orf39             | -0.51653  |
| C4orf29              | -0.52421  |
| RPL23                | -0.62841  |
| NCOA3                | -0.64395  |
| GINS3                | -0.65685  |
| ST6GAL1              | -0.67612  |
| PPM1A                | -0.76105  |
| CDCA4                | -0.89122  |
| SRPK2                | -0.89422  |
| POLR1B               | -1.03935  |
| TRIP12               | -1.07966  |
| HNRNPA2B1            | -1.08913  |
| C20orf170            | -1.31352  |
| RRP1B                | -1.85545  |
| UPF1                 | -2.21351  |

## upregulated genes 

| **GENES List**       | **log2FC** |
|----------------------|------------|
| ADCY2                | 2.05903    |
| ANK3                 | 1.94077    |
| BRAF                 | 1.81269    |
| CACNA1C              | 1.63721    |
| CD47                 | 1.58002    |
| FSTL5                | 1.46532    |
| GRIN2A               | 1.40470    |
| KANSL3               | 1.19405    |
| LOC440300            | 1.13504    |
| LSM12                | 0.94086    |
| TOMM34               | 2.05903    |
| VPS45                | 1.94077    |
| ACOT12               | 1.81269    |
| ADD3                 | 1.63721    |
| BANF1                | 1.58002    |
| CACNA1C-IT3          | 1.46532    |
| HAUS2                | 1.40470    |
| HDAC5                | 1.19405    |
| LMAN2L               | 1.13504    |
| LOC642423            | 0.94086    |
| GAL3ST3              | 1.78649    |
| SF3B2                | 2.78649    |
| PACS1                | 3.78649    |
| KLC2                 | 4.78649    |
| RAB1B                | 5.78649    |
| CNIH2                | 1.40470    |
| YIF1A                | 1.19405    |
| TMEM151A             | 1.13504    |
| CD248                | 0.94086    |
| GOLGA6L5             | 2.05903    |
| UBE2Q2P1             | 1.94077    |
| LOC100506874         | 1.81269    |
| ZSCAN2               | 1.63721    |
| SCAND2P              | 1.58002    |
| WDR73                | 1.46532    |
| NMB                  | 1.40470    |
| SEC11A               | 1.19405    |
| ZNF592               | 1.13504    |
| ALPK3                | 0.94086    |

## downregulated genes

| **GENES List**       | **log2FC**   |
|----------------------|--------------|
| MRPS33               | -1.03935     |
| PUS7                 | -1.07966     |
| RNU5D-1              | -1.08913     |
| SHANK2-AS1           | -1.31352     |
| STAB1                | -1.85545     |
| TMEM258              | -2.21351     |
| STK4                 | -1.03935     |
| WFDC12               | -1.07966     |
| CNNM3                | -1.08913     |
| ANKRD23              | -1.31352     |
| WFDC5                | -1.85545     |
| WFDC12               | -2.21351     |
| APH1A                | -1.21351     |
| ATP13A1              | -1.03935     |
| ASB16-AS1            | -1.07966     |
| TMUB2                | -1.08913     |
| ATXN7L3              | -1.31352     |
| UBTF                 | -1.85545     |
| SLC4A1               | -2.21351     |

