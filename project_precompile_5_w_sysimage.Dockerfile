FROM julia:1.11 AS base

ENV JULIA_CPU_TARGET=generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)

WORKDIR /myproject

COPY PackageA PackageA
COPY PackageB PackageB

RUN mkdir /root/.julia

# This FROM branches off the current context and we'll get back to it later
FROM base AS sysimage_build


RUN apt-get update && apt-get install --no-install-recommends -y g++

RUN --mount=type=cache,id=packageabuild,target=/root/.julia,sharing=private \
    julia -e " \
    using Pkg; Pkg.activate(;temp=true); Pkg.add(\"PackageCompiler\"); \
    using PackageCompiler; \
    create_sysimage(;sysimage_path=\"/sysimage.so\", project=\"/myproject/PackageA\", import_into_main=false, cpu_target=ENV[\"JULIA_CPU_TARGET\"])"


FROM base AS base-finish

COPY --from=sysimage_build /sysimage.so .

RUN --mount=type=cache,id=packageabuild,target=/root/.julia_2,sharing=private \
    cp -Ra /root/.julia_2/* /root/.julia

CMD ["julia", "--project=/myproject/PackageA", "-J", "sysimage.so", "-e", "using PackageA: main; main()"]

