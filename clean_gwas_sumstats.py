#!/usr/bin/env python3
"""
clean_gwas_sumstats.py
---------------------
Comprehensive pipeline to clean and harmonize GWAS summary statistics.

Features:
  ✅ Auto-decompression of .gz/.zip/.bz2/.xz input
  ✅ Optional gzip re-compression of output (--gzip_output)
  ✅ Standardized column names
  ✅ Inference of missing BETA, SE, OR, Z
  ✅ Infers SNP IDs from CHR:BP:A1:A2 or CHR:BP
  ✅ Flips alleles to reference strand
  ✅ Liftover genome build via pyliftover
  ✅ Fills missing MAF from reference
  ✅ Detailed logging summary

Example:
    python clean_gwas_sumstats.py \
        --input gwas_raw.txt.gz \
        --reference_maf 1000G_EUR_ref.tsv \
        --liftover_chain hg19ToHg38.over.chain.gz \
        --output gwas_clean.tsv \
        --gzip_output \
        --logfile gwas_clean.log
"""

import argparse
import pandas as pd
import numpy as np
import os
import sys
import tempfile
import gzip
import zipfile
import bz2
import lzma
import shutil
import tarfile

try:
    from pyliftover import LiftOver
except ImportError:
    LiftOver = None


# ------------------------------------------------------------
# Helper: Decompress input file if needed
# ------------------------------------------------------------
import tarfile

def decompress_if_needed(filepath):
    ext = filepath.lower()
    tmpdir = tempfile.mkdtemp()
    tmpfile = os.path.join(tmpdir, "sumstats.txt")

    # --- Gzip ---
    if ext.endswith((".gz", ".gzip")) and not ext.endswith((".tar.gz", ".tgz")):
        print(f"Decompressing gzip file: {filepath}")
        with gzip.open(filepath, "rb") as f_in, open(tmpfile, "wb") as f_out:
            shutil.copyfileobj(f_in, f_out)
        return tmpfile, tmpdir

    # --- Tarballs (.tar, .tar.gz, .tgz, .tar.bz2, .tar.xz) ---
    elif ext.endswith((".tar.gz", ".tgz", ".tar.bz2", ".tar.xz", ".tar")):
        print(f"Extracting tar archive: {filepath}")
        with tarfile.open(filepath, "r:*") as tar:
            members = [m for m in tar.getmembers() if not m.isdir()]
            if not members:
                sys.exit(f"No files found inside tar archive: {filepath}")
            # pick first .txt, .tsv, or .csv file
            preferred = [m for m in members if m.name.endswith((".txt", ".tsv", ".csv"))]
            chosen = preferred[0] if preferred else members[0]
            print(f"Using {chosen.name} from tar archive")
            tar.extract(chosen, tmpdir)
            extracted_path = os.path.join(tmpdir, chosen.name)
            return extracted_path, tmpdir

    # --- Zip ---
    elif ext.endswith(".zip"):
        print(f"Extracting zip file: {filepath}")
        with zipfile.ZipFile(filepath, "r") as z:
            names = z.namelist()
            if len(names) != 1:
                print(f"Warning: zip archive contains {len(names)} files; using first: {names[0]}")
            z.extract(names[0], tmpdir)
            return os.path.join(tmpdir, names[0]), tmpdir

    # --- Bzip2 ---
    elif ext.endswith(".bz2"):
        print(f"Decompressing bzip2 file: {filepath}")
        with bz2.open(filepath, "rb") as f_in, open(tmpfile, "wb") as f_out:
            shutil.copyfileobj(f_in, f_out)
        return tmpfile, tmpdir

    # --- XZ ---
    elif ext.endswith(".xz"):
        print(f"Decompressing xz file: {filepath}")
        with lzma.open(filepath, "rb") as f_in, open(tmpfile, "wb") as f_out:
            shutil.copyfileobj(f_in, f_out)
        return tmpfile, tmpdir

    else:
        return filepath, None



