using Pkg
using UUIDs
using Artifacts

project_dir = dirname(Base.active_project())
target_depot = ARGS[1]
source_depot= Pkg.depots1()

manifest_path =joinpath(project_dir, "Manifest.toml")
manifest = Pkg.Types.read_manifest(manifest_path)

julia_version = VERSION
pkg_roots = String[]
pkg_roots_copy = String[]
compile_files = String[]

let 
    pkgid = Base.PkgId(Pkg.project().uuid, Pkg.project().name)
    compile_dir = Base.compilecache_dir(pkgid)
    if isdir(compile_dir)
        push!(compile_files, compile_dir)
    end
end

for (uuid, pkg) in manifest.deps
    pkgid = Base.PkgId(uuid, pkg.name)

    compile_dir = Base.compilecache_dir(pkgid)
    if isdir(compile_dir)
        push!(compile_files, compile_dir)
    end

    for (name, uuid2) in pkg.weakdeps
        pkgid = Base.PkgId(uuid2, name)

        compile_dir = Base.compilecache_dir(pkgid)
        if isdir(compile_dir)
            push!(compile_files, compile_dir)
        end
    end

    for (name, _) in pkg.exts
        pkgid = Base.PkgId(uuid, name)

        compile_dir = Base.compilecache_dir(pkgid)
        if isdir(compile_dir)
            push!(compile_files, compile_dir)
        end
    end
    

    if pkg.repo.source === nothing
        pkg_root = Pkg.Operations.source_path(manifest_path, pkg, julia_version)
        if isdir(pkg_root)
            push!(pkg_roots, pkg_root)
            push!(pkg_roots_copy, pkg_root)
        end
    else
        p = Pkg.Types.add_repo_cache_path(pkg.repo.source)
        if pkg.repo.subdir !== nothing
            pp = joinpath(p, pkg.repo.subdir)

            push!(pkg_roots, pp)
            push!(pkg_roots_copy, p)
        else 
            push!(pkg_roots, p)
            push!(pkg_roots_copy, p)
        end
    
    end

    
    
end

all_collected_artifacts = reduce(
    vcat,
    map(
        pkg_root ->
            Pkg.Operations.collect_artifacts(pkg_root; platform=Pkg.Operations.HostPlatform()),
        pkg_roots,
    ),
)

artifact_roots = String[]
for (art_toml, artifacts) in all_collected_artifacts
    for (art_name, art) in artifacts
        p = Artifacts.artifact_path(Artifacts.artifact_hash(art_name, art_toml))
        push!(artifact_roots, p)
    end
end

for p in [pkg_roots_copy..., artifact_roots..., compile_files...]
    if startswith(p, source_depot)
        pp = joinpath(target_depot, lstrip(chopprefix(p, source_depot), '/'))
        mkpath(dirname(pp))
        run(`cp -Ra $p $pp`)
    end
end

# Copy registries

run(`cp -Ra $(joinpath(source_depot, "registries")) $(joinpath(target_depot, "registries"))`)
# run(`cp -Ra $(joinpath(source_depot, "clones")) $(joinpath(target_depot, "clones"))`)
# run(`cp -Ra $(joinpath(source_depot, "logs")) $(joinpath(target_depot, "logs"))`)


# RUN --mount=type=cache,id=juliadepot_services,target=/juliateam/.julia2,uid=1000,gid=1000,sharing=shared \
#   JULIA_DEPOT_PATH=/juliateam/.julia2: julia --project=a ${IS}/mvdepot.jl  /juliateam/.julia