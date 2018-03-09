FROM continuumio/miniconda3
MAINTAINER vsochat@stanford.edu

# docker build -t vanessa/pvacseq .

ENV DEBIAN_FRONTEND noninteractive

# Dependencies for cpanm
RUN apt-get update && apt-get install -y build-essential \
                                         libdbd-mysql-perl \
                                         libmysqlclient-dev \
                                         apt-utils \ 
                                         unzip \
                                         tcsh \
                                         gawk \
                                         vim

# Updates and Installs
RUN pip install --upgrade pip
RUN pip install pvacseq
RUN pvacseq download_example_data /


#
# # Variant Effect Predictor (VEP) Command Line Tool
#

RUN curl -L http://cpanmin.us | perl - App::cpanminus
RUN cpanm DBI
RUN cpanm DBD::mysql
RUN cpanm Archive::Zip

RUN git clone https://github.com/Ensembl/VEP_plugins.git
RUN git clone https://github.com/Ensembl/ensembl-vep.git
WORKDIR ensembl-vep
RUN perl INSTALL.pl -a a  # install API with no prompts

#
# # VEP_plugins (all of them!)
#

RUN perl INSTALL.pl -a p -g Downstream,miRNA
RUN pvacseq install_vep_plugin /VEP_plugins
 

#
# # PVAC-Tools 
# http://pvactools.readthedocs.io/en/latest/install.html
#

RUN pip install pvactools

# MHC Class I

WORKDIR /
RUN wget http://downloads.iedb.org/tools/mhci/LATEST/IEDB_MHC_I-2.17.tar.gz && \
    tar -xzvf IEDB_MHC_I-2.17.tar.gz && cd mhc_i && PATH=/usr/bin:$PATH ./configure && \
    sed -i 's/import pkg_resources/#import pkg_resources/g' method/netmhc-4.0-executable/netmhc_4_0_executable/__init__.py && \
    sed -i 's/import pkg_resources/#import pkg_resources/g' method/netmhcpan-3.0-executable/netmhcpan_3_0_executable/__init__.py && \
    sed -i 's/_executable_filename*/#/g' method/netmhcpan-3.0-executable/netmhcpan_3_0_executable/__init__.py && \
    sed -i 's/pkg_resources*/#/g' method/netmhcpan-3.0-executable/netmhcpan_3_0_executable/__init__.py && \
    sed -i 's/EXECUTABLE_PATH*/#/g' method/netmhcpan-3.0-executable/netmhcpan_3_0_executable/__init__.py     

# MHC Class II
WORKDIR /
RUN wget http://downloads.iedb.org/tools/mhcii/LATEST/IEDB_MHC_II-2.17.3.tar.gz && \
    tar -xzvf IEDB_MHC_II-2.17.3.tar.gz 
RUN PATH=/usr/bin wget https://bootstrap.pypa.io/ez_setup.py -O - | /usr/bin/python
WORKDIR mhc_ii
RUN PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin /usr/bin/python2.7 configure.py


#
# # Download Example Data
# 

RUN pvacseq download_example_data /
RUN mkdir -p /test_output

# NOTE: this is not just path issues, the example data needs to be in right spot
#RUN pvacseq run /pvacseq_example_data/input.vcf Test HLA-G*01:09,HLA-E*01:01,H2-IAb \
#                NetMHC PickPocket NNalign /test_output \
#                -e 9,10 \
#                -i /pvacseq_example_data/additional_input_file_list.yaml --tdna-vaf 20 \
#                --net-chop-method cterm --netmhc-stab \
#                --top-score-metric=lowest -d full --keep-tmp-files
