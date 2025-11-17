#!/bin/bash

sumstats_dir="/Volumes/projects/FHML_MHeNs/UKB-MHENS/sumstats"

cd $sumstats_dir

#Alzheimer's Disease - Schwartzentruber 2021 Nat Genet 
wget -nH -rkpN -l 6 --cut-dirs=5 -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90012001-GCST90013000/GCST90012877/harmonised

#Parkinson's disease
cd $sumstats_dir/PD
#Jiang_2021_NatGenet
wget -r -N --no-parent -nH -l 6 --cut-dirs=5 -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90042001-GCST90043000/GCST90042694/harmonised/
#LeGuen_2021_AnnalsofNeurology
wget -r -N --no-parent -nH -l 6 --cut-dirs=5 -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90104001-GCST90105000/GCST90104085/
wget -r -N --no-parent -nH -l 6 --cut-dirs=5 -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90104001-GCST90105000/GCST90104086/
wget -r -N --no-parent -nH -l 6 --cut-dirs=5 -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90104001-GCST90105000/GCST90104087/
#International Parkinson's Disease Genomics Consortium: https://pdgenetics.org/resources
#Blauwendraat et al 2019, 2021
#Nalls et al 2019

cd $sumstats_dir/Biomarkers

#Biomarkers: Ahola-Olli_2017_AmJHumGenet - Protein biomarkers 
for id in {004420..004460}; do
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/Ahola-OlliAV_27989323_GCST${id}/harmonised
done

#Biomarkers: Folkersen_2017_PLoSGenet - CVD protein biomarkers x 83 
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/FolkersenL_28369058_GCST009731

#Biomarkers: Folkersen_2020_NatMetab - CVD Protein biomarkers x 90 
for id in {90011994..90012083}; do
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/FolkersenL_33067605_GCST${id}/harmonised
done

#Biomarkers: Folkersen - metabolites
for id in 90011194 90011195 90011196 90011197 90011198 90011199 90012000; do
wget http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90011001-GCST90012000/GCST${id}/GCST${id}_buildGRCh37.tsv
done
#Biomarkers: Folkersen - metabolites
for id in 90012001 90012002 90012003 90012004 90012005 90012006 90012007 90012008 90012009 90012010 
90012011 90012012 90012013 90012014 90012015 90012016 90012017 90012018 90012019 90012020 
90012021 90012022 90012023 90012024 90012025 90012026 90012027 90012028 90012029 90012030 
90012031 90012032 90012033 90012034 90012035 90012036 90012037 90012038 90012039 90012040 
90012041 90012042 90012043 90012044 90012045 90012046 90012047 90012048 90012049 90012050 
90012051 90012052 90012053 90012054 90012055 90012056 90012057 90012058 90012059 90012060 
90012061 90012062 90012063 90012064 90012065 90012066 90012067 90012068 90012069 90012070 
90012071 90012072 90012073 90012074 90012075 90012076 90012077 90012078 90012079 90012080 
90012081 90012082 90012083 90012084; do
wget http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90012001-GCST90013000/GCST${id}/GCST${id}_buildGRCh37.tsv
done

#Biomarkers: Lotta 2021 - metabolites x 174 
for id in {90010722..90010862}; do
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90010001-GCST90011000/GCST${id}
#wget -r -np -R --reject="index.html*" -nH --cut-dirs=4 -e robots=off http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90010001-GCST90011000/GCST${id}/
done

#Lotta 2021 - kynurenine
wget -r -np -R --reject="index.html*" -nH --cut-dirs=4 -e robots=off http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90010001-GCST90011000/GCST90010747/

#Biomarkers - immune
#CRP - https://doi.org/10.1038/s41467-022-29650-5 
mkdir -p ~/sumstats/Biomarkers/CRP && cd ~/sumstats/Biomarkers/CRP/
wget -r -np -R "index.html*" -e robots=off --cut-dirs=8 https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90029001-GCST90030000/GCST90029070/harmonised/

