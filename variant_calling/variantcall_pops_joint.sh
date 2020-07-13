#!/usr/bin/env bash
cd /home/arya/storage/Data/Dmelanogaster/Hypoxia/
F4=$(ls F4-17/BAM/*.bam)
F200=$(ls F200/Cl*C*.bam)
outdir=vcf
mkdir $outdir
region=X:15000000-15010000
rm pops
rm bams
for bam in $(ls BAM/F4*.bam)  $(ls BAM/F17*.bam) # $(ls BAM/F200*.bam) # $(ls BAM/F200C*.bam)
do
    echo $bam >> bams
    fname=$(echo $bam | tr '/' '\t' | cut -f2 | tr '.' '\t' | cut -f1 )
    echo $fname   $bam
    samtools view -H $bam | grep "@RG" | tr '\t' '\n' | grep SM: | tr ':' '\t' | cut -f2 | awk -v var="$fname" '{print var"\t"$1}'>> pops
done
#cat ../dmel5.fasta.fai
for chrom in X #$(cat ../dmel5.fasta.fai | cut -f1)
do
    if [[ $chrom != U*   &&   $chrom != *Het ]];
    then

        freebayes -f ../dmel5.fasta  -r $chrom:15000000-15000500  -awuiXkJ0 -Q 0 --populations pops --bam-list bams > $outdir/z.vcf &
        samtools mpileup -uvf ../dmel5.fasta -r $chrom:15000000-15000500 -t DP,AD -b bams > $outdir/zz.vcf
#        freebayes -f ../dmel5.fasta  -r $chrom:15000000-15100000  -J -m 20 -q 20  --populations pops --bam-list bams > $outdir/yy.vcf &
#        freebayes -f ../dmel5.fasta  -r $chrom  -J0  --populations pops --bam-list bams > $outdir/$chrom.vcf &
    fi
done
/home/arya/workspace/bio/hypoxia/Data/shell/extractReadCountsFromVCF.sh
#freebayes -f ../dmel5.fasta  -r $region  -0iuX --pooled-discrete  --populations pops --bam-list bams > $outdir/all.0iuX.vcf &
#
#
