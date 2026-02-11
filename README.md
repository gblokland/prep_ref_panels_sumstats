# prep_ref_panels_sumstats
Prepare GWAS Reference Panels and Summary Statistics for various analyses, including polygenic risk scoring

Step 0

Download these scripts into the code directory.

```
cd ~/code && git clone https://github.com/gblokland/prep_ref_panels_sumstats.git 
mv prep_ref_panels_sumstats/*.sh ./
mv prep_ref_panels_sumstats/*.py ./
rm -r prep_ref_panels_sumstats
chmod +x *.sh *.py
```
Step 1

Prepare the reference files needed by the PRS pipeline.

```
./00_prep_1KGPref_for_prs_pipeline.sh
./00_create_1000G_EUR_ref.tsv.sh
./00_make_variant_map.sh
```

Step 2

Download GWAS summary statistics into ~/sumstats, using the appropriate download_*.sh script. You can add your own as well.

```
./download_consortia_sumstats.sh
./download_FinnGen_sumstats.sh
./download_sumstats_from_ftp_epi.sh

```

Step 3

Edit script call_clean_gwas_sumstats.sh

Step 4

```
./call_clean_gwas_sumstats.sh #This wrapper script calls the functions in clean_gwas_sumstats.py
```
