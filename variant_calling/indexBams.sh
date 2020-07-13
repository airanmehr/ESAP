#!/bin/bash
#cd /home/arya/storage/Data/Dmelanogaster/Hypoxia/F200/
#ref=/home/arya/storage/Data/Dmelanogaster/dmel5.fasta
#ls *.bam |  while read line;
#do
#    echo  $line
#    samtools index $line
#done


cd /home/arya/storage/Data/Dmelanogaster/Hypoxia/BAM/
ls *.bam |  while read line;
do
    echo  $line
    samtools index $line
done