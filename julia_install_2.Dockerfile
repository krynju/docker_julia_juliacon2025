FROM debian:12 AS julia-stage

ARG PLATFORM=linux
ARG SHORT_ARCH=x64
ARG ARCH=x86_64
ARG JULIA_VERSION=1.11.5
ARG JULIA_VERSION_SHORT=1.11

WORKDIR /tmp
ADD https://julialang-s3.julialang.org/bin/${PLATFORM}/${SHORT_ARCH}/${JULIA_VERSION_SHORT}/julia-${JULIA_VERSION}-${PLATFORM}-${ARCH}.tar.gz \
    /tmp/julia.tar.gz

RUN mkdir /tmp/julia && \
    tar -xzf /tmp/julia.tar.gz --strip-components=1 -C /tmp/julia

###############################################################################
FROM debian:12 AS main-stage

COPY --chown=0:0 --link --from=julia-stage /tmp/julia /opt/julia
RUN ln -s /opt/julia/bin/julia /usr/bin/julia