# ------------------------------------------------------------
# Column mappings
# ------------------------------------------------------------
COLUMN_MAP = {
    'snp': 'SNP', 'rsid': 'SNP', 'rs_id': 'SNP', 'markername': 'SNP',
    'chr': 'CHR', 'chrom': 'CHR', 'chromosome': 'CHR',
    'bp': 'BP', 'pos': 'BP', 'position': 'BP',
    'effect_allele': 'A1', 'allele1': 'A1', 'a1': 'A1', 'alt': 'A1', 'alt_allele': 'A1',
    'other_allele': 'A2', 'allele2': 'A2', 'a2': 'A2', 'ref': 'A2', 'ref_allele': 'A2',
    'beta': 'BETA', 'effect': 'BETA',
    'or': 'OR', 'oddsratio': 'OR',
    'std_err': 'SE', 'stderr': 'SE', 'se': 'SE',
    'p': 'P', 'pval': 'P', 'pvalue': 'P',
    'maf': 'MAF', 'freq': 'MAF', 'eaf': 'MAF', 'af': 'MAF',
    'n': 'N', 'samplesize': 'N',
    'z': 'Z', 'zscore': 'Z'
}


def standardize_columns(df):
    rename_dict = {}
    for col in df.columns:
        key = col.lower().strip()
        if key in COLUMN_MAP:
            rename_dict[col] = COLUMN_MAP[key]
    df = df.rename(columns=rename_dict)
    return df


# ------------------------------------------------------------
# Missing-value inference
# ------------------------------------------------------------
def compute_missing(df):
    if "Z" not in df.columns:
        if "BETA" in df.columns and "SE" in df.columns:
            df["Z"] = df["BETA"] / df["SE"]
        elif "OR" in df.columns and "SE" in df.columns:
            df["Z"] = np.log(df["OR"]) / df["SE"]

    if "SE" not in df.columns and "BETA" in df.columns and "Z" in df.columns:
        df["SE"] = df["BETA"] / df["Z"]

    if "BETA" not in df.columns and "OR" in df.columns:
        df["BETA"] = np.log(df["OR"])

    if "OR" not in df.columns and "BETA" in df.columns:
        df["OR"] = np.exp(df["BETA"])
    return df


# ------------------------------------------------------------
# Fill missing MAF from reference
# ------------------------------------------------------------
def fill_maf(df, ref_path):
    ref = pd.read_csv(ref_path, sep=None, engine="python")
    ref.columns = [c.upper() for c in ref.columns]
    if not {'SNP', 'MAF'}.issubset(ref.columns):
        sys.exit("Reference file must have 'SNP' and 'MAF' columns.")
    df = df.merge(ref[['SNP', 'MAF']], on='SNP', how='left', suffixes=('', '_ref'))
    df['MAF'] = df['MAF'].fillna(df['MAF_ref'])
    df.drop(columns=['MAF_ref'], inplace=True)
    return df


# ------------------------------------------------------------
# Infer SNP IDs from CHR:BP or CHR:BP:A1:A2
# ------------------------------------------------------------
def infer_snp_ids(df):
    if "SNP" not in df.columns or df["SNP"].isna().all():
        if {'CHR', 'BP', 'A1', 'A2'}.issubset(df.columns):
            df["SNP"] = df["CHR"].astype(str) + ":" + df["BP"].astype(str) + ":" + df["A1"].astype(str) + ":" + df["A2"].astype(str)
        elif {'CHR', 'BP'}.issubset(df.columns):
            df["SNP"] = df["CHR"].astype(str) + ":" + df["BP"].astype(str)
        print(f"Inferred SNP IDs for {df['SNP'].notna().sum()} variants.")
    return df


# ------------------------------------------------------------
# Liftover positions between genome builds
# ------------------------------------------------------------
def liftover_positions(df, chain_file):
    if LiftOver is None:
        sys.exit("pyliftover not installed. Install via: pip install pyliftover")
    lo = LiftOver(chain_file)
    new_bp = []
    for _, row in df.iterrows():
        try:
            newpos = lo.convert_coordinate(str(row['CHR']).replace('chr', ''), int(row['BP']))
            if newpos:
                new_bp.append(int(newpos[0][1]))
            else:
                new_bp.append(np.nan)
        except Exception:
            new_bp.append(np.nan)
    df["BP"] = new_bp
    print(f"LiftOver: updated positions for {df['BP'].notna().sum()} variants.")
    return df


