#!/bin/bash

python clean_gwas_sumstats.py \
    --input /root/persistent/sumstats/phenotype_category/gwas_raw.txt.gz \
    --reference_maf /root/persistent/ref_panels/1KGPref/1000G_EUR_ref.tsv \
    --liftover_chain /root/persistent/ref_panels/hg19ToHg38.over.chain.gz \
    --output /root/persistent/sumstats_harmonized/gwas_clean.tsv \
    --gzip_output \
    --logfile /root/persistent/sumstats_harmonized/gwas_clean.log

python clean_gwas_summstats.py \
    --input /root/persistent/sumstats/phenotype_category/PGC_SCZ_sumstats.tar.gz \
    --reference_maf /root/persistent/ref_panels/1KGPref/1000G_EUR_ref.tsv \
    --output /root/persistent/sumstats_harmonized/PGC_SCZ_clean.tsv \
    --gzip_output \
    --logfile /root/persistent/sumstats_harmonized/PGC_SCZ_clean.log
