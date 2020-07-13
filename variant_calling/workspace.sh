#!/usr/bin/env bash



ref=../dmel5.fasta
F4=$(ls F4-17/*reheadered.bam)
F200=$(ls F200/Cl*.bam)

wc -l $out
##sort $out | uniq -u > $out.unique
#wc -l $out.unique
##tail $out.unique
#wc -l F4-200.bed


#region=2L:946800-946900
##mkdir vcf2
#for bam in $F200
#do
#    fname=$(echo $bam | tr '/' '\t' | cut -f2 | tr '.' '\t' | cut -f1 | tr '_' '\t' | cut -f2 )
#    fname=${fname:0:1}${fname: -1}
#    echo $fname.vcf
#    freebayes -f $ref  -r $region -0iuX --pooled-discrete  $bam | grep -v "#" |cut -f1-6,9,10 | grep 946859
##    > vcf2/$fname.vcf &
#done
#
#for bam in $F4
#do
#    fname=$(echo $bam | tr '/' '\t' | cut -f2 | tr '.' '\t' | cut -f1 )
#    echo $fname.vcf
#    freebayes -f $ref  -r $region -0iuX --pooled-discrete  $bam | grep -v "#" |cut -f1-6,9,10 | grep 946859
##    > vcf2/$fname.vcf
#done
#samtools mpileup  -f $ref  -r $region $F4 $F200 | grep 2L |grep 946859 > input.txt
#perl ~/bin/popoolation2_1201/mpileup2sync.pl --fastq-type sanger --min-qual 20 --input input.txt --output output.txt
#
#echo $F4
#cat output.txt | cut -f4- | tr '\t' '\n'
#



#freebayes -f ../dmel5.fasta -r2L:0-5200 --min-mapping-quality 20  --pooled-discrete  $(ls F200/*sorted.bam)  $(ls F4-17/*reheadered.bam)  -v F4-200.vcf

#freebayes -f ../dmel5.fasta --min-mapping-quality 20  --pooled-discrete  $F4  -v F4.vcf
#grep -v "#" F4.vcf| cut -f1-7  > F4.bed


#freebayes -f ../dmel5.fasta --min-mapping-quality 20  --pooled-discrete  $F200   -v F200.vcf
#grep -v "#" F200.vcf| cut -f1-7  > F200.bed

#/home/arya/anaconda2/bin/python -c "import sys;sys.path.append('/home/arya/workspace/bio/');import Util as utl; utl.BED.drop_duplicates('F4.bed','F200.bed','F4-200.bed')"
#awk '{print $1"\t"$2"\t"$2}' a.vcf
#bgzip -c a.vcf > a.vcf.gz && tabix -p vcf a.vcf.gz
#freebayes -f ../dmel5.fasta --min-mapping-quality 20  --pooled-discrete  -@ a.vcf $(ls F200/*sorted.bam)  -v F4a.vcf
#rm out*
#
#~/bin/vcftools_0.1.13/bin/vcftools --vcf fbayes.tsv --extract-FORMAT-info RO --out out
#~/bin/vcftools_0.1.13/bin/vcftools --vcf fbayes.tsv --extract-FORMAT-info DP --out out



#cat out.RO.FORMAT >out
#tail -n 1 out.AO.FORMAT >>out
#tail -n 1 out.DP.FORMAT >>out
#cat ~/sync >>out
#cat out