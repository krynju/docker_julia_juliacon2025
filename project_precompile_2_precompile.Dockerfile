FROM julia:1.11

ENV JULIA_CPU_TARGET=generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)

WORKDIR /myproject

COPY PackageA PackageA
COPY PackageB PackageB

RUN julia --project=/myproject/PackageA -e "using Pkg; Pkg.instantiate(); Pkg.API.precompile()"

CMD ["julia", "--project=/myproject/PackageA", "-e", "using PackageA: main; main()"]

