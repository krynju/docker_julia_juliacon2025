module PackageA

using DataFrames
using PackageB: something_from_package_b

function main()
    r = something_from_package_b(7)
    @info r
    return
end

end