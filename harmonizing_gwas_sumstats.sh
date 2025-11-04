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
# Download GWAS Summary Statistics

#Genetic Topography:

#PRS-ENIGMA-cortex: 34 + 34 (L + R) -> use avg
mkdir -p ~/sumstats/Brain_Structure && cd ~/sumstats/Brain_Structure/
#Complete ENIGMA3 Cortical Surface Area and Thickness Summary Statistics Access Request Form 
#These are the principal results (all European cohorts).
#Each file is ~200 MB in size and the results are split into folders.
#This folder has total SA and average TH with genomic control applied
wget -nH -r -np --cut-dirs=1 -e robots=off --reject="*index.html?*" https://enigma.ini.usc.edu/downloads/ENIGMA3_Global/
#This folder has total SA and average TH without genomic control applied
wget -nH -r -np --cut-dirs=1 -e robots=off --reject="*index.html?*" https://enigma.ini.usc.edu/downloads/ENIGMA3_Global_noGC/
#This folder has regional SA and TH that are adjusted for the respective global measures and with genomic control applied.
wget -nH -r -np --cut-dirs=1 -e robots=off --reject="*index.html?*" https://enigma.ini.usc.edu/downloads/ENIGMA3_withGlobal/
#reject files already downloaded based on pattern:
#wget -nH -r -np --cut-dirs=1 -e robots=off --reject="*index.html?*" https://enigma.ini.usc.edu/downloads/ENIGMA3_withGlobal/ -R *wSA*
#This folder has regional SA and TH that are adjusted for the respective global measures and without genomic control applied.
wget -nH -r -np --cut-dirs=1 -e robots=off --reject="*index.html?*" https://enigma.ini.usc.edu/downloads/ENIGMA3_withGlobal_noGC/
#wget -nH -r -np --cut-dirs=1 -e robots=off --reject="*index.html?*" https://enigma.ini.usc.edu/downloads/ENIGMA3_withGlobal_noGC/ -R *wTHICK* -A ENIGMA3_mixed_se_wSA_Mean_lateraloccipital_surfavg_20190429_noGC.txt.gz
#wget -nH https://enigma.ini.usc.edu/downloads/ENIGMA3_withGlobal_noGC/ENIGMA3_mixed_se_wSA_Mean_lateralorbitofrontal_surfavg_20200522_noGC.txt.gz
#This folder has regional SA and TH that are NOT adjusted for the respective global measures and with genomic control applied.
wget -nH -r -np --cut-dirs=1 -e robots=off --reject="*index.html?*" https://enigma.ini.usc.edu/downloads/ENIGMA3_withoutGlobal/
#This folder has regional SA and TH that are NOT adjusted for the respective global measures and without genomic control applied.
wget -nH -r -np --cut-dirs=1 -e robots=off --reject="*index.html?*" https://enigma.ini.usc.edu/downloads/ENIGMA3_withoutGlobal_noGC/
rm */*index.html?*
zcat ENIGMA3_mixed_se_wo_Mean_Full_SurfArea_20190429_noGC.txt.gz | head -n 2
#SNP A1 A2 FREQ1 BETA SE P N MARKER CHR BP
#rs28527770 t c 0.8564 499.4551 176.4673 0.00465 26324 1:751756 1 751756
zcat ENIGMA3_mixed_se_wSA_Mean_bankssts_surfavg_20190429.txt.gz | head -n 2
#SNP A1 A2 FREQ1 BETA1 SE P N MARKER CHR BP
#rs28527770 t c 0.8564 1.4212 1.4089 0.3131 24661 1:751756 1 751756

#Complete ENIGMA2 Subcortical Volumes Summary Statistics Access Request Form 
mkdir -p ~/sumstats/Brain_Structure/ENIGMA2_subcortical && cd ~/sumstats/Brain_Structure/ENIGMA2_subcortical/
wget -nH http://enigma.ini.usc.edu/wp-content/uploads/E2_EVIS/ENIGMA2_ICV_Combined_GenomeControlled_Jan23.tbl.gz
wget -nH http://enigma.ini.usc.edu/wp-content/uploads/E2_EVIS/ENIGMA2_MeanAccumbens_Combined_GenomeControlled_Jan23.tbl.gz
wget -nH http://enigma.ini.usc.edu/wp-content/uploads/E2_EVIS/ENIGMA2_MeanAmygdala_Combined_GenomeControlled_Jan23.tbl.gz
wget -nH http://enigma.ini.usc.edu/wp-content/uploads/E2_EVIS/ENIGMA2_MeanCaudate_Combined_GenomeControlled_Jan23.tbl.gz
wget -nH http://enigma.ini.usc.edu/wp-content/uploads/E2_EVIS/ENIGMA2_MeanHippocampus_Combined_GenomeControlled_Jan23.tbl.gz
wget -nH http://enigma.ini.usc.edu/wp-content/uploads/E2_EVIS/ENIGMA2_MeanPallidum_Combined_GenomeControlled_Jan23.tbl.gz
wget -nH http://enigma.ini.usc.edu/wp-content/uploads/E2_EVIS/ENIGMA2_MeanPutamen_Combined_GenomeControlled_Jan23.tbl.gz
wget -nH http://enigma.ini.usc.edu/wp-content/uploads/E2_EVIS/ENIGMA2_MeanThalamus_Combined_GenomeControlled_Jan23.tbl.gz
zcat ENIGMA2_ICV_Combined_GenomeControlled_Jan23.tbl.gz| head -n 2
#RSID CHR_BP_hg19b37 Effect_Allele Non_Effect_Allele Freq_European_1000Genomes Effect_Beta StdErr Pvalue N
#rs667647 5:29439275 T C 0.347 -148.8340 2029.8618 0.9415 11373

#Cerebellum and global volume
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_CommBio2022_readme.txt
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_CommBio2022_cerebellarvolume.txt.gz
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_CommBio2022_cerebralvolume.txt.gz
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_CommBio2022_subcorticalvolume.txt.gz

#Functional and Structural connectivity
mkdir -p ~/sumstats/Brain_Function && cd ~/sumstats/Brain_Function/
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_eNeuro2023_FC_Default_EUR_sumstats.txt.gz
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_eNeuro2023_FC_Dorsal.Attention_EUR_sumstats.txt.gz
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_eNeuro2023_FC_Frontoparietal_EUR_sumstats.txt.gz
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_eNeuro2023_FC_global_EUR_sumstats.txt.gz
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_eNeuro2023_FC_Limbic_EUR_sumstats.txt.gz
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_eNeuro2023_FC_Somatomotor_EUR_sumstats.txt.gz
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_eNeuro2023_FC_Ventral.Attention_EUR_sumstats.txt.gz
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_eNeuro2023_FC_Visual_EUR_sumstats.txt.gz
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_eNeuro2023_SC_Default_EUR_sumstats.txt.gz
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_eNeuro2023_SC_Dorsal.Attention_EUR_sumstats.txt.gz
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_eNeuro2023_SC_Frontoparietal_EUR_sumstats.txt.gz
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_eNeuro2023_SC_global_EUR_sumstats.txt.gz
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_eNeuro2023_SC_Limbic_EUR_sumstats.txt.gz
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_eNeuro2023_SC_Somatomotor_EUR_sumstats.txt.gz
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_eNeuro2023_SC_Ventral.Attention_EUR_sumstats.txt.gz
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_eNeuro2023_SC_Visual_EUR_sumstats.txt.gz
wget https://ctg.thebluebus.nl/documents/p1651/Tissinketal_eNeuro2023_readme.txt

#PRS-g-factor/GCA
mkdir -p ~/sumstats/Cognition_GCA && cd ~/sumstats/Cognition_GCA/

#PRS-individual cognitive functions
mkdir -p ~/sumstats/Cognition_fx && cd ~/sumstats/Cognition_fx/

#PRS-IQ
mkdir -p ~/sumstats/Cognition_IQ && cd ~/sumstats/Cognition_IQ/
wget https://vu.data.surfsara.nl/index.php/s/9tgwxmO5yosQkmb/download\?path=%2F\&files=README_SavageJansen_2018_intelligence_metaanalysis.txt
wget https://vu.data.surfsara.nl/index.php/s/9tgwxmO5yosQkmb/download\?path=%2F\&files=SavageJansen_2018_intelligence_metaanalysis.txt

#PRS-AD
#https://ctg.thebluebus.nl/software/summary_statistics/
mkdir -p ~/sumstats/Neuro_AD && cd ~/sumstats/Neuro_AD/
wget https://ctg.thebluebus.nl/documents/p1651/PGCALZ2ExcludingUKBand23andME_METALInverseVariance_MetaAnalysis.txt.gz
zcat PGCALZ2ExcludingUKBand23andME_METALInverseVariance_MetaAnalysis.txt.gz |head -n 2
#chromosome base_pair_location effect_allele other_allele beta standard_error effect_allele_frequency p_value SNPID N Neffective Build
#1 13668 A G -0.1265 0.3749 0.00581 0.7358 1:13668:A_G 74004 7017.263283 GRCh37
#Download harmonized from GWAS catalog FTP
#Wightman DP	GCST90044699	2021-09-07	Nat Genet	A genome-wide association study with 1,126,563…	Late-onset Alzheimer's disease	late-onset Alzheimers disease	-	• 1126563 European		38	Not available
#Wightman DP	GCST013197	2021-09-07	Nat Genet	A genome-wide association study with 1,126,563…	Late-onset Alzheimer's disease	late-onset Alzheimers disease	-	• 762917 European		0	FTP Download -> IncludingUKBand23andME
#Wightman DP	GCST013196	2021-09-07	Nat Genet	A genome-wide association study with 1,126,563…	Late-onset Alzheimer's disease	late-onset Alzheimers disease	-	• 398058 European		0	FTP Download -> ExcludingUKBand23andME
wget -nH -r -np --cut-dirs=7 -e robots=off --reject="*index.html?*" https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST013001-GCST014000/GCST013196/
zcat GCST013196.tsv.gz |head -n 2
#chromosome      base_pair_location      effect_allele   other_allele    beta    standard_error  effect_allele_frequency p_value n       N_effective
#1       13668   A       G       -0.1265 0.3749  0.00581 0.7358  74004   7017.263283

#PRS-MCI or cognitive decline or mental deterioration
#mkdir -p ~/sumstats/Neuro_MCI && cd ~/sumstats/Neuro_MCI/
#wget https://ctg.thebluebus.nl/documents/p1651/PGCALZ2ExcludingUKBand23andME_METALInverseVariance_MetaAnalysis.txt.gz
#unzip pgc_scz2022_sumstats.zip
#zcat PGCALZ2ExcludingUKBand23andME_METALInverseVariance_MetaAnalysis.txt.gz |head -n 2

#PRS-VaD
#mkdir -p ~/sumstats/Neuro_VaD && cd ~/sumstats/Neuro_VaD/
#wget https://ctg.thebluebus.nl/documents/p1651/PGCALZ2ExcludingUKBand23andME_METALInverseVariance_MetaAnalysis.txt.gz
#unzip pgc_scz2022_sumstats.zip
#zcat PGCALZ2ExcludingUKBand23andME_METALInverseVariance_MetaAnalysis.txt.gz |head -n 2

#PRS-FTD
#mkdir -p ~/sumstats/Neuro_FTD && cd ~/sumstats/Neuro_FTD/
#wget https://ctg.thebluebus.nl/documents/p1651/PGCALZ2ExcludingUKBand23andME_METALInverseVariance_MetaAnalysis.txt.gz
#unzip pgc_scz2022_sumstats.zip
#zcat PGCALZ2ExcludingUKBand23andME_METALInverseVariance_MetaAnalysis.txt.gz |head -n 2

#FinnGen
mkdir -p ~/sumstats/FinnGen && cd ~/sumstats/FinnGen/
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_ADHD.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_AGORAPHOBIA.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_ALCOHOLAC.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_ALCOHOL_DEPENDENCE.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_ALLANXIOUS.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_ALZHDEMENT.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_ANAPER.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_ANOREX.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_ANXIETY.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_ANXPER.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_BEHAVE.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_BEHEMOCHILD.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_BIPO.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_BULIMIA.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_CANNABIS.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_COCAINE.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_DELIRIUM.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_DELUSIO.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_DEMENTIA.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_DEMENTIA_INCLAVO.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_DEMINOTH.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_DEMNAS.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_DEPPER.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_DEPRESSIO.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_DEPRESSION_DYSTHYMIA.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_DEPRESSION_PSYCHOTIC.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_DEPRESSION_RECURRENT.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_DISPER.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_DISSOCIATIVE.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_EATOTH.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_EMOCHILD.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_EMOPER.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_GAD.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_GENDER.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_HABIT.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_HALLUCIN.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_HISPER.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_HYPERKIN.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_HYPERSOMNIA.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_INSOMNIA.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_KELAMENT.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_KELARET.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_MANIA.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_MENTALUNSPE.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_MENTORG.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_MILDRET.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_MIXEDDEV.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_MIXPER.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_MODRET.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_MOOD.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_MOODOTH.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_NEUROTICOTH.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_NIGHTMARES.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_OCD.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_OPIOIDS.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_OTHERSUB.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_OTHPER.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_OTHRET.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_PANIC.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_PARAPER.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_PERSBEHORG.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_PERSMOOD.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_PERSOCHANGE.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_PERSOTH.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_PERVASIVE.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_PHOBANX.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_PHYSBEHOTH.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_PSYCHDEV.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_PSYCHDEVOTH.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_PSYCHOTH.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_PSYTRANS.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_PTSD.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_SCHIZOAFF.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_SCHIZOTYP.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_SCHIZPER.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_SCHOLA.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_SCHZPHR.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_SEDAHYP.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_SEVRET.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_SEXDYS.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_SEXPREF.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_SEXUAL.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_SLEEPTERRORS.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_SLEEPWAKE.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_SLEEPWALKING.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_SLEEP_NOS.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_SOCPHOB.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_SOLVENT.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_SOMATOFORM.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_SPEECH.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_STIMUL.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_STRESSOTH.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_SUBSNOALCO.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_UNSORG.gz
wget https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_F5_VASCDEM.gz

#PRS-SCZ
mkdir -p ~/sumstats/Psych_SCZ && cd ~/sumstats/Psych_SCZ/
wget -O pgc_scz2022_sumstats.zip "https://figshare.com/ndownloader/articles/19426775/versions/7"
unzip pgc_scz2022_sumstats.zip
zcat PGC3_SCZ_wave3.european.autosome.public.v3.vcf.tsv.gz | head -n 75 #First 73 lines are comments
# #CHROM  ID      POS     A1      A2      FREQ    NEFF    Z       P       DIRE
#2       rs6759922       22450249        A       G       0.4573  638463.00       8.821   1.134e-18       +++-+--+-
###cohortList="ipsych,bep1b,braz2,butr,celso,cgs1c,clz2a,cogs1,du2aa,enric,eu5me,eusp2,eutu2,gap1a,gawli,geba1,gpc2a,gro2a,grtr,lemu,mcqul,mosc2,paris,price,rive1,rouin,sb2aa,serri,to10c,uktr,viyo1,xaarh,xaber,xajsz,xasrb,xboco,xbuls,xcati,xcaws,xcims,xclm2,xclo3,xcou3,xdenm,xdubl,xedin,xegcu,xersw,xfi3m,xfii6,xgras,xirwt,xjr3a,xjr3b,xjri6,xjrsa,xlacw,xlie2,xlie5,xlktu,xmgs2,xmsaf,xmunc,xpewb,xpews,xpfla,xport,xs234,xswe1,xswe5,xswe6,xtop8,xucla,xuclo,xume2,xzhh1"
#It doesn't seem to include ukbb

#PRS-psychotic symptoms or functioning level
mkdir -p ~/sumstats/Psych_SCZ_sx && cd ~/sumstats/Psych_SCZ_sx/
wget -nH -r -np --cut-dirs=1 -e robots=off --reject="*index.html?*" https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90042001-GCST90043000/GCST90042791/harmonised/

#PRS-BIP
mkdir -p ~/sumstats/Psych_BIP && cd ~/sumstats/Psych_BIP/
wget -O pgc_bip2024_summary_statistics.zip "https://figshare.com/ndownloader/articles/27216117/versions/2"
unzip pgc_bip2024_summary_statistics.zip
zcat bip2024_eur_noUKB_no23andMe.gz | head -n 2
#SNP CHR BP A1 A2 INFO OR SE P ngt Direction HetISqt HetDf HetPVa Nca Nco Neff_half HRC_FRQ_A1
#rs10 7 92383888 A C 0.904 1.01207 0.0176 0.4974 1 ---+++- 0 60 0.7938 51493 661850 68548.53 0.0529979

#PRS-MDD
mkdir -p ~/sumstats/Psych_MDD && cd ~/sumstats/Psych_MDD/
wget -O pgc_mdd2024_gwas_summary.zip "https://figshare.com/ndownloader/articles/22745573/versions/3"
wget -O pgc_mdd2025_summary_statistics.zip "https://figshare.com/ndownloader/articles/27061255/versions/4"
unzip pgc_mdd2024_gwas_summary.zip
unzip pgc_mdd2025_summary_statistics.zip
zcat ssf/pgc-mdd2025_no23andMe-noUKBB_eur_v3-49-24-11_formatted.tsv.gz | head -n 2
#chromosome      base_pair_location      effect_allele   other_allele    beta    standard_error  effect_allele_frequency p_value   rsid    info    effect_allele_frequency_cases   n       ncases  ncontrols       heterogeneity_i2        heterogeneity_df  heterogeneity_p_value
#1       753541  A       G       0.004101577021075048    0.0055  0.155   0.4614  rs2073813       0.847   0.15    829249.58310128   1035355 31.1    16      0.1082

#PRS-ADHD
mkdir -p ~/sumstats/Psych_ADHD && cd ~/sumstats/Psych_ADHD/
wget -O pgc_adhd2022_summary_statistics.zip "https://figshare.com/ndownloader/articles/22564390/versions/1"
unzip pgc_adhd2022_summary_statistics.zip
zcat ADHD2022_iPSYCH_deCODE_PGC.meta.gz | head -n 2

#PRS-ASD
mkdir -p ~/sumstats/Psych_ASD && cd ~/sumstats/Psych_ASD/
wget -O pgc_asd2019_summary_statistics.zip "https://figshare.com/ndownloader/articles/14671989/versions/1"
unzip pgc_asd2019_summary_statistics.zip
zcat iPSYCH-PGC_ASD_Nov2017.gz | head -n 2

#PRS-AN
mkdir -p ~/sumstats/Psych_AN && cd ~/sumstats/Psych_AN/
wget -O pgc_an2019_summary_statistics.zip "https://figshare.com/ndownloader/articles/14671980/versions/1"
unzip pgc_an2019_summary_statistics.zip
zcat pgcAN2.2019-07.vcf.tsv.gz | head -n 71 #First 70 lines are comments
#CHROM   POS     ID      REF     ALT     BETA    SE      PVAL    NGT     IMPINFO NEFFDIV2        NCAS    NCON    DIRE

#PRS-OCD
mkdir -p ~/sumstats/Psych_OCD && cd ~/sumstats/Psych_OCD/
wget -O pgc_ocd2018_summary_statistics.zip "https://figshare.com/ndownloader/articles/14672103/versions/1"
unzip pgc_ocd2018_summary_statistics.zip
zcat ocd_aug2017.gz | head -n 2
#CHR     SNP     BP      A1      A2      INFO    OR      SE      P
#1       rs141242758     734349  T       C       0.6683  1.07358 0.1088  0.5144

#PRS-PTSD
mkdir -p ~/sumstats/Psych_PTSD && cd ~/sumstats/Psych_PTSD/
wget -O pgc_ptsd2024_summary_statistics.zip "https://figshare.com/ndownloader/articles/26349322/versions/3"
unzip pgc_ptsd2024_summary_statistics.zip
zcat eur_ptsd_pcs_v4_aug3_2021.vcf.gz | head -n 67 #First 66 lines are comments
# #CHROM  ID      POS     A1      A2      FREQ    NEFF    Z       P       DIRE

#PRS-SUD - Substance Use Disorder, 
mkdir -p ~/sumstats/Psych_SUD && cd ~/sumstats/Psych_SUD/
wget -O pgc_sud2023_summary_statistics.zip "https://figshare.com/ndownloader/articles/24268882/versions/1"
unzip pgc_sud2023_summary_statistics.zip
zcat Hatoum2023AddictionEuropean.txt.gz | head -n 2
#SNP     Chr     BP      A1      A2      Beta    P
#rs1000000       12      126890980       G       A       0.000999726671814611    0.701658206953194

#PRS-CUD - Cannabis Use Disorder, 
mkdir -p ~/sumstats/Psych_CUD && cd ~/sumstats/Psych_CUD/
wget -O pgc_cud2020_summary_statistics.zip "https://figshare.com/ndownloader/articles/14842692/versions/1"
unzip pgc_cud2020_summary_statistics.zip
zcat Hatoum2023AddictionEuropean.txt.gz | head -n 2

#PRS-OD - Opioid Dependence, Polimanti et al 2020
mkdir -p ~/sumstats/Psych_OD && cd ~/sumstats/Psych_OD/
wget -O pgc_od2020_summary_statistics.zip "https://figshare.com/ndownloader/articles/14672211/versions/1"
unzip pgc_od2020_summary_statistics.zip
zcat OD_cases_vs._opioid-exposed_controls_in_European-ancestry_cohorts.gz | head -n 2




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

cd ~/sumstats/Psych_BIP/
python ~/opt/python_convert/sumstats.py csv \
--sumstats bip2024_eur_noUKB_no23andMe.gz --out Psych_BIP_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --pval P --ncase Nca --ncontrol Nco --frq HRC_FRQ_A1

cd ~/sumstats/Psych_MDD/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ssf/pgc-mdd2025_no23andMe-noUKBB_eur_v3-49-24-11_formatted.tsv.gz --out Psych_MDD_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp rsid --beta beta --se standard_error --pval p_value --ncase ncases --ncontrol ncontrols --frq effect_allele_frequency

cd ~/sumstats/Psych_SCZ/
python ~/opt/python_convert/sumstats.py csv \
--sumstats PGC3_SCZ_wave3.european.autosome.public.v3.vcf.tsv.gz --out Psych_SCZ_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Psych_ADHD/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out granulocyte_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Psych_ASD/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out granulocyte_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Psych_AN/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out granulocyte_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Psych_OCD/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out granulocyte_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Psych_PTSD/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out granulocyte_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Psych_SUD/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out granulocyte_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

##########

cd ~/sumstats/Brain_Structure/ENIGMA2_subcortical/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA2_ICV_Combined_GenomeControlled_Jan23.tbl.gz --out BrainMRI_ICV_sumstats.tsv \
--force --auto --head 5 --chrpos CHR_BP_hg19b37 --a1 Effect_Allele --a2 Non_Effect_Allele --snp RSID --beta Effect_Beta --se StdErr --pval Pvalue --frq Freq_European_1000Genomes

cd ~/sumstats/Brain_Structure/ENIGMA2_subcortical/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA2_MeanAccumbens_Combined_GenomeControlled_Jan23.tbl.gz --out BrainMRI_Accumbens_sumstats.tsv \
--force --auto --head 5 --chrpos CHR_BP_hg19b37 --a1 Effect_Allele --a2 Non_Effect_Allele --snp RSID --beta Effect_Beta --se StdErr --pval Pvalue --frq Freq_European_1000Genomes

cd ~/sumstats/Brain_Structure/ENIGMA2_subcortical/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA2_MeanAmygdala_Combined_GenomeControlled_Jan23.tbl.gz --out BrainMRI_Amygdala_sumstats.tsv \
--force --auto --head 5 --chrpos CHR_BP_hg19b37 --a1 Effect_Allele --a2 Non_Effect_Allele --snp RSID --beta Effect_Beta --se StdErr --pval Pvalue --frq Freq_European_1000Genomes

cd ~/sumstats/Brain_Structure/ENIGMA2_subcortical/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA2_MeanCaudate_Combined_GenomeControlled_Jan23.tbl.gz --out BrainMRI_Caudate_sumstats.tsv \
--force --auto --head 5 --chrpos CHR_BP_hg19b37 --a1 Effect_Allele --a2 Non_Effect_Allele --snp RSID --beta Effect_Beta --se StdErr --pval Pvalue --frq Freq_European_1000Genomes

cd ~/sumstats/Brain_Structure/ENIGMA2_subcortical/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA2_MeanHippocampus_Combined_GenomeControlled_Jan23.tbl.gz --out BrainMRI_Hippocampus_sumstats.tsv \
--force --auto --head 5 --chrpos CHR_BP_hg19b37 --a1 Effect_Allele --a2 Non_Effect_Allele --snp RSID --beta Effect_Beta --se StdErr --pval Pvalue --frq Freq_European_1000Genomes

cd ~/sumstats/Brain_Structure/ENIGMA2_subcortical/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA2_MeanPallidum_Combined_GenomeControlled_Jan23.tbl.gz --out BrainMRI_Pallidum_sumstats.tsv \
--force --auto --head 5 --chrpos CHR_BP_hg19b37 --a1 Effect_Allele --a2 Non_Effect_Allele --snp RSID --beta Effect_Beta --se StdErr --pval Pvalue --frq Freq_European_1000Genomes

cd ~/sumstats/Brain_Structure/ENIGMA2_subcortical/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA2_MeanPutamen_Combined_GenomeControlled_Jan23.tbl.gz --out BrainMRI_Putamen_sumstats.tsv \
--force --auto --head 5 --chrpos CHR_BP_hg19b37 --a1 Effect_Allele --a2 Non_Effect_Allele --snp RSID --beta Effect_Beta --se StdErr --pval Pvalue --frq Freq_European_1000Genomes

cd ~/sumstats/Brain_Structure/ENIGMA2_subcortical/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA2_MeanThalamus_Combined_GenomeControlled_Jan23.tbl.gz --out BrainMRI_Thalamus_sumstats.tsv \
--force --auto --head 5 --chrpos CHR_BP_hg19b37 --a1 Effect_Allele --a2 Non_Effect_Allele --snp RSID --beta Effect_Beta --se StdErr --pval Pvalue --frq Freq_European_1000Genomes

##########

cd ~/sumstats/Brain_Structure/ENIGMA3_Global/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wo_Mean_Full_SurfArea_20190429.txt.gz --out BrainMRI_SA_GC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA1 --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_Global/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wo_Mean_Full_Thickness_20190429.txt.gz --out BrainMRI_CT_GC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA1 --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_Global_noGC/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wo_Mean_Full_SurfArea_20190429_noGC.txt.gz --out BrainMRI_SA_noGC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_Global_noGC/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wo_Mean_Full_Thickness_20190429_noGC.txt.gz --out BrainMRI_CT_noGC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA --se SE --pval P --frq FREQ1

##########

for roi in bankssts caudalanteriorcingulate caudalmiddlefrontal cuneus entorhinal frontalpole fusiform inferiorparietal 
inferiortemporal insula isthmuscingulate lateraloccipital lateralorbitofrontal lingual medialorbitofrontal middletemporal paracentral parahippocampal parsopercularis parsorbitalis parstriangularis pericalcarine postcentral posteriorcingulate precentral precuneus rostralanteriorcingulate rostralmiddlefrontal superiorfrontal superiorparietal superiortemporal supramarginal temporalpole transversetemporal; do

cd ~/sumstats/Brain_Structure/ENIGMA3_withGlobal/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wSA_Mean_${roi}_surfavg_20190429.txt.gz --out BrainMRI_SA${roi}_wGlobal_GC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA1 --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_withGlobal/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wTHICK_Mean_${roi}_thickavg_20200522.txt.gz --out BrainMRI_CT${roi}_wGlobal_GC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA1 --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_withGlobal_noGC/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wSA_Mean_${roi}_surfavg_20190429_noGC.txt.gz --out BrainMRI_SA${roi}_wGlobal_noGC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA1 --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_withGlobal_noGC/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wTHICK_Mean_${roi}_thickavg_20200522_noGC.txt.gz --out BrainMRI_CT${roi}_wGlobal_noGC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA1 --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_withoutGlobal/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wo_Mean_${roi}_surfavg_20190429.txt.gz --out BrainMRI_SA${roi}_woGlobal_GC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA1 --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_withoutGlobal/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wo_Mean_${roi}_thickavg_20200522.txt.gz --out BrainMRI_CT${roi}_woGlobal_GC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA1 --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_withoutGlobal_noGC/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wo_Mean_${roi}_surfavg_20190429_noGC.txt.gz --out BrainMRI_SA${roi}_woGlobal_noGC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA1 --se SE --pval P --frq FREQ1

cd ~/sumstats/Brain_Structure/ENIGMA3_withoutGlobal_noGC/
python ~/opt/python_convert/sumstats.py csv \
--sumstats ENIGMA3_mixed_se_wo_Mean_${roi}_thickavg_20200522_noGC.txt.gz --out BrainMRI_CT${roi}_woGlobal_noGC_sumstats.tsv \
--force --auto --head 5 --chr CHR --bp BP --snp SNP --beta BETA1 --se SE --pval P --frq FREQ1

done

##########

cd ~/sumstats/Cognition_IQ/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out Cognition_IQ_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Cognition_GCA/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out Cognition_GCA_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Cognition_fx/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out Cognition_fx_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

:<<'COMMENTBLOCK'

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

cd ~/sumstats/Brain_Function/
python ~/opt/python_convert/sumstats.py csv \
--sumstats 27863252-GCST004614-EFO_0007987-Build37.f.tsv.gz --out BrainMRI_FC_sumstats.tsv \
--force --auto --head 5 --chr chromosome --bp base_pair_location --snp variant_id --beta beta --se standard_error --pval p_value --n-val 173480

COMMENTBLOCK

##################################################################################################

:<<'COMMENTBLOCK'

#CRP - https://doi.org/10.1038/s41467-022-29650-5 
mkdir -p ~/sumstats/Biomarkers/CRP && cd ~/sumstats/Biomarkers/CRP/
wget -r -np -R "index.html*" -e robots=off --cut-dirs=8 https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90029001-GCST90030000/GCST90029070/harmonised/

#Lymphocyte count GWAS: PMID 27863252 x adaptive immune response - https://doi.org/10.1016/j.cell.2016.10.042
mkdir -p ~/sumstats/Biomarkers/lymphocyte && cd ~/sumstats/Biomarkers/lymphocyte/
wget -r -np -R "index.html*" -e robots=off --cut-dirs=8 https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST004001-GCST005000/GCST004632/harmonised/

#Granulocyte count GWAS: PMID 27863252 x innate immune response - https://doi.org/10.1016/j.cell.2016.10.042 
mkdir -p ~/sumstats/Biomarkers/granulocyte && cd ~/sumstats/Biomarkers/granulocyte/
wget -r -np -R "index.html*" -e robots=off --cut-dirs=8 https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST004001-GCST005000/GCST004614/harmonised/

#Granulocytes are a type of white blood cell that has small granules inside them. These granules contain proteins. 
#The specific types of granulocytes are neutrophils, eosinophils, and basophils.



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
mkdir -p /notebooks/ref_panels/1KGPref
cd ~/ref_panels/1KGPref
#wget -r -np -R "index.html*, supporting" -e robots=off --cut-dirs=5 ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/
#cd ftp.1000genomes.ebi.ac.uk/

#Download ALL.chr${i}.phase3_v5.shapeit2_mvncall_integrated.noSingleton.genotypes.vcf.gz 
if [ ! -f ~/ref_panels/1KGPref/integrated_call_samples_v3.20130502.ALL.panel ]; then
    mkdir -p ~/ref_panels/1KGPref
    cd ~/ref_panels/1KGPref/
    for i in {1..22} X Y MT; do
        wget -c "https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr${i}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz"
        wget -c "https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr${i}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz.tbi"
    done
    wget https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/integrated_call_samples_v3.20130502.ALL.panel
    wget ftp://yunlianon:anon@rc-ns-ftp.its.unc.edu/ALL.phase3_v5.shapeit2_mvncall_integrated.noSingleton.tgz
    tar xzf ALL.phase3_v5.shapeit2_mvncall_integrated.noSingleton.tgz
    mv all/* ./
    rmdir all
fi

#Adding allele frequencies if they are missing from the sumstats
grep 'CEU' ~/ref_panels/1KGPref/integrated_call_samples_v3.20130502.ALL.panel | awk '{print $1}' > ~/ref_panels/1KGPref/CEU_samples.txt
grep 'EUR' ~/ref_panels/1KGPref/integrated_call_samples_v3.20130502.ALL.panel | awk '{print $1}' > ~/ref_panels/1KGPref/EUR_samples.txt
grep 'EAS' ~/ref_panels/1KGPref/integrated_call_samples_v3.20130502.ALL.panel | awk '{print $1}' > ~/ref_panels/1KGPref/EAS_samples.txt
grep 'SAS' ~/ref_panels/1KGPref/integrated_call_samples_v3.20130502.ALL.panel | awk '{print $1}' > ~/ref_panels/1KGPref/SAS_samples.txt
grep 'AFR' ~/ref_panels/1KGPref/integrated_call_samples_v3.20130502.ALL.panel | awk '{print $1}' > ~/ref_panels/1KGPref/AFR_samples.txt
grep 'AMR' ~/ref_panels/1KGPref/integrated_call_samples_v3.20130502.ALL.panel | awk '{print $1}' > ~/ref_panels/1KGPref/AMR_samples.txt

#Merge ALL.chr${i}.phase3_v5.shapeit2_mvncall_integrated.noSingleton.genotypes.vcf.gz into merged_whole_genome.vcf.gz
cd ~/ref_panels/1KGPref/
~/code/vcf_concat_chr.sh

#Generate EUR_frequencies.frq
~/opt/vcftools --gzvcf ~/ref_panels/1KGPref/merged_whole_genome.vcf.gz --freq \
--keep ~/ref_panels/1KGPref/EUR_samples.txt --out ~/ref_panels/1KGPref/EUR_frequencies
~/opt/vcftools --gzvcf ~/ref_panels/1KGPref/merged_whole_genome.vcf.gz --freq \
--keep ~/ref_panels/1KGPref/EAS_samples.txt --out ~/ref_panels/1KGPref/EAS_frequencies
~/opt/vcftools --gzvcf ~/ref_panels/1KGPref/merged_whole_genome.vcf.gz --freq \
--keep ~/ref_panels/1KGPref/SAS_samples.txt --out ~/ref_panels/1KGPref/SAS_frequencies
~/opt/vcftools --gzvcf ~/ref_panels/1KGPref/merged_whole_genome.vcf.gz --freq \
--keep ~/ref_panels/1KGPref/AFR_samples.txt --out ~/ref_panels/1KGPref/AFR_frequencies
~/opt/vcftools --gzvcf ~/ref_panels/1KGPref/merged_whole_genome.vcf.gz --freq \
--keep ~/ref_panels/1KGPref/AMR_samples.txt --out ~/ref_panels/1KGPref/AMR_frequencies

cat ~/ref_panels/1KGPref/EUR_frequencies.frq | sed 's/{ALLELE:FREQ}/{ALLELE:FREQ}.1\t{ALLELE:FREQ}.2/g' > ~/ref_panels/1KGPref/EUR_frequencies.frq.edit
python ~/opt/split_allele_freq.py ~/ref_panels/1KGPref/EUR_frequencies.frq.edit ~/ref_panels/1KGPref/EUR_frequencies.frq.tsv

#Extract SNP rs ids and CHROM and POS from vcf file and write to tsv file
python ~/opt/extract_vcf_info.py ~/ref_panels/1KGPref/merged_whole_genome.vcf.gz ~/ref_panels/1KGPref/merged_whole_genome_snps.tsv

##Merge SNP info with frq file
#python ~/opt/merge_and_sort_files.py ~/ref_panels/1KGPref/merged_whole_genome_snps.tsv \
#~/ref_panels/1KGPref/EUR_frequencies.frq.tsv \
#~/ref_panels/1KGPref/EUR_frequencies.tsv

cd ~/ref_panels/
wget http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/snp147Common.txt.gz
gunzip snp147Common.txt.gz
###cut -f2-5 snp147Common.txt | awk '{gsub("chr", "", $2); print $4"\t$1"\t"$2"\t"($3+1)}' > rsid_chr_bp_map.tsv
cut -f2-5 snp147Common.txt | awk 'BEGIN {print "SNP\tCHR\tBP\tBP_END"} {gsub("chr", "", $1); print $4"\t"$1"\t"$2"\t"$3}' > rsid_chr_bp_map.tsv

##################################################################################################
#Run format conversion
cd ~/ref_panels
mkdir -p ensembl_grch37 && cd ensembl_grch37

for chr in {1..22} X Y MT; do
wget ftp://ftp.ensembl.org/pub/grch37/release-105/variation/vcf/homo_sapiens/homo_sapiens-chr${chr}.vcf.gz
wget ftp://ftp.ensembl.org/pub/grch37/release-105/variation/vcf/homo_sapiens/homo_sapiens-chr${chr}.vcf.gz.csi
tabix -p vcf homo_sapiens-chr${chr}.vcf.gz #make *.tbi file
done

wget -r -nH --cut-dirs=5 -A "homo_sapiens-chr*.vcf.gz,homo_sapiens-chr*.vcf.gz.tbi" ftp://ftp.ensembl.org/pub/grch37/current/variation/vcf/homo_sapiens/

cd homo_sapiens

bcftools concat -Oz -o all_chromosomes_merged.vcf.gz homo_sapiens-chr{1..22}.vcf.gz homo_sapiens-chrX.vcf.gz homo_sapiens-chrY.vcf.gz
tabix -p vcf all_chromosomes_merged.vcf.gz

wget https://ftp.ncbi.nih.gov/snp/latest_release/VCF/GCF_000001405.25.gz -O all_chromosomes.vcf.gz
tabix -p vcf all_chromosomes.vcf.gz


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