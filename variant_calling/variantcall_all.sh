#!/usr/bin/env bash
cd /home/arya/storage/Data/Dmelanogaster/Hypoxia/

#outdir=vcf_pop/
#del F4-200.duplicated.bed
#for vcf in $(ls $outdir)
#do
#    #wc -l $outdir$vcf
#    #wc -l vcf_noindel_nomnp/$vcf
#    grep -v "#" $outdir$vcf | cut -f1,2 >> F4-200.duplicated.bed
#done
#
#python -c "import pandas as pd;pd.read_csv('F4-200.duplicated.bed',sep='\t',header=None).drop_duplicates().sort_values([0,1]).to_csv('F4-200.bed',sep='\t',header=None,index=None)"

wc -l F4-200.duplicated.bed
wc -l F4-200.bed

F4=$(ls F4-17/*reheadered.bam)
F200=$(ls F200/*sorted*.bam)
freebayes -f ../dmel5.fasta   -0 --pooled-discrete   $F200 $F4  > F4-200.vcf
