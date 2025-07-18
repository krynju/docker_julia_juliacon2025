FROM julia:1.11

ENV JULIA_CPU_TARGET=generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)

WORKDIR /myproject

COPY PackageA PackageA
COPY PackageB PackageB
COPY mvdepot.jl mvdepot.jl

RUN mkdir /root/.julia

RUN --mount=type=cache,id=packageabuild,target=/root/.julia,sharing=shared \
    julia --project=/myproject/PackageA -e "using Pkg; Pkg.instantiate(); Pkg.API.precompile()"

RUN --mount=type=cache,id=packageabuild,target=/root/.julia_2,sharing=shared \
    JULIA_DEPOT_PATH=/root/.julia_2: julia --project=/myproject/PackageA mvdepot.jl /root/.julia

CMD ["julia", "--project=/myproject/PackageA", "-e", "using PackageA: main; main()"]

