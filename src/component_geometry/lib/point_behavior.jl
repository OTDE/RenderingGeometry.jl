export distance², distance, floor, ceil, min, max, lerp, permute

# Point functions

@inline distance²(p::Point{N,T}, q::Point{N,U}) where {T<:Number, U<:Number, N} = magnitude²(p - q)

@inline distance(p::Point{N,T}, q::Point{N,U}) where {T<:Number, U<:Number, N} = magnitude(p - q)

@inline floor(p::Point{N,T}) where {T<:Number, N} = typeof(p)(floor.(p))

@inline ceil(p::Point{N,T}) where {T<:Number, N} = typeof(p)(ceil.(p))

@inline min(a::Point{N,T}, b::Point{N,U}) where {T<:Number, U<:Number, N} =
            promote_type(typeof(a), typeof(b))(min.(a, b))

@inline max(a::Point{N,T}, b::Point{N,U}) where {T<:Number, U<:Number, N} =
            promote_type(typeof(a), typeof(b))(max.(a, b))

@inline lerp(t::AbstractFloat, p₀::Point{N,T}, p₁::Point{N,U}) where {T<:Number, U<:Number, N} =
    (1.0 - t) * p₀ + t * p₁

@inline permute(a::Point3{T}, (x, y, z)) where T<:Number = Point3{T}(a[x], a[y], a[z])

@inline -(a::Point2{T}, b::Point2{U}) where {T<:Number, U<:Number} =
    Vector2{promote_type(T,U)}(a .- b)

@inline -(a::Point3{T}, b::Point3{U}) where {T<:Number, U<:Number} =
    Vector3{promote_type(T,U)}(a .- b)
