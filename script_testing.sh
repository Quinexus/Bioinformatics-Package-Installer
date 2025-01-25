#!/bin/bash

extract () {
   if [ -f $1 ] ; then
       case $1 in
        *.tar.bz2)      tar xvjf $1 ;;
        *.tar.gz)       tar xvzf $1 ;;
        *.tar.xz)       tar Jxvf $1 ;;
        *.bz2)          bunzip2 $1 ;;
        *.rar)          unrar x $1 ;;
        *.gz)           gunzip $1 ;;
        *.tar)          tar xvf $1 ;;
        *.tbz2)         tar xvjf $1 ;;
        *.tgz)          tar xvzf $1 ;;
        *.zip)          unzip $1 ;;
        *.Z)            uncompress $1 ;;
        *.7z)           7z x $1 ;;
        *)              echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
}

quick_make () {
    wget $1
    extract $(basename $1)
    folder_name=basename $1 | sed 's/\(.*\)\..*/\1/'
    cd folder_name
    # ./configure --prefix=/where/to/install
    make
    make install
    cd ..
}

# FastQC
git clone https://github.com/s-andrews/FastQC.git
cd FastQC
ant # Need ant java
chmod 755 bin/fastqc
ln -s path/to/FastQC/bin/fastqc /usr/local/bin/fastqc

# Bowtie2
BOWTIE2_VERSION=2.5.4
wget https://sourceforge.net/projects/bowtie-bio/files/bowtie2/${BOWTIE2_VERSION}/bowtie2-${BOWTIE2_VERSION}-source.zip
# git clone https://github.com/BenLangmead/bowtie2.git
unzip bowtie2-${BOWTIE2_VERSION}-source.zip
cd bowtie2-${BOWTIE2_VERSION}-source/
#./configure --prefix=/where/to/install
make # need make g++ gcc zlib1g-dev
make install
cd ..
ln -s path/to/bowtie_tools /usr/local/bin/bowtie_tools

# Samtools, BCF tools, htslib
SAMTOOLS_VERSION=1.21
BCFTOOLS_VERSION=1.21

wget https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2
tar -xvjf samtools-${SAMTOOLS_VERSION}.tar.bz2
cd samtools-${SAMTOOLS_VERSION}
# ./configure --prefix=/where/to/install
make # Dependencies: zlib1g-dev, libbz2-dev, liblzma-dev, libcurl4-openssl-dev, libssl-dev, libncurses5-dev
make install
cd ..

wget https://github.com/samtools/bcftools/releases/download/${BCFTOOLS_VERSION}/bcftools-${BCFTOOLS_VERSION}.tar.bz2
tar -xvjf bcftools-${BCFTOOLS_VERSION}.tar.bz2
cd bcftools-${BCFTOOLS_VERSION}
# ./configure --prefix=/where/to/install
make # Dependencies: zlib1g-dev, libbz2-dev, liblzma-dev, libcurl4-openssl-dev, libssl-dev, libncurses5-dev
make install
cd ..

# GATK
GATK_VERSION=4.6.1.0

wget https://github.com/broadinstitute/gatk/releases/download/${GATK_VERSION}/gatk-${GATK_VERSION}.zip
extract gatk-${GATK_VERSION}.zip
cd gatk-${GATK_VERSION}

git clone https://github.com/broadinstitute/gatk.git
cd gatk
./gradlew bundle
# sudo ln -s /path/to/gatk /usr/local/bin/gatk

# Ensemble VEP
git clone https://github.com/Ensembl/ensembl-vep.git
# Dependencies: perl, archive::zip, dbi
perl INSTALL.pl
ln -s path/to/vep /usr/local/bin/vep