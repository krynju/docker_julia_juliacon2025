FROM julia:1.11

ENV JULIA_CPU_TARGET=generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)

WORKDIR /myproject

COPY PackageA PackageA
COPY PackageB PackageB

# Looks great, one run, should work?

RUN --mount=type=cache,id=packageabuild7,target=/root/.julia_2,sharing=private \
    ln -s /root/.julia_2 /root/.julia && \
    julia --project=/myproject/PackageA -e "using Pkg; Pkg.instantiate(); Pkg.API.precompile()" && \
    rm /root/.julia && \
    mkdir /root/.julia && \
    cp -Ra /root/.julia_2/* /root/.julia

CMD ["julia", "--project=/myproject/PackageA", "-e", "using PackageA: main; main()"]

