#!/bin/bash

#Harmonizing formatting of GWAS summary statistics

#install a set op commonly used python libraries from the bash command line
cd ~/opt/
echo "
numpy
pandas
matplotlib
scikit-learn
seaborn
requests
flask
django
jupyterlab
pysam
" > python_requirements_shortlist.txt

pip install -r python_requirements_shortlist.txt

#Resources for semi-automatic QC and GWAS sumstats formatting:
#https://github.com/BioPsyk/cleansumstats 
#https://academic.oup.com/bioinformatics/article/28/3/444/189687
#https://github.com/precimed/python_convert
cd ~/opt/
git clone https://github.com/precimed/python_convert.git
cd python_convert/
chmod +x *.py
wget https://precimed.s3-eu-west-1.amazonaws.com/python_convert/2558411_ref.bim
wget https://precimed.s3-eu-west-1.amazonaws.com/python_convert/9279485_ref.bim
wget https://precimed.s3-eu-west-1.amazonaws.com/python_convert/b149_RsMergeArch.bcp.gz
wget https://precimed.s3-eu-west-1.amazonaws.com/python_convert/b149_SNPChrPosOnRef_105.bcp.gz
wget https://precimed.s3-eu-west-1.amazonaws.com/python_convert/b149_SNPHistory.bcp.gz
wget https://precimed.s3-eu-west-1.amazonaws.com/python_convert/hg18ToHg19.over.chain.gz
wget https://precimed.s3-eu-west-1.amazonaws.com/python_convert/ref_1kG_phase3_EUR.tar.gz
tar xzf ref_1kG_phase3_EUR.tar.gz



##################################################################################################
# Run harmonization
#usage: sumstats.py csv [-h] [--log LOG] [--log-append] [--sumstats SUMSTATS] [--out OUT] [--force] [--a1 A1] [--a1a2 A1A2]
#                       [--a2 A2] [--beta BETA] [--bp BP] [--chr CHR] [--chrpos CHRPOS] [--chrposa1a2 CHRPOSA1A2]
#                       [--direction DIRECTION] [--ea EA] [--frq FRQ] [--info INFO] [--logodds LOGODDS] [--n N]
#                       [--ncase NCASE] [--ncontrol NCONTROL] [--nstudy NSTUDY] [--or OR] [--orl95 ORL95] [--oru95 ORU95]
#                       [--pval PVAL] [--se SE] [--snp SNP] [--z Z] [--auto] [--ignore IGNORE [IGNORE ...]]
#                       [--chunksize CHUNKSIZE] [--head HEAD] [--preview PREVIEW] [--skip-validation] [--sep {,,;,       , }]
#                       [--na-values NA_VALUES [NA_VALUES ...]] [--all-snp-info-23-and-me ALL_SNP_INFO_23_AND_ME]
#                       [--qc-23-and-me] [--n-val N_VAL] [--ncase-val NCASE_VAL] [--ncontrol-val NCONTROL_VAL]
#                       [--header HEADER] [--keep-cols [KEEP_COLS [KEEP_COLS ...]]] [--keep-all-cols]
#                       [--output-cleansumstats-meta]
#only use --n-val if there is no N column

cd ~/sumstats/Neuro_AD/
gunzip PGCALZ2ExcludingUKBand23andME_METALInverseVariance_MetaAnalysis.txt.gz
python ~/opt/python_convert/sumstats.py csv \
--sumstats PGCALZ2ExcludingUKBand23andME_METALInverseVariance_MetaAnalysis.txt --sep ' ' --out Neuro_AD_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp SNPID --beta beta --se standard_error --pval p_value --frq effect_allele_frequency 

#gunzip GCST013196.tsv.gz
python ~/opt/python_convert/sumstats.py csv \
--sumstats GCST013196.tsv.gz --sep $'\t' --out Neuro_AD_sumstats2.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --beta beta --se standard_error --pval p_value --frq effect_allele_frequency 

cd ~/sumstats/Neuro_MCI/
gunzip PGCALZ2ExcludingUKBand23andME_METALInverseVariance_MetaAnalysis.txt.gz
python ~/opt/python_convert/sumstats.py csv \
--sumstats PGCALZ2ExcludingUKBand23andME_METALInverseVariance_MetaAnalysis.txt --sep ' ' --out Neuro_AD_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp SNPID --beta beta --se standard_error --pval p_value --frq effect_allele_frequency 

