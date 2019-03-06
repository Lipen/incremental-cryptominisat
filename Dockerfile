FROM ubuntu:16.04 as build

RUN apt-get update &&\
    apt-get install --no-install-recommends -y software-properties-common &&\
    rm -rf /var/lib/apt/lists/*
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test &&\
    rm -rf /var/lib/apt/lists/*
RUN apt-get update &&\
    apt-get install --no-install-recommends -y libboost-program-options-dev gcc g++ make cmake git zlib1g-dev wget &&\
    rm -rf /var/lib/apt/lists/*

# get M4RI
RUN wget https://bitbucket.org/malb/m4ri/downloads/m4ri-20140914.tar.gz &&\
    tar -xvf m4ri-20140914.tar.gz
WORKDIR m4ri-20140914
RUN ./configure &&\
    make &&\
    make install &&\
    make clean

# build CMS
RUN git clone https://github.com/msoos/cryptominisat /cms
RUN mkdir /cms/build
WORKDIR /cms/build
RUN cmake -DSTATICCOMPILE=ON .. &&\
    make -j8 &&\
    make install

# build incremental-cryptominisat
COPY Makefile incremental-cryptominisat.cpp /icms/
WORKDIR /icms
RUN make &&\
    make install


FROM alpine:latest
COPY --from=build /usr/local/bin/incremental-cryptominisat /usr/local/bin
ENTRYPOINT ["usr/local/bin/incremental-cryptominisat"]
