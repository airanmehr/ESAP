#!/usr/bin/env bash
cd /home/arya/storage/Data/Dmelanogaster/Hypoxia/
vcftools=~/bin/vcftools_0.1.13/bin/vcftools
mkdir readcounts
for vcf in $(ls pops/F200C3*.vcf)
do
    out=readcounts/$(echo $vcf | tr '/' '\t' | cut -f2 | tr '.' '\t' | cut -f1 |tr  '\t'  '.')
    echo $out
    grep -v "##" $vcf | sed 's/#//g' | cut -f1,2,4,5 > $out.REF.FORMAT &
    $vcftools --vcf $vcf --extract-FORMAT-info DP --out $out > /dev/null 2> /dev/null &
    $vcftools --vcf $vcf --extract-FORMAT-info AO --out $out > /dev/null 2> /dev/null&
    $vcftools --vcf $vcf --extract-FORMAT-info RO --out $out > /dev/null 2> /dev/null
done