cd ~/sumstats/Neuro_VaD/
gunzip PGCALZ2ExcludingUKBand23andME_METALInverseVariance_MetaAnalysis.txt.gz
python ~/opt/python_convert/sumstats.py csv \
--sumstats PGCALZ2ExcludingUKBand23andME_METALInverseVariance_MetaAnalysis.txt --sep ' ' --out Neuro_AD_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp SNPID --beta beta --se standard_error --pval p_value --frq effect_allele_frequency 

##########

cd ~/sumstats/Psych_ADHD/
###CHR	SNP	BP	A1	A2	FRQ_A_19099	FRQ_U_34194	INFO	OR	SE	P	ngt	Direction	HetISqt	HetDf	HetPVa	Nca	Nco	Neff
###8	rs62513865	101592213	T	C	0.077	0.0731	0.955	1.05940	0.026	0.02651	0	-+++0-++-+-++-+++-+++++--++-+--+-	11.2	32	0.2846	19099	34194	22842.43
python ~/opt/python_convert/sumstats.py csv \
--sumstats ADHD2_Demontis2019/daner_adhd_meta_filtered_NA_iPSYCH23_PGC11_sigPCs_woSEX_2ell6sd_EUR_Neff_70.meta.gz \
--out Psych_ADHD2_Demontis2019_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP \
--beta beta --se standard_error --pval p_value --n-val 173480
###CHR SNP BP A1 A2 FRQ_A_38691 FRQ_U_186843 INFO OR SE P Direction Nca Nco
###8 rs62513865 101592213 C T 0.925 0.937 0.981 0.99631 0.0175 0.8325 +---+++0-++-+ 38691 186843
python ~/opt/python_convert/sumstats.py csv \
--sumstats ADHD3_Demontis2022/ADHD2022_iPSYCH_deCODE_PGC.meta.gz \
--out Psych_ADHD3_Demontis2022_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP \
--beta beta --se standard_error --pval p_value --n-val 173480
###SNP CHR BP A1 A2 Effect SE P
###rs2326918 6 130840091 A G -0.0103 0.0245 0.6731
python ~/opt/python_convert/sumstats.py csv \
--sumstats ADHDSexSpecific_Martin2018/META_PGC_iPSYCH_males.gz \
--out Psych_ADHDSexSpecific_Martin2018_sumstats_males.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP \
--beta beta --se standard_error --pval p_value --n-val 173480
###SNP CHR BP A1 A2 Effect SE P
###rs2326918 6 130840091 A G -0.0103 0.0245 0.6731
python ~/opt/python_convert/sumstats.py csv \
--sumstats ADHDSexSpecific_Martin2018/META_PGC_iPSYCH_females.gz \
--out Psych_ADHDSexSpecific_Martin2018_sumstats_females.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP \
--beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Psych_ASD/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out Psych_ASD_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out Psych_ASD_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Psych_ANX/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out Psych_ANX_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out Psych_ANX_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Psych_BIP/
python ~/opt/python_convert/sumstats.py csv \
--sumstats bip2024_eur_noUKB_no23andMe.gz \
--out Psych_BIP_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP \
--pval P --ncase Nca --ncontrol Nco --frq HRC_FRQ_A1
python ~/opt/python_convert/sumstats.py csv \
--sumstats bip2024_eur_noUKB_no23andMe.gz \
--out Psych_BIP_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP \
--pval P --ncase Nca --ncontrol Nco --frq HRC_FRQ_A1
python ~/opt/python_convert/sumstats.py csv \
--sumstats bip2024_eur_noUKB_no23andMe.gz \
--out Psych_BIP_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP \
--pval P --ncase Nca --ncontrol Nco --frq HRC_FRQ_A1

cd ~/sumstats/Psych_ED/
python ~/opt/python_convert/sumstats.py csv \
--sumstats bip2024_eur_noUKB_no23andMe.gz \
--out Psych_ED_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP \
--pval P --ncase Nca --ncontrol Nco --frq HRC_FRQ_A1

python ~/opt/python_convert/sumstats.py csv \
--sumstats bip2024_eur_noUKB_no23andMe.gz \
--out Psych_ED_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP \
--pval P --ncase Nca --ncontrol Nco --frq HRC_FRQ_A1

