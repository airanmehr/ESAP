#!/usr/bin/env bash


cd /home/arya/storage/Data/Dmelanogaster/Hypoxia/F4-17/
samdump=~/bin/sratoolkit.2.8.0-ubuntu64/bin/sam-dump
grep -v "BioSample_s" SraRunTable.tsv | while read line;
do
    id=$(echo $line | tr ' ' '\t' |cut -f7)

    pop=$(echo $line | tr ' ' '\t' | cut -f9 | sed 's/H/L/g' )
    echo $id $pop
    $samdump --min-mapq 10 SRA/SRP059696/$id/$id.sra \
    | sed -e '/^@RG/s/\tPL:Illumina/.rmdup\tPL:Illumina/g' \
    -e '/^@SQ/s/SN:chrM/SN\:dmel_mitochondrion_genome/' -e '/^@SQ/s/SN\:chr/SN\:/'\
    -e '/^[^@]/s/\tchrM/\tdmel_mitochondrion_genome/g' -e '/^[^@]/s/\tchr/\t/g'| samtools view -bS - > ../BAM/$pop.bam &

#    for chrom in X #2L 2R 3L 3R 4
#    do
#        echo  $pop $chrom
#         $samdump --min-mapq 10 --aligned-region  chr$chrom SRA/SRP059696/$id/$id.sra \
#        | sed -e '/^@RG/s/\tPL:Illumina/.rmdup\tPL:Illumina/g' \
#        -e '/^@SQ/s/SN:chrM/SN\:dmel_mitochondrion_genome/' -e '/^@SQ/s/SN\:chr/SN\:/'\
#        -e '/^[^@]/s/\tchrM/\tdmel_mitochondrion_genome/g' -e '/^[^@]/s/\tchr/\t/g'| samtools view -bS - > BAM/$pop.$chrom.bam &
#    done
done