#Lymphocyte count GWAS: PMID 27863252 x adaptive immune response - https://doi.org/10.1016/j.cell.2016.10.042
mkdir -p ~/sumstats/Biomarkers/lymphocyte && cd ~/sumstats/Biomarkers/lymphocyte/
wget -r -np -R "index.html*" -e robots=off --cut-dirs=8 https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST004001-GCST005000/GCST004632/harmonised/
mv ftp.ebi.ac.uk/* ./ && rm -r ftp.ebi.ac.uk

#Granulocyte count GWAS: PMID 27863252 x innate immune response - https://doi.org/10.1016/j.cell.2016.10.042 
mkdir -p ~/sumstats/Biomarkers/granulocyte && cd ~/sumstats/Biomarkers/granulocyte/
wget -r -np -R "index.html*" -e robots=off --cut-dirs=8 https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST004001-GCST005000/GCST004614/harmonised/
mv ftp.ebi.ac.uk/* ./ && rm -r ftp.ebi.ac.uk

#Granulocytes are a type of white blood cell that has small granules inside them. These granules contain proteins. 
#The specific types of granulocytes are neutrophils, eosinophils, and basophils.
mv ftp.ebi.ac.uk/* ./ && rm -r ftp.ebi.ac.uk


#BMI
cd $sumstats_dir/BMI
#BMI - AkiyamaM_28892062_GCST004904/
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/AkiyamaM_28892062_GCST004904/harmonised
#BMI - GCST006900
#Height - GCST006901
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/YengoL_30124842_GCST006900
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/YengoL_30124842_GCST006901

#cognition
cd $sumstats_dir/Cognition_IQ
#Davies et al
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/DaviesG_27046643_GCST003496/harmonised
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/DaviesG_27046643_GCST003497/harmonised
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/DaviesG_27046643_GCST003498/harmonised
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/DaviesG_27046643_GCST003499/harmonised
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/DaviesG_29844566_GCST006268/harmonised
#Savage et al
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" --reject="*.gif" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST006001-GCST007000/GCST006250/
#Lee et al - Gene discovery and polygenic prediction from a genome-wide association study of educational attainment in 1.1 million individuals
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" --reject="*.gif" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST006001-GCST007000/GCST006572/ #Cognitive performance
#Elsworth et al - IEU analysis of UK Biobank phenotypes - https://gwas.mrcieu.ac.uk/datasets/
wget https://gwas.mrcieu.ac.uk/files/ukb-b-4282/ukb-b-4282.vcf.gz #Prospective memory result
wget https://gwas.mrcieu.ac.uk/files/ukb-b-5238/ukb-b-5238.vcf.gz #Fluid intelligence score
wget https://gwas.mrcieu.ac.uk/files/ukb-b-2988/ukb-b-2988.vcf.gz #Number of fluid intelligence questions attempted within time limit

#Educational attainment
cd $sumstats_dir/EA
wget -nH -rkpN -l 6 --cut-dirs=5 -e robots=off --reject="index.html*" --reject="*.gif" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/

#Smith 2021 - UKB brain volumes
for id in {90002426..90006360}; do
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90001001-GCST90002000/GCST${id}/
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90002001-GCST90003000/GCST${id}/
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90003001-GCST90004000/GCST${id}/
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90004001-GCST90005000/GCST${id}/
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90005001-GCST90006000/GCST${id}/
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90006001-GCST90007000/GCST${id}/
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90007001-GCST90008000/GCST${id}/
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90008001-GCST90009000/GCST${id}/
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90009001-GCST90010000/GCST${id}/
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90010001-GCST90011000/GCST${id}/
done 

#####
### NEURO ###
#####

#migraine - Choquet 2021
cd ~$sumstats_dir/Migraine_headache
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" --reject="*.gif" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/

#MS - InternationalMultipleSclerosisGeneticsConsortium_2011_Nature
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" --reject="*.gif" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST001001-GCST002000/GCST001198

# Pain
# Johnston 2019
wget -nH -rkpN -l 1 --cut-dirs=4 -e robots=off --reject="index.html*" --reject="*.gif" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST008001-GCST009000/GCST008512
# Johnston 2021

#Stroke - Malik et al 2018 - MEGASTROKE
#source: https://www.megastroke.org/download.html

#Stroke - Mishra, Malik et al 2022 - GIGASTROKE
cd $sumstats_dir/Neuro_Stroke
for id in GCST90104534 GCST90104535 GCST90104536 GCST90104537 GCST90104538 GCST90104539 GCST90104540 GCST90104541 GCST90104542 GCST90104543 GCST90104544 GCST90104545 GCST90104546 GCST90104547 GCST90104548 GCST90104549 GCST90104550 GCST90104551 GCST90104552 GCST90104553 GCST90104554 GCST90104555 GCST90104556 GCST90104557 GCST90104558 GCST90104559 GCST90104560 GCST90104561 GCST90104562 GCST90104563; do
wget -nH -rkpN -l 1 --cut-dirs=4 -e robots=off --reject="index.html*" --reject="*.gif" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90104001-GCST90105000/$id/
done

#Cerebral Small vessel disease
cd $sumstats_dir/Neuro_CSVD
wget -nH -rkpN -l 1 --cut-dirs=5 -e robots=off --reject="index.html*" --reject="*.gif" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST010001-GCST011000/GCST010103/

#####
### PSYCH ###
#####

#Neuroticism - Nagel_2018_NatGenet
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" --reject="*.gif" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST006001-GCST007000/GCST006477/harmonised

#Neuroticism - 
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" --reject="*.gif" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/

#####
### SOMA ###
#####

#CVD
cd $sumstats_dir/CVD_cc
#ChristophersenIE - Atrial Fibrillation - done
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST004001-GCST005000/GCST004296/harmonised

#CVD quantitive traits
cd $sumstats_dir/CVD_quant_ECG_BP
#ChristophersenIE - P wave terminal force - done
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST004001-GCST005000/GCST004824/harmonised
#ChristophersenIE - P wave duration - done
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST004001-GCST005000/GCST004826/harmonised
#Verweij - ECG GWAS - download incomplete - 1000 files of 500MB each!!!
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST010001-GCST011000/GCST010796/

#T2D - Xue - done
cd $sumstats_dir/DM_T2D
wget -nH -rkpN -l 1 --cut-dirs=4 -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST006001-GCST007000/GCST006867
wget -nH -rkpN -l 1 --cut-dirs=4 -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST006001-GCST007000/GCST006867/harmonised

for file in WoodAR_23696881_GCST009159 WoodAR_23696881_GCST009160 WoodAR_23696881_GCST009161 WoodAR_23696881_GCST009162 \
WoodAR_23696881_GCST009163 WoodAR_23696881_GCST009164 WoodAR_23696881_GCST009165 WoodAR_23696881_GCST009166 \
WoodAR_23696881_GCST009167 WoodAR_23696881_GCST009168 WoodAR_23696881_GCST009169 WoodAR_23696881_GCST009170 \
WoodAR_23696881_GCST009171 WoodAR_26961502_GCST006801 WoodAR_26961502_GCST006802 WoodAR_28490609_GCST004487 \
WoodAR_28490609_GCST004488 WoodAR_28490609_GCST004489 WoodAR_28490609_GCST004575 WoodAR_28490609_GCST006675 \
WoodAR_28490609_GCST006676 WoodAR_28490609_GCST006677 WoodAR_28490609_GCST006678 WoodAR_28490609_GCST006679 WoodAR_28490609_GCST006681; do
wget -nH -rkpN -l 6 --cut-dirs=4 -e robots=off --reject="index.html*" https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/$file/harmonised
done

#Wood 2017 A Genome-Wide Association Study of IVGTT-Based Measures of First-Phase Insulin Secretion Refines the Underlying Physiology of Type 2 Diabetes Variants.
cd $sumstats_dir/DM_Fasting_glucose_insulin_glycemic_traits
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST004001-GCST005000/GCST004487/
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST004001-GCST005000/GCST004575/
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST004001-GCST005000/GCST004488/
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST004001-GCST005000/GCST004489/
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST006001-GCST007000/GCST006675/
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST006001-GCST007000/GCST006676/
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST006001-GCST007000/GCST006677/
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST006001-GCST007000/GCST006678/
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST006001-GCST007000/GCST006679/
wget -nH -r -np -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST006001-GCST007000/GCST006681/

cd $sumstats_dir/Sleep_circadian_clock_chronotype
#Snoring - Campos
wget -nH -rkpN -l 1 --cut-dirs=4 -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST009001-GCST010000/GCST009761
wget -nH -rkpN -l 1 --cut-dirs=4 -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST009001-GCST010000/GCST009762
wget -nH -rkpN -l 1 --cut-dirs=4 -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST009001-GCST010000/GCST009763
wget -nH -rkpN -l 1 --cut-dirs=4 -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST009001-GCST010000/GCST009760
#Sleep - Dashti
wget -nH -rkpN -l 1 --cut-dirs=4 -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST007001-GCST008000/GCST007559
wget -nH -rkpN -l 1 --cut-dirs=4 -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST007001-GCST008000/GCST007560
wget -nH -rkpN -l 1 --cut-dirs=4 -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST007001-GCST008000/GCST007561
#Insomnia - Lane
wget -nH -rkpN -l 1 --cut-dirs=4 -e robots=off --reject="index.html*" http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST007001-GCST008000/GCST007387

mv ftp.ebi.ac.uk/* ./ && rm -r ftp.ebi.ac.uk
mv GCST007001-GCST008000/*/* ./ && rm -r GCST007001-GCST008000
mv GCST009001-GCST010000/*/* ./ && rm -r GCST009001-GCST010000
