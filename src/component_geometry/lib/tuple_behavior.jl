# Methods for accessing Cartesian Tuple metadata.

Base.summary(t::CartesianTuple{N,T,U}) where {N,T,U} = "$(N)-dimensional $(T) $(name(U))"
Base.show(io::IO, t::CartesianTuple) = print(io, "$(summary(t)) $(t.coordinates)")

# Iteration, indexing, and field access.

Base.iterate(t::CartesianTuple, state...) = iterate(t.coordinates, state...)
Base.length(t::CartesianTuple{N,T,U}) where {N,T,U} = size(N)
Base.size(::Type{CartesianTuple{N,T,U}}) where {N,T,U} = N
Base.eltype(::Type{CartesianTuple{N,T,U}}) where {N,T,U} = T

Base.getindex(a::CartesianTuple, inds...) = getindex(a.coordinates, inds...)

Base.getproperty(p::CartesianPair, s::Symbol) = @match s begin
        :x => p[1]
        :y => p[2]
        _  => getfield(p, s)
    end

Base.getproperty(t::CartesianTriple, s::Symbol) = @match s begin
        :x => t[1]
        :y => t[2]
        :z => t[3]
        _  => getfield(t, s)
    end

# General operations on Cartesian Tuples.

@inline Base.:(+)(a::CartesianTuple, b::CartesianTuple) = promote_type(typeof(a), typeof(b))(a.coordinates + b.coordinates)

@inline Base.:(-)(a::VectorLike, b::VectorLike) = promote_type(typeof(a), typeof(b))(a.coordinates - b.coordinates)

@inline function Base.:(*)(a::CartesianTuple, b::Number)
                @assert !isnan(b)
                promote_type(typeof(a), typeof(b))(a.coordinates .* b)
        end

@inline Base.:(*)(a::Number, b::CartesianTuple) = b * a

@inline function Base.:(/)(a::CartesianTuple, b::Number)
                @assert b != zero(typeof(b))
                inverse = one(eltype(a)) / b
                a * inverse
        end

@inline Base.:(==)(a::CartesianTuple{N,S,U}, b::CartesianTuple{N,T,U}) where {N,S,T,U} = a.coordinates == b.coordinates

@inline Base.:(==)(a::CartesianTuple{N,S,U}, b::CartesianTuple{N,T,V}) where {N,S,T,U,V} = false

@inline Base.abs(a::CartesianTuple) = typeof(a)(abs.(a.coordinates)...)

@inline Base.:(-)(a::CartesianTuple) = typeof(a)((-).(a.coordinates)...)

# Special behaviors for Point-Vector operations.

@inline Base.:(+)(a::Point{N,S}, b::Vect{N,T}) where {N,S,T} = promote_type(typeof(a), typeof(b))(a.coordinates + b.coordinates)

@inline Base.:(-)(a::Point{N,S}, b::Vect{N,T}) where {N,S,T} = promote_type(typeof(a), typeof(b))(a.coordinates - b.coordinates)
