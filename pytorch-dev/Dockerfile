FROM pytorch/pytorch:0.4.1-cuda9-cudnn7-devel
MAINTAINER vsochat@stanford.edu
# docker build -t vanessa/pytorch-dev .
RUN apt-get update && \
    /opt/conda/bin/conda install -y matplotlib scikit-learn scikit-image
