FROM julia:1.11

ENV JULIA_CPU_TARGET=generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)

WORKDIR /myproject

COPY PackageA PackageA
COPY PackageB PackageB

CMD ["julia", "--project=/myproject/PackageA", "-e", "using Pkg; Pkg.API.precompile(); using PackageA: main; main()"]

