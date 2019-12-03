export ⋅, absdot, magnitude², magnitude, normalize,
×, coordinate_system_from, permute, face_forward

# General functions for VectorLikes.

@inline ⋅(u::VectorLike, v::VectorLike) = sum(u.coordinates .* v.coordinates)

@inline absdot(u::VectorLike, v::VectorLike) = abs(u ⋅ v)

@inline magnitude²(v::VectorLike) = v ⋅ v

@inline magnitude(v::VectorLike) = √(magnitude²(v))

@inline normalize(v::VectorLike) = v / magnitude(v)

@inline Base.min(a::Vect{N,T}, b::Vect{N,U}) where {N,T,U} = promote_type(typeof(a), typeof(b))(min.(a.coordinates, b.coordinates)...)

@inline Base.max(a::Vect{N,T}, b::Vect{N,U}) where {N,T,U} = promote_type(typeof(a), typeof(b))(max.(a.coordinates, b.coordinates)...)

# Vector3-specific functions.

@inline ×(a::VectorLike{3,T}, b::VectorLike{3,U}) where {T,U} =
        Vector3{promote_type(T,U)}(
            a.y * b.z - a.z * b.y,
            a.z * b.x - a.x * b.z,
            a.x * b.y - a.y * b.x)

@inline face_forward(u::VectorLike{3,T}, v::VectorLike{3,U}) where {T,U} =
        u ⋅ v < zero(promote_type(T,U)) ? -u : u

@inline function coordinate_system_from(v₁::Vector3{T}) where T
    if abs(v₁.x) > abs(v₁.y)
        v₂ = typeof(v₁)(-v₁.z, 0.0, v₁.x) / √(v₁.x * v₁.x + v₁.z * v₁.z)
    else
        v₂ = typeof(v₂)(0.0, v₁.z, -v₁.y) / √(v₁.y * v₁.y + v₁.z * v₁.z)
    end
    v₁, v₂, v₁ × v₂
end

@inline permute(a::Vector3{T}, (x, y, z)) where T = typeof(a)(a[x], a[y], a[z])
