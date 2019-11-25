export -, distance², distance, floor, ceil, min, max, lerp, permute

# Point functions.

@inline distance²(p::Point{N,T}, q::Point{N,U}) where {T<:Number, U<:Number, N} = magnitude²(p - q)

@inline distance(p::Point{N,T}, q::Point{N,U}) where {T<:Number, U<:Number, N} = magnitude(p - q)

@inline Base.floor(p::Point{N,T}) where {T<:Number, N} = typeof(p)(floor.(p))

@inline Base.ceil(p::Point{N,T}) where {T<:Number, N} = typeof(p)(ceil.(p))

@inline Base.min(a::Point{N,T}, b::Point{N,U}) where {T<:Number, U<:Number, N} =
            promote_type(typeof(a), typeof(b))(min.(a, b))

@inline Base.max(a::Point{N,T}, b::Point{N,U}) where {T<:Number, U<:Number, N} =
            promote_type(typeof(a), typeof(b))(max.(a, b))

@inline lerp(t::AbstractFloat, p₀::Point{N,T}, p₁::Point{N,U}) where {T<:Number, U<:Number, N} =
    (1.0 - t) * p₀ + t * p₁

@inline permute(a::Point{3,T}, (x, y, z)) where T<:Number = typeof(a)(a[x], a[y], a[z])

@inline Base.:-(a::Point{N,T}, b::Point{N,U}) where {T<:Number, U<:Number} =
    as_vector(promote_type(typeof(a), typeof(b)))(a .- b)
