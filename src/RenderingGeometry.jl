module RenderingGeometry
    using StaticArrays
    include("utils.jl")
    include("component_geometry/lib.jl")
    include("ray.jl")
    include("bounds/bounds.jl")
    include("bounds/bounds_behavior.jl")
end
