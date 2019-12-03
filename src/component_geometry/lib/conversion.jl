# Definitions for converting between types.

Base.convert(::Type{CartesianTuple{N,S,U}}, t::CartesianTuple{N,T,U}) where {N,S,T,U} = CartesianTuple{N,S,U}(t.coordinates...)
Base.convert(::Type{CartesianTuple{N,S,U}}, t::CartesianTuple{N,T,V}) where {N,S,T, U<:VecLike, V<:VecLike} = CartesianTuple{N,S,U}(t.coordinates...)
Base.convert(::Type{Vect{N,S}}, p::Point{N,T}) where {N,S,T} = Vect{N,S}(p.coordinates...)
Base.convert(::Type{CartesianPair{S,U}}, p::Point3{T}) where {S,T,U} = CartesianPair{S,U}(p[1:2]...)
Base.convert(::Type{Point2{S}}, v::Vector2{T}) where {S,T} = Point2{S}(v.coordinates...)

# Promotion rules for Cartesian Tuples.

Base.promote_rule(::Type{CartesianTuple{N,S,U}}, ::Type{CartesianTuple{N,T,U}}) where {N,S,T,U} = CartesianTuple{N, promote_type(S,T), U}
Base.promote_rule(::Type{CartesianTuple{N,S,U}}, ::Type{T}) where {N,S,T,U} = CartesianTuple{N, promote_type(S,T), U}

# Convenience constructors.

for type ∈ (:Vector2, :Point2, :Vector3, :Point3, :Normal3)
    @eval begin
        $(type)(args::Vararg{T, size($(type){T})}) where T = $(type){T}(args...)
        $(type)(args::Vararg{Any, size($(type){T})}) where T = $(type)(promote(args...)...)
        $(Symbol("$(type)f"))(args::Vararg{T, size($(type){T})}) where T<:AbstractFloat = $(type){T}(args...)
        $(Symbol("$(type)f"))(args::Vararg{AbstractFloat, size($(type){T})}) where T = $(type)(promote(args...)...)
        $(Symbol("$(type)f"))(args::Vararg{Any, size($(type){T})}) where T = $(type)(convert.(AbstractFloat, args)...)
    end
end
