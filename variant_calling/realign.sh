#!/usr/bin/env bash
cd /home/arya/storage/Data/Dmelanogaster/Hypoxia/BAM
speedseq=~/bin/speedseq/bin/speedseq
ref=/home/arya/storage/Data/Dmelanogaster/dmel6.fasta
for bam in $(ls *.bam)
do
    echo $bam
    $speedseq realign -vt 6 $ref $bam
done
