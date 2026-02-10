import pysam
import csv

def get_rsid(tabix, chrom, pos, ref, alt):
    try:
        records = tabix.fetch(str(chrom), int(pos) - 1, int(pos))
        for record in records:
            fields = record.strip().split('\t')
            vcf_pos = fields[1]
            rsid = fields[2]
            vcf_ref = fields[3]
            vcf_alts = fields[4].split(',')

            # Exact match
            if vcf_pos == str(pos) and vcf_ref == ref and alt in vcf_alts:
                return rsid

            # Allele flipped (e.g., A1=A2, A2=A1)
            if vcf_pos == str(pos) and vcf_ref == alt and ref in vcf_alts:
                return rsid  # flip match
    except Exception:
        pass
    return "NA"


def add_rsid_column(input_file, output_file, vcf_file):
    with pysam.TabixFile(vcf_file) as tabix, \
         open(input_file, 'r') as fin, \
         open(output_file, 'w', newline='') as fout:

        reader = csv.DictReader(fin, delimiter='\t')
        fieldnames = ['rsID'] + reader.fieldnames
        writer = csv.DictWriter(fout, fieldnames=fieldnames, delimiter='\t')
        writer.writeheader()

        for row in reader:
            chrom = str(row['CHR']).strip()
            pos = row['BP'].strip()
            ref = row['A1'].strip()
            alt = row['A2'].strip()
            rsid = get_rsid(tabix, chrom, pos, ref, alt)
            row['rsID'] = rsid
            writer.writerow(row)

# Run the function
if __name__ == "__main__":
    add_rsid_column("/notebooks/sumstats/Neuro_AD/Neuro_AD_sumstats.tsv", "/notebooks/sumstats/Neuro_AD/Neuro_AD_sumstats_with_rsid.tsv", "homo_sapiens-chr1.vcf.gz")
    #add_rsid_column("test_sumstats.tsv", "test_with_rsid.tsv", "homo_sapiens-chr1.vcf.gz")

