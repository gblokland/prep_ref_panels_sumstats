#!/bin/bash

python clean_gwas_sumstats.py \
    --input gwas_raw.txt.gz \
    --reference_maf 1000G_EUR_ref.tsv \
    --liftover_chain hg19ToHg38.over.chain.gz \
    --output gwas_clean.tsv \
    --gzip_output \
    --logfile gwas_clean.log

python clean_gwas_summstats.py \
    --input PGC_SCZ_sumstats.tar.gz \
    --reference_maf 1000G_EUR_ref.tsv \
    --output PGC_SCZ_clean.tsv \
    --gzip_output \
    --logfile PGC_SCZ_clean.log