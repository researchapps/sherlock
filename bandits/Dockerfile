FROM continuumio/miniconda3

# docker build -t vanessa/jupyter-bandits .

ENV PATH /opt/conda/bin:$PATH
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \ 
    apt-get install -y wget git
RUN conda install matplotlib jupyter pandas seaborn numpy ipython && \
    git clone https://github.com/bgalbraith/bandits.git && \
    cd bandits && \
    pip install .
