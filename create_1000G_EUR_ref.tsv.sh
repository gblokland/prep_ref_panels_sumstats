#!/bin/bash

cd ~/persistent/ref_panels/

# Download 1000 Genomes Phase 3 PLINK files (b37/hg19)
for chr in {1..22}; do
  wget https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz
  wget https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz.tbi
done

wget https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrX.phase3_shapeit2_mvncall_integrated_v1c.20130502.genotypes.vcf.gz  
wget https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrX.phase3_shapeit2_mvncall_integrated_v1c.20130502.genotypes.vcf.gz.tbi   
wget https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrY.phase3_integrated_v2b.20130502.genotypes.vcf.gz   
wget https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrY.phase3_integrated_v2b.20130502.genotypes.vcf.gz.tbi

# Create list of European samples (optional)
wget https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/working/20130606_sample_info/20130606_sample_info.txt
awk -F '\t' 'NR>1 && ($3=="CEU" || $3=="FIN" || $3=="GBR" || $3=="IBS" || $3=="TSI") {print $1, $1}' \
  20130606_sample_info.txt > eur_samples.txt

# Convert VCFs to PLINK and compute allele frequencies
for chr in {1..22}; do
  plink \
    --vcf ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz \
    --keep eur_samples.txt \
    --freq \
    --out chr${chr}_EUR
done
  plink \
    --vcf ALL.chrX.phase3_shapeit2_mvncall_integrated_v1c.20130502.genotypes.vcf.gz \
    --keep eur_samples.txt \
    --freq \
    --out chrX_EUR
  plink \
    --vcf ALL.chrY.phase3_integrated_v2b.20130502.genotypes.vcf.gz \
    --keep eur_samples.txt \
    --freq \
    --out chrY_EUR

# Merge per-chromosome results and reformat
awk 'NR==1{print "SNP\tCHR\tBP\tA1\tA2\tMAF"} 
     FNR>1{print $2"\t"$1"\t"$3"\t"$5"\t"$6"\t"$5<=$6?$5:$6}' chr*_EUR.frq > 1000G_EUR_ref.tsv
