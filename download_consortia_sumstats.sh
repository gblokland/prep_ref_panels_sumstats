#!/bin/bash
##################################################################################################
# Download GWAS Summary Statistics From Consortia websites

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

#PGC-ADHD, ADHD3_Demontis2022
mkdir -p ~/sumstats/Psych_ADHD/ADHD3_Demontis2022 && cd ~/sumstats/Psych_ADHD/ADHD3_Demontis2022/
wget -O pgc_adhd2022_summary_statistics.zip "https://figshare.com/ndownloader/articles/22564390/versions/1"
unzip pgc_adhd2022_summary_statistics.zip
zcat ADHD2022_iPSYCH_deCODE_PGC.meta.gz | head -n 2

#PGC-ADHD, ADHDSexSpecific_Martin2018
mkdir -p ~/sumstats/Psych_ADHD/ADHDSexSpecific_Martin2018 && cd ~/sumstats/Psych_ADHD/ADHDSexSpecific_Martin2018/
###wget -O pgc_adhd2022_summary_statistics.zip "https://figshare.com/ndownloader/articles/22564390/versions/1"
###unzip pgc_adhd2022_summary_statistics.zip
###zcat ADHD2022_iPSYCH_deCODE_PGC.meta.gz | head -n 2

#PGC-ANX, Forstner2021 and Otawa2026
mkdir -p ~/sumstats/Psych_ANX/panic2019 && cd ~/sumstats/Psych_ANX/panic2019/
wget --user-agent="Mozilla/5.0" -O pgc-panic2019.vcf.tsv.gz "https://figshare.com/ndownloader/files/30731276"
###zcat pgc-panic2019.vcf.tsv.gz | head -n 2

mkdir -p ~/sumstats/Psych_ANX/anx2016 && cd ~/sumstats/Psych_ANX/anx2016/
wget --user-agent="Mozilla/5.0" -O pgc-anx2016_summary_statistics.zip "https://figshare.com/ndownloader/articles/14842689/versions/1"
unzip pgc-anx2016_summary_statistics.zip
###zcat pgc-panic2019.vcf.tsv.gz | head -n 2

#PGC-ASD
mkdir -p ~/sumstats/Psych_ASD/ASD3_Grove2019 && cd ~/sumstats/Psych_ASD/ASD3_Grove2019/
wget -O pgc_asd2019_summary_statistics.zip "https://figshare.com/ndownloader/articles/14671989/versions/1"
unzip pgc_asd2019_summary_statistics.zip
zcat iPSYCH-PGC_ASD_Nov2017.gz | head -n 2

#PGC-BIP
mkdir -p ~/sumstats/Psych_BIP/BIP4_OConnell2024 && cd ~/sumstats/Psych_BIP/BIP4_OConnell2024/
wget -O pgc_bip2024_summary_statistics.zip "https://figshare.com/ndownloader/articles/27216117/versions/2"
unzip pgc_bip2024_summary_statistics.zip
zcat bip2024_eur_noUKB_no23andMe.gz | head -n 2
#SNP CHR BP A1 A2 INFO OR SE P ngt Direction HetISqt HetDf HetPVa Nca Nco Neff_half HRC_FRQ_A1
#rs10 7 92383888 A C 0.904 1.01207 0.0176 0.4974 1 ---+++- 0 60 0.7938 51493 661850 68548.53 0.0529979

#PGC-ED
mkdir -p ~/sumstats/Psych_ED && cd ~/sumstats/Psych_ED/
wget -O pgc_an2019_summary_statistics.zip "https://figshare.com/ndownloader/articles/14671980/versions/1"
unzip pgc_an2019_summary_statistics.zip
zcat pgcAN2.2019-07.vcf.tsv.gz | head -n 71 #First 70 lines are comments
#CHROM   POS     ID      REF     ALT     BETA    SE      PVAL    NGT     IMPINFO NEFFDIV2        NCAS    NCON    DIRE

#PGC-MDD
mkdir -p ~/sumstats/Psych_MDD && cd ~/sumstats/Psych_MDD/
wget -O pgc_mdd2024_gwas_summary.zip "https://figshare.com/ndownloader/articles/22745573/versions/3"
wget -O pgc_mdd2025_summary_statistics.zip "https://figshare.com/ndownloader/articles/27061255/versions/4"
unzip pgc_mdd2024_gwas_summary.zip
unzip pgc_mdd2025_summary_statistics.zip
zcat ssf/pgc-mdd2025_no23andMe-noUKBB_eur_v3-49-24-11_formatted.tsv.gz | head -n 2
#chromosome      base_pair_location      effect_allele   other_allele    beta    standard_error  effect_allele_frequency p_value   rsid    info    effect_allele_frequency_cases   n       ncases  ncontrols       heterogeneity_i2        heterogeneity_df  heterogeneity_p_value
#1       753541  A       G       0.004101577021075048    0.0055  0.155   0.4614  rs2073813       0.847   0.15    829249.58310128   1035355 31.1    16      0.1082

