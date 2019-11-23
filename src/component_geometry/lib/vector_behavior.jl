export ⋅, absdot, magnitude², magnitude, normalize, min, max, ×, coordinate_system_from, permute

# General functions for VectorLikes.

@inline ⋅(u::VectorLike{N,T}, v::VectorLike{N,U}) where {T<:Number, U<:Number, N} = sum(u .* v)

@inline absdot(u::VectorLike{N,T}, v::VectorLike{N,U}) where {T<:Number, U<:Number, N} = abs(u ⋅ v)

@inline magnitude²(v::VectorLike{N,T}) where {T<:Number, N} = sum(v .* v)

@inline magnitude(v::VectorLike{N,T}) where {T<:Number, N} = √(magnitude²(v))

@inline normalize(v::VectorLike{N,T}) where {T<:Number, N} = v / magnitude(v)

@inline min(a::CVector{N,T}, b::CVector{N,U}) where {T<:Number, U<:Number, N} =
            promote_type(typeof(a), typeof(b))(min.(a, b))

@inline max(a::CVector{N,T}, b::CVector{N,U}) where {T<:Number, U<:Number, N} =
            promote_type(typeof(a), typeof(b))(max.(a, b))

# Vector3-specific functions.

@inline ×(a::Vec3Like{T}, b::Vec3Like{U}) where {T<:Number, U<:Number} =
        Vector3(
            a.y * b.z - a.z * b.y,
            a.z * b.x - a.x * b.z,
            a.x * b.y - a.y * b.x)

@inline face_forward(u::Vec3Like{T}, v::Vec3Like{U}) where {T<:Number, U<:Number} =
        u ⋅ v < 0.0 ? -u : u

@inline function coordinate_system_from(v₁::Vector3{T}) where T<:Number
    if abs(v₁.x) > abs(v₁.y)
        v₂ = Vector3{T}(-v₁.z, 0.0, v₁.x) / √(v₁.x * v₁.x + v₁.z * v₁.z)
    else
        v₂ = Vector3{T}(0.0, v₁.z, -v₁.y) / √(v₁.y * v₁.y + v₁.z * v₁.z)
    end
    v₁, v₂, v₁ × v₂
end

@inline permute(a::Vector3{T}, (x, y, z)) where T<:Number = Vector3{T}(a[x], a[y], a[z])
