# prep_ref_panels_sumstats
Prepare GWAS Reference Panels and Summary Statistics for various analyses, including polygenic risk scoring

Step 1

```
cd ~/code && git clone https://github.com/gblokland/prep_ref_panels_sumstats.git 
mv prep_ref_panels_sumstats/*.sh ./
mv prep_ref_panels_sumstats/*.py ./
rm -r prep_ref_panels_sumstats
chmod +x *.sh *.py
./create_1000G_EUR_ref.tsv.sh
```

Step 2

Download GWAS summary statistics into ~/sumstats, using the 3 download_*.sh scripts.

```
./download_consortia_sumstats.sh
./download_FinnGen_sumstats.sh
./download_sumstats_from_ftp_epi.sh
./download_sumstats_from_gwas_catalog_ftp.sh

```

Step 3

Edit script call_clean_gwas_sumstats.sh

Step 4

```
./call_clean_gwas_sumstats.sh #This wrapper script calls the functions in clean_gwas_sumstats.py
```