cd ~/sumstats/Psych_MDD/
python ~/opt/python_convert/sumstats.py csv \
--sumstats MDD3/pgc-mdd2025_no23andMe-noUKBB_eur_v3-49-24-11_formatted.tsv.gz \
--out Psych_MDD3_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp rsid \
--beta beta --se standard_error --pval p_value --ncase ncases --ncontrol ncontrols --frq effect_allele_frequency
python ~/opt/python_convert/sumstats.py csv \
--sumstats MDD4/pgc-mdd2025_no23andMe-noUKBB_eur_v3-49-24-11_formatted.tsv.gz \
--out Psych_MDD4_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp rsid \
--beta beta --se standard_error --pval p_value --ncase ncases --ncontrol ncontrols --frq effect_allele_frequency

cd ~/sumstats/Psych_OCD-TS/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out Psych_OCD_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out Psych_OCD_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Psych_PTSD/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out Psych_PTSD_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out Psych_PTSD_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Psych_SCZ/
python ~/opt/python_convert/sumstats.py csv \
--sumstats SCZ3_Trubetskoy2022-sumstats/PGC3_SCZ_wave3.european.autosome.public.v3.vcf.tsv.gz \
--out Psych_SCZ_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480
python ~/opt/python_convert/sumstats.py csv \
--sumstats SCZ3_Trubetskoy2022-sumstats/PGC3_SCZ_wave3.european.autosome.public.v3.vcf.tsv.gz \
--out Psych_SCZ_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Psych_SUD/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out Psych_SUD_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out Psych_SUD_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480

##########

cd ~/sumstats/Brain_Structure/ENIGMA2_subcortical/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA2_ICV_Combined_GenomeControlled_Jan23.tbl.gz \
--out BrainMRI_ICV_sumstats.tsv \
--force --auto --head 5 --chrpos CHR_BP_hg19b37 --a1 Effect_Allele --a2 Non_Effect_Allele --snp RSID \
--beta Effect_Beta --se StdErr --pval Pvalue --frq Freq_European_1000Genomes

cd ~/sumstats/Brain_Structure/ENIGMA2_subcortical/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA2_MeanAccumbens_Combined_GenomeControlled_Jan23.tbl.gz \
--out BrainMRI_Accumbens_sumstats.tsv \
--force --auto --head 5 --chrpos CHR_BP_hg19b37 --a1 Effect_Allele --a2 Non_Effect_Allele --snp RSID \
--beta Effect_Beta --se StdErr --pval Pvalue --frq Freq_European_1000Genomes

cd ~/sumstats/Brain_Structure/ENIGMA2_subcortical/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA2_MeanAmygdala_Combined_GenomeControlled_Jan23.tbl.gz \
--out BrainMRI_Amygdala_sumstats.tsv \
--force --auto --head 5 --chrpos CHR_BP_hg19b37 --a1 Effect_Allele --a2 Non_Effect_Allele --snp RSID \
--beta Effect_Beta --se StdErr --pval Pvalue --frq Freq_European_1000Genomes

cd ~/sumstats/Brain_Structure/ENIGMA2_subcortical/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA2_MeanCaudate_Combined_GenomeControlled_Jan23.tbl.gz \
--out BrainMRI_Caudate_sumstats.tsv \
--force --auto --head 5 --chrpos CHR_BP_hg19b37 --a1 Effect_Allele --a2 Non_Effect_Allele --snp RSID \
--beta Effect_Beta --se StdErr --pval Pvalue --frq Freq_European_1000Genomes

cd ~/sumstats/Brain_Structure/ENIGMA2_subcortical/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA2_MeanHippocampus_Combined_GenomeControlled_Jan23.tbl.gz \
--out BrainMRI_Hippocampus_sumstats.tsv \
--force --auto --head 5 --chrpos CHR_BP_hg19b37 --a1 Effect_Allele --a2 Non_Effect_Allele --snp RSID \
--beta Effect_Beta --se StdErr --pval Pvalue --frq Freq_European_1000Genomes

cd ~/sumstats/Brain_Structure/ENIGMA2_subcortical/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA2_MeanPallidum_Combined_GenomeControlled_Jan23.tbl.gz \
--out BrainMRI_Pallidum_sumstats.tsv \
--force --auto --head 5 --chrpos CHR_BP_hg19b37 --a1 Effect_Allele --a2 Non_Effect_Allele --snp RSID \
--beta Effect_Beta --se StdErr --pval Pvalue --frq Freq_European_1000Genomes

