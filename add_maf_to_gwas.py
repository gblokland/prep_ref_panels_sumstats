#!/usr/bin/env python3
"""
add_maf_to_gwas.py
Adds minor allele frequency (MAF) to GWAS summary statistics
from a local VCF file using pysam/tabix.
"""

import pandas as pd
import argparse
import pysam

def get_maf_from_vcf(vcf_file, snp):
    try:
        vcf = pysam.VariantFile(vcf_file)
        for rec in vcf.fetch():
            if rec.id == snp:
                freqs = rec.info.get("AF")  # allele frequency in INFO field
                if freqs:
                    return min(freqs)  # minor allele freq
        return None
    except Exception as e:
        print(f"Error fetching {snp}: {e}")
        return None

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("gwas_file", help="GWAS summary stats TSV")
    parser.add_argument("output_file", help="Output TSV with MAF")
    parser.add_argument("--source", default="vcf", help="Data source")
    parser.add_argument("--vcf_file", help="VCF file path")
    parser.add_argument("--snp_col", default="SNP", help="SNP column name")
    args = parser.parse_args()

    df = pd.read_csv(args.gwas_file, sep="\t")
    mafs = []
    for snp in df[args.snp_col]:
        maf = get_maf_from_vcf(args.vcf_file, snp)
        mafs.append(maf)

    df["MAF"] = mafs
    df.to_csv(args.output_file, sep="\t", index=False)
    print(f"MAF added for {len(mafs)} SNPs. Output saved to {args.output_file}")

if __name__ == "__main__":
    main()

