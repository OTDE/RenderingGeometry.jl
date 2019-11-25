export ==, diagonal, size, max_extent, ∪, ∩, overlaps, ⋸, ∈,
lerp, expand, offset, bounding_sphere, area, corner, surface_area,
volume, axis_offset, iterate

Base.:(==)(a::Bounds{N,T,U}, b::Bounds{N,T,U}) where {N, T<:Number, U<:Point{N,T}} =
    a.p_min == b.p_min && a.p_max == b.p_max

Base.:(==)(a::Bounds{N,S,U}, b::Bounds{N,T,V}) where {N, S<:Number, T<:Number, U<:Point{N,S}, V<:Point{N,T}} =
    a.p_min == b.p_min && a.p_max == b.p_max

diagonal(b::Bounds) = b.p_max - b.p_min

Base.size(b::Bounds) = prod(diagonal(b))

max_extent(b::Bounds) = argmax(diagonal(b))

Base.:∪(a::Bounds{N,S,U}, b::Bounds{N,T,V}) where {N, S<:Number, T<:Number, U<:Point{N,S}, V<:Point{N,T}} =
    promote_type(typeof(a), typeof(b))(min(a.p_min, b.p_min,), max(a.p_max, b.p_max))

Base.:∪(b::Bounds{N,S,U}, p::Point{N,T}) where {N, S<:Number, T<:Number, U<:Point{N,S}} =
    promote_type(typeof(a), typeof(b))(min(b.p_min, p), max(b.p_max, p))

Base.:∩(a::Bounds{N,S,U}, b::Bounds{N,T,V}) where {N, S<:Number, T<:Number, U<:Point{N,S}, V<:Point{N,T}} =
    promote_type(typeof(a), typeof(b))(max(a.p_min, b.p_min), min(a.p_max, b.p_max))

overlaps(a::Bounds{N,S,U}, b::Bounds{N,T,V}) where {N, S<:Number, T<:Number, U<:Point{N,S}, V<:Point{N,T}} =
    all(a.p_max .>= b.p_min) && all(a.p_min .<= b.p_max)

⋸(p::Point{N,T}, b::Bounds{N,S,U}) where {N, S<:Number, T<:Number, U<:Point{N,S}} =
    all(p .>= b.p_min) && all(p .<= b.p_max)

Base.:∈(p::Point{N,T}, b::Bounds{N,S,U}) where {N, S<:Number, T<:Number, U<:Point{N,S}} =
    all(p .> b.p_min) && all(p .< b.p_max)

lerp(b::Bounds{N,S,U}, p::Point{N,T}) where {N, S<:Number, T<:Number, U<:Point{N,S}} =
    promote_type(typeof(p), S)(lerp.(p, b.p_min, b.p_max))

expand(b::Bounds{N,S,U}, Δ::T) where {N, S<:Number, T<:Number, U<:Point{N,S}} =
    Bounds3(b.p_min - as_vector(T)(Δ), b.p_max - as_vector(T)(Δ))

function offset(b::Bounds{N,S,U}, p::Point{N,T}) where {N, S<:Number, T<:Number, U<:Point{N,S}}
    o = p - b.p_min
    as_vector(T)(axis_offset.(o, b.p_min, b.p_max))
end

function bounding_sphere(b::Bounds{N,T,U}) where {N, T<:Number, U<:Point{N,T}}
    center = b.p_min - b.p_max
    radius = center ∈ b ? distance(center, b.p_max) : as_vector(U)()
    (center, radius)
end

# Bounds2 functions.

area(b::Bounds2{T}) where T<:Number = size(b)

# Bounds3 functions.

corner(i::Int, b::Bounds3{T}) where T<:Number =
    Point3{T}(
        b[2 - i & 1].x,
        b[((i - 1) & 2) >> 1 + 1].y,
        b[((i - 1) & 4) >> 2 + 1].z)

function surface_area(b::Bounds3{T}) where T<:Number
    d = diagonal(b)
    2 * (d.x * d.y + d.x * d.z + d.y * d.z)
end

volume(b::Bounds3{T}) where T<:Number = size(b)

# Bounds utility functions.

axis_offset(o::T, min::U, max::U) where {T<:Number, U<:Number} =
    max < min ? o : o / (max - min)

function Base.iterate(B::Bounds2i, state = B.p_min)
    x = state.x + 1
    if x == B.p_max.x
        x = B.p_min.x
        y = state.y + 1
    end
    return y == B.p_max.y ? nothing : (typeof(state)(x, y), typeof(state)(x, y))
end
