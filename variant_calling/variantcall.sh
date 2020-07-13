#!/usr/bin/env bash
cd /home/arya/storage/Data/Dmelanogaster/Hypoxia/
outdir=Mt
#region=M:15000000-15010000
region=dmel_mitochondrion_genome
rm -rf $outdir
mkdir $outdir
vcftools=~/bin/vcftools_0.1.13/bin/vcftools


popsamples=BAM/pops.tsv
echo -e "Population\tSample" >$popsamples
for bam in $(ls BAM/*.bam)
do
    fname=$(echo $bam | tr '/' '\t' | cut -f2 | tr '.' '\t' | cut -f1 )
    samtools view -H $bam | grep "@RG" | tr '\t' '\n' | grep SM: | tr ':' '\t' | cut -f2 | awk -v var="$fname" '{print var"\t"$1}' >> BAM/pops.tsv
done


######### variant calling for each population
#freebayes -f ../dmel5.fasta   -r $region  -0 $(ls BAM/*.bam) | grep -v "##" > $outdir/all.tsv &
for bam in $(ls BAM/*.bam)
do
    echo $bam
    name=$(echo $bam| tr '/' '\t' | cut -f2).-0.vcf
#    freebayes -f ../dmel5.fasta   -r $region  -0 $bam | grep -v "##" > $outdir/$name.tsv &
    $vcftools --vcf - --get-INFO DP --out $outdir/$name &
    freebayes -f ../dmel5.fasta   -r $region  -iuX0 $bam > $outdir/$name
    bgzip -c $outdir/$name > $outdir/$name.gz
    tabix -p vcf $outdir/$name.gz
done

############ merge all vcf files vertically!
path=/home/arya/storage/Data/Dmelanogaster/Hypoxia/pops
a=$(ls $path)
echo $a
cd ~/bin/vcftools_0.1.13/perl/
echo $(ls -1 $path/*.vcf.gz | perl -pe 's/\n/ /g')
perl vcf-merge   $(ls -1 $path/*.vcf.gz | perl -pe 's/\n/ /g') >$path/all.vcf
bgzip -c all.vcf > all.vcf.gz
tabix -p vcf all.vcf.gz

##########  create annotation for the global VCF
cd $path
java -Xmx4g -jar ~/bin/snpEff/snpEff.jar  -ud 0 -s snpeff.5.75.html  BDGP5.75  all.vcf  | cut -f1,2,4,5,8 > ANN.csv


############# variant calling at all.vcf.gz  positions
cd ..
for bam in $(ls BAM/*.bam)
do
    echo $bam
    name=$(echo $bam| tr '/' '\t' | cut -f2)
    freebayes -f ../dmel5.fasta     -iuX0  -@ pops/all.vcf.gz $bam > pops/$name.vcf &
done
