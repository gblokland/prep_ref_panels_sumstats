#!/usr/bin/env python3

import pandas as pd
import pysam
import argparse
from collections import defaultdict

def get_rsid(tabix, chrom, pos, ref, alt):
    try:
        records = tabix.fetch(str(chrom), int(pos) - 1, int(pos))
        for record in records:
            fields = record.strip().split('\t')
            vcf_pos = fields[1]
            rsid = fields[2]
            vcf_ref = fields[3]
            vcf_alts = fields[4].split(',')

            if vcf_pos == str(pos):
                if (vcf_ref == ref and alt in vcf_alts) or (vcf_ref == alt and ref in vcf_alts):
                    return rsid
    except Exception:
        pass
    return "NA"

def add_rsid_column(input_path, output_path, vcf_dir):
    df = pd.read_csv(input_path, sep="\t")
    snps = []
    positional_ids = []

    vcf_cache = defaultdict(lambda: None)

    for _, row in df.iterrows():
        chrom = str(row['CHR']).replace("chr", "")
        pos = row['BP']
        a1 = row['A1']
        a2 = row['A2']

        vcf_path = f"{vcf_dir}/homo_sapiens-chr{chrom}.vcf.gz"

        if vcf_cache[chrom] is None:
            try:
                vcf_cache[chrom] = pysam.TabixFile(vcf_path)
            except Exception as e:
                print(f"Error loading {vcf_path}: {e}")
                snps.append("NA")
                positional_ids.append(f"{chrom}:{pos}:{a1}:{a2}")
                continue

        tabix = vcf_cache[chrom]
        rsid = get_rsid(tabix, chrom, pos, a1, a2)
        snps.append(rsid)
        positional_ids.append(f"{chrom}:{pos}:{a1}:{a2}")

    df.insert(0, 'SNP', snps)
    df.insert(1, 'positionalID', positional_ids)

    df.to_csv(output_path, sep="\t", index=False)

    for tabix in vcf_cache.values():
        if tabix:
            tabix.close()

def main():
    parser = argparse.ArgumentParser(description="Add SNP and positionalID columns to summary stats using VCF files")
    parser.add_argument("-i", "--input", required=True, help="Input summary statistics file (TSV)")
    parser.add_argument("-o", "--output", required=True, help="Output file with SNP and positionalID columns")
    parser.add_argument("-v", "--vcfdir", required=True, help="Directory containing per-chromosome VCF.gz files")

    args = parser.parse_args()
    add_rsid_column(args.input, args.output, args.vcfdir)

if __name__ == "__main__":
    main()
