#!/usr/bin/env bash
#chromosomes in F4-17 bam files are named chr2L,.. (assembly 5)
# this script creates a copy of reference which its chromosome renamed


cd /home/arya/storage/Data/Dmelanogaster/Hypoxia/F4-17/
cat SRR_Acc_List.txt |  while read bam;
do
    new=$bam.reheadered.bam
        samtools view -h $bam.bam | sed -e '/^@RG/s/\tPL:Illumina/.rmdup\tPL:Illumina/g' \
    -e '/^@SQ/s/SN:chrM/SN\:dmel_mitochondrion_genome/' -e '/^@SQ/s/SN\:chr/SN\:/'\
    -e '/^[^@]/s/\tchrM/\tdmel_mitochondrion_genome/g' -e '/^[^@]/s/\tchr/\t/g' | samtools view -bS - > $new
    samtools index $new
    echo $new
done




cd /home/arya/storage/Data/Dmelanogaster/Hypoxia/F200/
for phenotype in HOF LOF _C
do
    pops=""
    for bam in $(ls *$phenotype*.bam );
    do
        name=${bam%%.*}
        pop=$(echo $name| tr '_' '\t' |cut -f2)
        samtools view -H $bam
        pops="$pops $(echo -b $name.bam -s $pop -r $pop)"
    done
    out=${pop:0:1}
    echo $out
#    ~/bin/bamaddrg/bamaddrg $pops > $out.bam &
#    samtools sort $out.bam  -o $out.sorted.bam &
#    samtools index $out.sorted.bam &
done

samtools view -H L.sorted.bam | sed '/ID:1/d'  | samtools reheader  - L.sorted.bam > L.sorted.new.bam
mv L.sorted.new.bam L.sorted.bam