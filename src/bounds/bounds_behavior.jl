# In progress!

export diagonal

==(a::Bounds{N, T}, b::Bounds{N, T}) where {T<:Number, N} =
    a.p_min == b.p_min && a.p_max == b.p_max

diagonal(b::Bounds) = b.p_max - b.p_min

max_extent(b::Bounds) = argmax(diagonal(b))

# Bounds2 functions.

function area(b::Bounds2{T}) where T<:Number
    d = b.p_max - b.p_min
    d.x * d.y
end

lerp(b::Bounds2{T}, t::Point2f) where T<:Number =
    Point2(lerp(t.x, b.p_min.x, b.p_max.x), lerp(t.y, b.p_min.y, b.p_max.y))
