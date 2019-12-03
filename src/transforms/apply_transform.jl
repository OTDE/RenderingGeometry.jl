export absolute_error

function Base.:(|>)(t::Transform{T}, p::Point{3,U}) where {T,U}
    (xₚ, yₚ, zₚ, wₚ) = sum(transpose(t.m[:,StaticArrays.SUnitRange(1,3)]) .* p,), dims=1) .+ transpose(t.m[:,StaticArrays.SUnitRange(4,4))]
    return wₚ ≈ 1 ? promote_type(T, typeof(p))(xₚ, yₚ, zₚ) / wₚ : promote_type(T, typeof(p))(xₚ, yₚ, zₚ)
end

absolute_error(t::Transform{T}, p::Point3{U}) where {T,U} =
    Γ(3.0) * Vector3{promote_type(T,U)}(
        sum(abs.(transpose(t.m[StaticArrays.SUnitRange(1,3), StaticArrays.SUnitRange(1,3)]) .* p), dims=1))

Base.:(|>)(t::Transform{T}, v::Vector3{U}) where {T,U} =
    Vector3{promote_type(T,U)}(
        sum(transpose(t.m[StaticArrays.SUnitRange(1,3), StaticArrays.SUnitRange(1,3)]) .* v, dims=1))

Base.:(|>)(t::Transform{T}, n::Normal3{U}}) where {T<:AbstractFloat, U<:Number} =
    Normal3{promote_type(T,U)}(
        sum(transpose(t.m_inv[StaticArrays.SUnitRange(1,3), StaticArrays.SUnitRange(1,3)]) .* n, dims=1))

function Base.:(|>)(t::Transform{T}, r::Ray{U}) where {T<:AbstractFloat, U<:AbstractFloat}
    m² = magnitude²(r.d)
    if m² > 0.0
        δₜ = (abs(r.d) ⋅ absolute_error(t, r.o)) / m²
        o = r.o + r.d * δₜ
        return Ray{promote_type(T,U)}(t |> o, t |> r.d, r.time)
    end
    Ray{promote_type(T,U)}(t |> r.o, t |> r.d, r.time)
end

function Base.:(|>)(t::Transform{T}, b::Bounds{N,U}) where {N,T,U}
    Bounds{N, promote_type(T,U)}(
        sum(min.(
            t.m[StaticArrays.SUnitRange(1,3), StaticArrays.SUnitRange(1,4)] .* b.p_min,
            t.m[StaticArrays.SUnitRange(1,3), StaticArrays.SUnitRange(1,4)] .* b.p_max)),
        sum(max.(
            t.m[StaticArrays.SUnitRange(1,3), StaticArrays.SUnitRange(1,4)] .* b.p_min,
            t.m[StaticArrays.SUnitRange(1,3), StaticArrays.SUnitRange(1,4)] .* b.p_max)))
end
