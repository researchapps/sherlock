FROM mono

# docker build -t vanessa/mono .

RUN apt-get update && apt-get install -y wget unzip
RUN wget http://ms.imp.ac.at/index.php?file=MSAmanda2.0_Standalone_2.0.0.11219.zip -O MSAmanda.zip && \
    unzip MSAmanda.zip
CMD ["mono", "/MSAmanda.exe"]

# mono MSAmanda.exe -s spectrumFile -d proteinDatabase -e settings.xml [-f fileformat] [-o outputfilename]
