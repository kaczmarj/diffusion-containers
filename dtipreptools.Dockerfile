FROM debian:stretch

WORKDIR /opt/dtipreptools
RUN apt-get update \
    && apt-get install --yes --no-install-recommends --quiet \
        ca-certificates \
        curl \
        libglu1-mesa \
        libgl1-mesa-glx \
        libtiff5 \
        qt4-default \
    && curl -fsSL --retry 5 https://www.nitrc.org/frs/download.php/10085/DTIPrepTools-1.2.8-Linux.tar.gz \
    | tar xz --strip-components 1 \
    # Symlink the newer version of libtiff5 to libtiff3. This is an ugly hack,
    # but libtiff3 is not available in this distribution.
    && ln -s /usr/lib/x86_64-linux-gnu/libtiff.so.5 /usr/lib/x86_64-linux-gnu/libtiff.so.3
ENV PATH="/opt/dtipreptools/bin:$PATH"
WORKDIR /work