# ------------------------------------------------------------
# Flip alleles to reference strand
# ------------------------------------------------------------
def flip_alleles(df, ref_path):
    ref = pd.read_csv(ref_path, sep=None, engine="python")
    ref.columns = [c.upper() for c in ref.columns]
    if not {'SNP', 'A1', 'A2'}.issubset(ref.columns):
        sys.exit("Reference allele file must have SNP, A1, and A2 columns.")
    merged = df.merge(ref[['SNP', 'A1', 'A2']], on='SNP', how='left', suffixes=('', '_ref'))
    flipped = (merged['A1'] == merged['A2_ref']) & (merged['A2'] == merged['A1_ref'])
    n_flip = flipped.sum()
    merged.loc[flipped, ['A1', 'A2']] = merged.loc[flipped, ['A2', 'A1']].values
    if 'BETA' in merged.columns:
        merged.loc[flipped, 'BETA'] = -merged.loc[flipped, 'BETA']
    print(f"Flipped alleles for {n_flip} SNPs to match reference strand.")
    return merged.drop(columns=['A1_ref', 'A2_ref'])


# ------------------------------------------------------------
# Log summary
# ------------------------------------------------------------
def log_summary(df, log_path, detected_cols):
    with open(log_path, "w") as f:
        f.write("### GWAS Summary Cleaning Log ###\n\n")
        f.write("Detected Columns:\n")
        for c in detected_cols:
            f.write(f" - {c}\n")
        f.write("\nMissingness summary:\n")
        miss = df.isna().mean().round(3)
        f.write(str(miss) + "\n")
        f.write(f"\nFinal variants retained: {len(df)}\n")
    print(f"Log written to {log_path}")


# ------------------------------------------------------------
# Main pipeline
# ------------------------------------------------------------
def main():
    parser = argparse.ArgumentParser(description="Clean and harmonize GWAS summary statistics.")
    parser.add_argument("--input", required=True, help="Input summary statistics file (can be compressed).")
    parser.add_argument("--reference_maf", help="Reference file for MAF and alleles (with SNP, A1, A2, MAF).")
    parser.add_argument("--liftover_chain", help="Chain file for liftover (e.g., hg19ToHg38.over.chain.gz).")
    parser.add_argument("--output", required=True, help="Output cleaned file.")
    parser.add_argument("--gzip_output", action="store_true", help="Compress output using gzip.")
    parser.add_argument("--logfile", default="cleaning.log", help="Path to log file.")
    args = parser.parse_args()

    infile, tmpdir = decompress_if_needed(args.input)
    print(f"Reading {infile} ...")
    df = pd.read_csv(infile, sep=None, engine="python", dtype=str)
    if tmpdir:
        shutil.rmtree(tmpdir, ignore_errors=True)
    print(f"Loaded {len(df)} variants.")

    detected_cols = df.columns.tolist()
    df = standardize_columns(df)

    for col in ["CHR", "BP"]:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")
    for col in ["BETA", "SE", "OR", "Z", "P", "MAF", "N"]:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")

    df = infer_snp_ids(df)
    df = compute_missing(df)

    if args.liftover_chain:
        df = liftover_positions(df, args.liftover_chain)
    if args.reference_maf:
        df = fill_maf(df, args.reference_maf)
        df = flip_alleles(df, args.reference_maf)

    keepcols = [c for c in ["SNP", "CHR", "BP", "A1", "A2", "BETA", "SE", "OR", "Z", "P", "MAF", "N"] if c in df.columns]
    df = df[keepcols].dropna(subset=["SNP", "A1", "A2", "P"], how="any")

    # Output
    if args.gzip_output:
        out_path = args.output if args.output.endswith(".gz") else args.output + ".gz"
        print(f"Writing compressed output: {out_path}")
        with gzip.open(out_path, "wt") as f:
            df.to_csv(f, sep="\t", index=False)
    else:
        print(f"Writing output: {args.output}")
        df.to_csv(args.output, sep="\t", index=False)

    log_summary(df, args.logfile, detected_cols)
    print("Done.")


if __name__ == "__main__":
    main()
