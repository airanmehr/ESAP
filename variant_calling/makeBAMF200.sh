#!/usr/bin/env bash
cd /home/arya/storage/Data/Dmelanogaster/Hypoxia/F200/
ls Cl*C3*.bam | while read line;
do
    echo $line
    name=$(echo $line | tr '.' '\t' | cut -f1)
    pop=$(echo $name| tr '_' '\t' |cut -f2)
    pop=$(echo F200${pop:0:1}${pop: -1})
    echo $pop $name
    samtools view -bF 0x04 -q 10 $line |\
    java -Xmx10G  -jar ~/bin/picard.jar AddOrReplaceReadGroups I=/dev/stdin O=../BAM/$pop.new.bam RGID=$pop RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=$pop
done
