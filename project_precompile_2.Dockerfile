FROM julia:1.11

WORKDIR /myproject

COPY PackageA PackageA
COPY PackageB PackageB

RUN mkdir /root/.julia

RUN --mount=type=cache,id=packageabuild,target=/root/.julia,sharing=private \
    julia --project=/myproject/PackageA -e "using Pkg; Pkg.instantiate(); Pkg.API.precompile()"

RUN --mount=type=cache,id=packageabuild,target=/root/.julia_2,sharing=private \
    cp -Ra /root/.julia_2/* /root/.julia

CMD ["julia", "--project=/myproject/PackageA", "-e", "using PackageA: main; main()"]

