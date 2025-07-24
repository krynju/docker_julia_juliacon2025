FROM julia:1.11

ENV JULIA_CPU_TARGET=generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)

WORKDIR /myproject

COPY PackageA PackageA
COPY PackageB PackageB

RUN mkdir /root/.julia

# Looks great, but doesn't work
# Some packages are not relocatable

RUN --mount=type=cache,id=packageabuild4,target=/root/.julia_2,sharing=private \
    JULIA_DEPOT_PATH=/root/.julia_2: julia --project=/myproject/PackageA -e "using Pkg; Pkg.instantiate(); Pkg.API.precompile()" && \
    cp -Ra /root/.julia_2/* /root/.julia

CMD ["julia", "--project=/myproject/PackageA", "-e", "using PackageA: main; main()"]