cd ~/sumstats/Brain_Structure/ENIGMA2_subcortical/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA2_MeanPutamen_Combined_GenomeControlled_Jan23.tbl.gz \
--out BrainMRI_Putamen_sumstats.tsv \
--force --auto --head 5 --chrpos CHR_BP_hg19b37 --a1 Effect_Allele --a2 Non_Effect_Allele --snp RSID \
--beta Effect_Beta --se StdErr --pval Pvalue --frq Freq_European_1000Genomes

cd ~/sumstats/Brain_Structure/ENIGMA2_subcortical/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA2_MeanThalamus_Combined_GenomeControlled_Jan23.tbl.gz \
--out BrainMRI_Thalamus_sumstats.tsv \
--force --auto --head 5 --chrpos CHR_BP_hg19b37 --a1 Effect_Allele --a2 Non_Effect_Allele --snp RSID \
--beta Effect_Beta --se StdErr --pval Pvalue --frq Freq_European_1000Genomes

##########

cd ~/sumstats/Brain_Structure/ENIGMA3_Global/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wo_Mean_Full_SurfArea_20190429.txt.gz \
--out BrainMRI_SA_GC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP \
--beta BETA1 --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_Global/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wo_Mean_Full_Thickness_20190429.txt.gz \
--out BrainMRI_CT_GC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP \
--beta BETA1 --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_Global_noGC/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wo_Mean_Full_SurfArea_20190429_noGC.txt.gz \
--out BrainMRI_SA_noGC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP \
--beta BETA --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_Global_noGC/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wo_Mean_Full_Thickness_20190429_noGC.txt.gz \
--out BrainMRI_CT_noGC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP \
--beta BETA --se SE --pval P --frq FREQ1

##########

for roi in bankssts caudalanteriorcingulate caudalmiddlefrontal cuneus entorhinal frontalpole fusiform inferiorparietal 
inferiortemporal insula isthmuscingulate lateraloccipital lateralorbitofrontal lingual medialorbitofrontal middletemporal paracentral parahippocampal parsopercularis parsorbitalis parstriangularis pericalcarine postcentral posteriorcingulate precentral precuneus rostralanteriorcingulate rostralmiddlefrontal superiorfrontal superiorparietal superiortemporal supramarginal temporalpole transversetemporal; do

cd ~/sumstats/Brain_Structure/ENIGMA3_withGlobal/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wSA_Mean_${roi}_surfavg_20190429.txt.gz \
--out BrainMRI_SA${roi}_wGlobal_GC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA1 --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_withGlobal/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wTHICK_Mean_${roi}_thickavg_20200522.txt.gz \
--out BrainMRI_CT${roi}_wGlobal_GC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA1 --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_withGlobal_noGC/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wSA_Mean_${roi}_surfavg_20190429_noGC.txt.gz \
--out BrainMRI_SA${roi}_wGlobal_noGC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA1 --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_withGlobal_noGC/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wTHICK_Mean_${roi}_thickavg_20200522_noGC.txt.gz \
--out BrainMRI_CT${roi}_wGlobal_noGC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA1 --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_withoutGlobal/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wo_Mean_${roi}_surfavg_20190429.txt.gz \
--out BrainMRI_SA${roi}_woGlobal_GC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA1 --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_withoutGlobal/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wo_Mean_${roi}_thickavg_20200522.txt.gz \
--out BrainMRI_CT${roi}_woGlobal_GC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA1 --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_withoutGlobal_noGC/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wo_Mean_${roi}_surfavg_20190429_noGC.txt.gz \
--out BrainMRI_SA${roi}_woGlobal_noGC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA1 --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_withoutGlobal_noGC/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wo_Mean_${roi}_thickavg_20200522_noGC.txt.gz \
--out BrainMRI_CT${roi}_woGlobal_noGC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA1 --se SE --pval P --frq FREQ1

done

##########

cd ~/sumstats/Cognition_IQ/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out Cognition_IQ_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Cognition_GCA/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out Cognition_GCA_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Cognition_fx/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out Cognition_fx_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480

:<<'COMMENTBLOCK'

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz \
--out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id \
--beta beta --se standard_error --pval p_value --n-val 173480

COMMENTBLOCK

##################################################################################################

:<<'COMMENTBLOCK'

cd ~/sumstats/Biomarkers/CRP/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 35459240-GCST90029070-EFO_0004458-Build37.f.tsv.gz --out CRP_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 575531
#UKB n=427367; CHARGE n = 148164; total n = 575531
###python $(python_convert)/sumstats.py mat --sumstats PGC_SCZ_2014.csv --out PGC_SCZ_2014.mat --ref 2558411_ref.bim --force


