FROM debian:latest AS builder

RUN apt-get update && apt-get install -y git cmake

RUN git config --global http.sslVerify false && \
    git clone --recursive https://github.com/rozhuk-im/msd_lite.git

RUN cd msd_lite &&  \
    mkdir build &&  \
    cd build &&  \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-O2 -pipe -static" -DCMAKE_CXX_FLAGS="-O2 -pipe -static" -DCMAKE_EXE_LINKER_FLAGS="-static -s" .. &&  \
    make &&  \
    make install


FROM scratch

COPY --from=builder /usr/local/bin/msd_lite /usr/local/bin/msd_lite
COPY msd_lite.conf /etc/msd_lite/msd_lite.conf


ENTRYPOINT ["/usr/local/bin/msd_lite"]



