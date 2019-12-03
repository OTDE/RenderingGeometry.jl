export diagonal, max_extent, overlaps, ⋸, lerp, expand, offset,
bounding_sphere, area, corner, surface_area, volume, axis_offset

Base.:(==)(a::Bounds{N,S,U}, b::Bounds{N,T,V}) where {N,S,T,U,V} = a.p_min == b.p_min && a.p_max == b.p_max

diagonal(b::Bounds) = b.p_max - b.p_min

Base.size(b::Bounds) = prod(diagonal(b))

max_extent(b::Bounds) = argmax(diagonal(b))

Base.:∪(a::Bounds{N,S,U}, b::Bounds{N,T,V}) where {N,S,T,U,V} = promote_type(typeof(a), typeof(b))(min(a.p_min, b.p_min,), max(a.p_max, b.p_max))

Base.:∪(b::Bounds{N,S,U}, p::Point{N,T}) where {N,S,T,U} = promote_type(typeof(a), typeof(b))(min(b.p_min, p), max(b.p_max, p))

Base.:∩(a::Bounds{N,S,U}, b::Bounds{N,T,V}) where {N,S,T,U,V} = promote_type(typeof(a), typeof(b))(max(a.p_min, b.p_min), min(a.p_max, b.p_max))

overlaps(a::Bounds, b::Bounds) = all(a.p_max .>= b.p_min) && all(a.p_min .<= b.p_max)

⋸(p::Point, b::Bounds) = all(p .>= b.p_min) && all(p .<= b.p_max)

Base.:∈(p::Point, b::Bounds) = all(p .> b.p_min) && all(p .< b.p_max)

lerp(b::Bounds{N,T,U}, p::Point) where {N,T,U} = promote_type(U, typeof(p))(lerp.(p, b.p_min, b.p_max))

expand(b::Bounds{N,S,U}, Δ::T) where {N,S,T<:Number, U} = Bounds(b.p_min - Vect{N,T}(Δ), b.p_max - Vect{N,T}(Δ))

function offset(b::Bounds{N,S,U}, p::Point{N,T}) where {N,S,T,U}
    o = p - b.p_min
    Vect{N,T}(axis_offset.(o, b.p_min, b.p_max))
end

function bounding_sphere(b::Bounds{N,T,U}) where {N,T,U}
    center = b.p_min - b.p_max
    radius = center ∈ b ? distance(center, b.p_max) : Vect{N,T}()
    (center, radius)
end

# Bounds2 functions.

area(b::Bounds2{T}) where T<:Number = size(b)

# Bounds3 functions.

corner(i::Int, b::Bounds3{T}) where T =
    Point3{T}(
        b[2 - i & 1].x,
        b[((i - 1) & 2) >> 1 + 1].y,
        b[((i - 1) & 4) >> 2 + 1].z)

function surface_area(b::Bounds3{T}) where T
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