cd ~/sumstats/Biomarkers/lymphocyte/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004632-EFO_0007993-Build37.f.tsv.gz --out lymphocyte_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480


cd ~/sumstats/Biomarkers/granulocyte/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out granulocyte_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

COMMENTBLOCK

##################################################################################################

source prep_1KGPref_for_prs_pipeline.sh

#For PRScs: SNP	A1	A2	BETA	SE --> convert positional id to rsid if needed
for phenotype in Neuro_AD; do
:<<'COMMENTBLOCK'
    #this option is too slow:
    python ~/code/convert_snp_positionalid_to_rsid.py \
    ~/sumstats/${phenotype}/${phenotype}_sumstats_PRScs.tsv \
    ~/sumstats/${phenotype}/${phenotype}_sumstats_PRScs2.tsv 
COMMENTBLOCK
:<<'COMMENTBLOCK'
    python ~/code/convert_snp_positionalid_to_rsid_local_split.py \
    ~/sumstats/${phenotype}/${phenotype}_sumstats_PRScs.tsv \
    ~/sumstats/${phenotype}/${phenotype}_sumstats_PRScs2.tsv \
    ~/ref_panels/ensembl_grch37/    #homo_sapiens/
COMMENTBLOCK
:<<'COMMENTBLOCK'
    python ~/code/convert_snp_positionalid_to_rsid_local_2.py \
    --input ~/sumstats/${phenotype}/${phenotype}_sumstats_PRScs.tsv \
    --output ~/sumstats/${phenotype}/${phenotype}_sumstats_PRScs2.tsv \
    --vcf ~/ref_panels/ensembl_grch37/homo_sapiens/all_chromosomes.vcf.gz
COMMENTBLOCK
    ~/code/add_rsid_tool.py \
    -i ~/sumstats/${phenotype}/${phenotype}_sumstats.tsv \
    -o ~/sumstats/${phenotype}/${phenotype}_sumstats_with_rsid.tsv \
    -v ~/ref_panels/ensembl_grch37/
    #The following is now incorporated in the python script:
    #sed -i '1s/SNP/positionalID/' ~/sumstats/${phenotype}/${phenotype}_sumstats_with_rsid.tsv
    #sed -i '1s/rsID/SNP/' ~/sumstats/${phenotype}/${phenotype}_sumstats_with_rsid.tsv
done

#For PRScs: SNP	A1	A2	BETA	SE
for phenotype in Neuro_AD; do
    #awk '{print $1, $5, $6, $8, $9}' ~/sumstats/${phenotype}/${phenotype}_sumstats.tsv \
    #> ~/sumstats/${phenotype}/${phenotype}_sumstats_PRScs.tsv
    awk '{print $1, $6, $7, $9, $10}' ~/sumstats/${phenotype}/${phenotype}_sumstats_with_rsid.tsv \
    > ~/sumstats/${phenotype}/${phenotype}_sumstats_with_rsid_nodups.tsv
    awk '!seen[$1]++' ~/sumstats/${phenotype}/${phenotype}_sumstats_with_rsid_nodups.tsv \
    > ~/sumstats/${phenotype}/${phenotype}_sumstats_PRScs.tsv > ~/sumstats/${phenotype}/${phenotype}_sumstats_PRScs.tsv
    #Exclude APOE haplotype SNPs
    awk '$1 != "rs429358" && $1 != "rs7412" { print $0}' \
    ~/sumstats/${phenotype}/${phenotype}_sumstats_PRScs.tsv \
    > ~/sumstats/${phenotype}/${phenotype}_excl_APOE_sumstats_PRScs.tsv
    #Exclude APOE region +/- 1Mb
    python $HOME/code/remove_apoe_region.py --in ~/sumstats/${phenotype}/${phenotype}_sumstats_PRScs.tsv --out ~/sumstats/${phenotype}/${phenotype}_excl_APOE_region_sumstats_PRScs.tsv --chr_col CHR --bp_col BP --snp_col SNP --sep '\t'
    python $HOME/code/remove_apoe_region_by_rsID.py --sumstats_file ~/sumstats/${phenotype}/${phenotype}_sumstats_PRScs.tsv --mapping_file ~/ref_panels/rsid_chr_bp_map.tsv --output_file ~/sumstats/${phenotype}/${phenotype}_excl_APOE_region_sumstats_PRScs.tsv --sep1 $' ' --sep2 $'\t'

