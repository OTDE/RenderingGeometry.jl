import Base:
    +, *, -, /, ==, √,
    isnan, abs, floor, ceil, min, max,
    convert, promote_rule, show

include("lib/component_types.jl")
include("lib/cartesian_pair.jl")
include("lib/cartesian_triple.jl")
include("lib/tuple_behavior.jl")
include("lib/point_behavior.jl")
include("lib/vector_behavior.jl")
include("lib/conversion.jl")
