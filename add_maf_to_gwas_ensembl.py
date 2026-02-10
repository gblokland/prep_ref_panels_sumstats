#!/usr/bin/env python3
"""
add_maf_to_gwas_ensembl.py
Adds minor allele frequency (MAF) to a GWAS summary statistics file
using Ensembl REST API (1000 Genomes populations).
"""

import pandas as pd
import argparse
import requests
import time

ENSEMBL_REST = "https://rest.ensembl.org/variation/human/"

def get_maf_ensembl(snp, population):
    url = f"{ENSEMBL_REST}{snp}?population_genotypes=1"
    headers = {"Content-Type": "application/json"}
    try:
        r = requests.get(url, headers=headers)
        if not r.ok:
            return None
        data = r.json()
        for pop in data.get("population_genotypes", []):
            if pop["population"] == population:
                return pop.get("frequency")
    except Exception as e:
        print(f"Error fetching {snp}: {e}")
    return None

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("gwas_file", help="GWAS summary stats TSV file")
    parser.add_argument("output_file", help="Output TSV file with MAF added")
    parser.add_argument("--snp_col", default="SNP", help="SNP ID column")
    parser.add_argument("--population", default="1000GENOMES:phase_3:EUR", help="Population ID")
    args = parser.parse_args()

    df = pd.read_csv(args.gwas_file, sep="\t")
    mafs = []
    for snp in df[args.snp_col]:
        maf = get_maf_ensembl(snp, args.population)
        mafs.append(maf)
        time.sleep(0.1)  # avoid hitting Ensembl rate limits

    df["MAF"] = mafs
    df.to_csv(args.output_file, sep="\t", index=False)
    print(f"MAF added for {len(mafs)} SNPs. Output saved to {args.output_file}")

if __name__ == "__main__":
    main()