done

#For SBayesRC: 'SNP', 'A1', 'A2', 'Freq', 'b', 'se', 'p', 'N'
for phenotype in Neuro_AD; do
	#python ~/opt/convert_sumstats_to_cojo.py ~/sumstats/${phenotype}/${phenotype}_sumstats.tsv \
	python ~/opt/convert_sumstats_to_cojo.py ~/sumstats/${phenotype}/${phenotype}_sumstats_with_rsid.tsv \
	~/ref_panels/1KGPref/EUR_frequencies.frq.tsv \
	~/sumstats/${phenotype}/${phenotype}_sumstats_COJO.tsv
done

#OR to BETA conversion
for phenotype in Neuro_AD; do
	python ~/opt/OR_beta_conversion.py ~/sumstats/${phenotype}/${phenotype}_sumstats_OR.tsv \
	~/sumstats/${phenotype}/${phenotype}_sumstats_BETA.tsv
done

:<<'COMMENTBLOCK'
#For PRScs: SNP	A1	A2	BETA	SE
for phenotype in CRP lymphocyte granulocyte; do
	awk '{print $1, $5, $6, $8, $9}' ~/sumstats/Biomarkers/${phenotype}/${phenotype}_sumstats.tsv \
	> ~/sumstats/Biomarkers/${phenotype}/${phenotype}_sumstats_PRScs.tsv
done


#For SBayesRC: 'SNP', 'A1', 'A2', 'Freq', 'b', 'se', 'p', 'N'
for phenotype in CRP lymphocyte granulocyte; do
	python ~/opt/convert_sumstats_to_cojo.py ~/sumstats/Biomarkers/${phenotype}/${phenotype}_sumstats.tsv \
	~/ref_panels/1KGPref/EUR_frequencies.frq.tsv \
	~/sumstats/Biomarkers/${phenotype}/${phenotype}_sumstats_COJO.tsv
done

#OR to BETA conversion
for phenotype in CRP lymphocyte granulocyte; do
	python ~/opt/OR_beta_conversion.py ~/sumstats/Biomarkers/${phenotype}/${phenotype}_sumstats_OR.tsv \
	~/sumstats/Biomarkers/${phenotype}/${phenotype}_sumstats_BETA.tsv
done
COMMENTBLOCK

##Merge SNP info with frq file
#python ~/opt/merge_and_sort_files.py ~/ref_panels/1KGPref/merged_whole_genome_snps.tsv \
#~/ref_panels/1KGPref/EUR_frequencies.frq.tsv \
#~/ref_panels/1KGPref/EUR_frequencies.tsv



##################################################################################################
#The following scripts don't work yet
#  add_maf_to_sumstats(gwas_file, maf_file, output_file) 

:<<'COMMENTBLOCK'
gwas_file="~/sumstats/Biomarkers/CRP/CRP_sumstats.tsv"  # Path to your GWAS summary statistics file
maf_file='path_to_maf_file.txt'
output_file="~/sumstats/Biomarkers/CRP/CRP_sumstats_wMAF.tsv"  # Path to the output file

python ~/opt/add_maf_to_gwas_ensembl.py gwas_file output_file --snp_col SNP --population "1000GENOMES:phase_3:EUR"

python ~/opt/add_maf_to_gwas_ensembl.py ~/sumstats/Biomarkers/CRP/CRP_sumstats.tsv \
~/sumstats/Biomarkers/CRP/CRP_sumstats_wMAF.tsv --snp_col SNP --population "1000GENOMES:phase_3:EUR"

python ~/opt/add_maf_to_gwas.py ~/sumstats/Biomarkers/CRP/CRP_sumstats.tsv \
~/sumstats/Biomarkers/CRP/CRP_sumstats_wMAF.tsv \
--source vcf --vcf_file ~/ref_panels/1KGPref/merged_whole_genome.vcf.gz --snp_col SNP


python ~/opt/add_maf_to_sumstats_final.py ~/sumstats/Biomarkers/CRP/CRP_sumstats.tsv \
~/sumstats/Biomarkers/CRP/CRP_sumstats_wMAF.tsv \
--source vcf --vcf_file ~/ref_panels/1KGPref/merged_whole_genome.vcf.gz --snp_col SNP
COMMENTBLOCK
