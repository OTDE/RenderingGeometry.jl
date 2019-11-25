export ⋅, absdot, magnitude², magnitude, normalize, min, max, ×,
coordinate_system_from, permute, face_forward

# General functions for VectorLikes.

@inline ⋅(u::VectorLike{N,T}, v::VectorLike{N,U}) where {T<:Number, U<:Number, N} = sum(u .* v)

@inline absdot(u::VectorLike{N,T}, v::VectorLike{N,U}) where {T<:Number, U<:Number, N} = abs(u ⋅ v)

@inline magnitude²(v::VectorLike{N,T}) where {T<:Number, N} = v ⋅ v

@inline magnitude(v::VectorLike{N,T}) where {T<:Number, N} = √(magnitude²(v))

@inline normalize(v::VectorLike{N,T}) where {T<:Number, N} = v / magnitude(v)

@inline Base.min(a::CVector{N,T}, b::CVector{N,U}) where {T<:Number, U<:Number, N} =
            promote_type(typeof(a), typeof(b))(min.(a, b))

@inline Base.max(a::CVector{N,T}, b::CVector{N,U}) where {T<:Number, U<:Number, N} =
            promote_type(typeof(a), typeof(b))(max.(a, b))

# Vector3-specific functions.

@inline ×(a::VectorLike{3,T}, b::VectorLike{3,U}) where {T<:Number, U<:Number} =
        promote_type(typeof(a), typeof(b))(
            a.y * b.z - a.z * b.y,
            a.z * b.x - a.x * b.z,
            a.x * b.y - a.y * b.x)

@inline face_forward(u::VectorLike{3,T}, v::VectorLike{3,U}) where {T<:Number, U<:Number} =
        u ⋅ v < 0.0 ? -u : u

@inline function coordinate_system_from(v₁::CVector{3,T}) where T<:Number
    if abs(v₁.x) > abs(v₁.y)
        v₂ = typeof(v₁)(-v₁.z, 0.0, v₁.x) / √(v₁.x * v₁.x + v₁.z * v₁.z)
    else
        v₂ = typeof(v₂)(0.0, v₁.z, -v₁.y) / √(v₁.y * v₁.y + v₁.z * v₁.z)
    end
    v₁, v₂, v₁ × v₂
end

@inline permute(a::CVector{3,T}, (x, y, z)) where T<:Number = typeof(a)(a[x], a[y], a[z])
