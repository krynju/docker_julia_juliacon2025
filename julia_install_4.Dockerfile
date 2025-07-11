FROM debian:12 AS julia-stage

ARG JULIA_VERSION=1.11.5

WORKDIR /tmp

RUN apt-get update && apt-get install --no-install-recommends -y \
    ca-certificates \
    curl

ADD https://install.julialang.org /tmp/install.sh

RUN sh /tmp/install.sh -y --default-channel ${JULIA_VERSION}

###############################################################################
FROM debian:12 AS main-stage

COPY --chown=0:0 --link --from=julia-stage /root/.juliaup /root/.juliaup
COPY --chown=0:0 --link --from=julia-stage /root/.julia   /root/.julia  
COPY --chown=0:0 --link --from=julia-stage /root/.bashrc  /root/.bashrc
COPY --chown=0:0 --link --from=julia-stage /root/.profile /root/.profile