#PGC-OCD
mkdir -p ~/sumstats/Psych_OCD && cd ~/sumstats/Psych_OCD/
wget -O pgc_ocd2018_summary_statistics.zip "https://figshare.com/ndownloader/articles/14672103/versions/1"
unzip pgc_ocd2018_summary_statistics.zip
zcat ocd_aug2017.gz | head -n 2
#CHR     SNP     BP      A1      A2      INFO    OR      SE      P
#1       rs141242758     734349  T       C       0.6683  1.07358 0.1088  0.5144

#PGC-PTSD
mkdir -p ~/sumstats/Psych_PTSD && cd ~/sumstats/Psych_PTSD/
wget -O pgc_ptsd2024_summary_statistics.zip "https://figshare.com/ndownloader/articles/26349322/versions/3"
unzip pgc_ptsd2024_summary_statistics.zip
zcat eur_ptsd_pcs_v4_aug3_2021.vcf.gz | head -n 67 #First 66 lines are comments
# #CHROM  ID      POS     A1      A2      FREQ    NEFF    Z       P       DIRE

#PGC-SCZ
mkdir -p ~/sumstats/Psych_SCZ && cd ~/sumstats/Psych_SCZ/
wget -O pgc_scz2022_sumstats.zip "https://figshare.com/ndownloader/articles/19426775/versions/7"
unzip pgc_scz2022_sumstats.zip
zcat PGC3_SCZ_wave3.european.autosome.public.v3.vcf.tsv.gz | head -n 75 #First 73 lines are comments
# #CHROM  ID      POS     A1      A2      FREQ    NEFF    Z       P       DIRE
#2       rs6759922       22450249        A       G       0.4573  638463.00       8.821   1.134e-18       +++-+--+-
###cohortList="ipsych,bep1b,braz2,butr,celso,cgs1c,clz2a,cogs1,du2aa,enric,eu5me,eusp2,eutu2,gap1a,gawli,geba1,gpc2a,gro2a,grtr,lemu,mcqul,mosc2,paris,price,rive1,rouin,sb2aa,serri,to10c,uktr,viyo1,xaarh,xaber,xajsz,xasrb,xboco,xbuls,xcati,xcaws,xcims,xclm2,xclo3,xcou3,xdenm,xdubl,xedin,xegcu,xersw,xfi3m,xfii6,xgras,xirwt,xjr3a,xjr3b,xjri6,xjrsa,xlacw,xlie2,xlie5,xlktu,xmgs2,xmsaf,xmunc,xpewb,xpews,xpfla,xport,xs234,xswe1,xswe5,xswe6,xtop8,xucla,xuclo,xume2,xzhh1"
#It doesn't seem to include ukbb

#PGC-psychotic symptoms or functioning level
mkdir -p ~/sumstats/Psych_SCZ_sx && cd ~/sumstats/Psych_SCZ_sx/
wget -nH -r -np --cut-dirs=6 -e robots=off --reject="*index.html?*" https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90042001-GCST90043000/GCST90042791/harmonised/

#PGC-SUD - Substance Use Disorder
mkdir -p ~/sumstats/Psych_SUD && cd ~/sumstats/Psych_SUD/
wget -O pgc_sud2023_summary_statistics.zip "https://figshare.com/ndownloader/articles/24268882/versions/1"
unzip pgc_sud2023_summary_statistics.zip
zcat Hatoum2023AddictionEuropean.txt.gz | head -n 2
#SNP     Chr     BP      A1      A2      Beta    P
#rs1000000       12      126890980       G       A       0.000999726671814611    0.701658206953194

#PGC-CUD - Cannabis Use Disorder
mkdir -p ~/sumstats/Psych_CUD && cd ~/sumstats/Psych_CUD/
wget -O pgc_cud2020_summary_statistics.zip "https://figshare.com/ndownloader/articles/14842692/versions/1"
unzip pgc_cud2020_summary_statistics.zip
zcat Hatoum2023AddictionEuropean.txt.gz | head -n 2

#PGC-OD - Opioid Dependence, Polimanti et al 2020
mkdir -p ~/sumstats/Psych_OD && cd ~/sumstats/Psych_OD/
wget -O pgc_od2020_summary_statistics.zip "https://figshare.com/ndownloader/articles/14672211/versions/1"
unzip pgc_od2020_summary_statistics.zip
zcat OD_cases_vs._opioid-exposed_controls_in_European-ancestry_cohorts.gz | head -n 2

