#!/usr/bin/env python3
"""
add_maf_to_sumstats_final.py
Adds MAF to GWAS summary stats from a VCF reference.
Handles missing SNPs gracefully.
"""

import pandas as pd
import argparse
import pysam
from tqdm import tqdm

def get_maf_from_vcf(vcf_file, snp):
    try:
        vcf = pysam.VariantFile(vcf_file)
        for rec in vcf.fetch():
            if rec.id == snp:
                af = rec.info.get("AF")
                if af:
                    return min(af)
        return None
    except Exception as e:
        return None

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("gwas_file", help="GWAS summary stats TSV")
    parser.add_argument("output_file", help="Output TSV with MAF")
    parser.add_argument("--source", default="vcf", help="Source type")
    parser.add_argument("--vcf_file", help="Path to VCF")
    parser.add_argument("--snp_col", default="SNP", help="SNP ID column")
    args = parser.parse_args()

    df = pd.read_csv(args.gwas_file, sep="\t")
    mafs = []

    print(f"Fetching MAFs from {args.vcf_file}...")
    for snp in tqdm(df[args.snp_col], total=len(df)):
        maf = get_maf_from_vcf(args.vcf_file, snp)
        mafs.append(maf)

    df["MAF"] = mafs
    missing = df["MAF"].isnull().sum()
    print(f"MAF missing for {missing} SNPs")

    df.to_csv(args.output_file, sep="\t", index=False)
    print(f"Output saved to {args.output_file}")

if __name__ == "__main__":
    main()

