export |>, absolute_error

function Base.:|>(t::Transform{T}, p::Point{3,U}) where {T<:AbstractFloat, U<:Number}
    (xₚ, yₚ, zₚ, wₚ) = sum(transpose(t.m[:,StaticArrays.SUnitRange(1,3)]) .* p,), dims=1) .+ transpose(t.m[:,StaticArrays.SUnitRange(4,4))]
    return wₚ ≈ 1 ? promote_type(T, typeof(p))(xₚ, yₚ, zₚ) / wₚ : promote_type(T, typeof(p))(xₚ, yₚ, zₚ)
end

absolute_error(t::Transform{T}, p::Point{N,U}) where {N,T<:Number, U<:Number} =
    Γ(3.0) * as_vector(promote_type(T, typeof(p)))(
        sum(abs.(transpose(t.m[StaticArrays.SUnitRange(1,3), StaticArrays.SUnitRange(1,3)]) .* p), dims=1))

Base.:|>(t::Transform{T}, v::Vector{3,U}) where {T<:AbstractFloat, U<:Number} =
    promote_type(T, typeof(v))(
        sum(transpose(t.m[StaticArrays.SUnitRange(1,3), StaticArrays.SUnitRange(1,3)]) .* v, dims=1))

Base.:|>(t::Transform{T}, n::Normal{3,U}) where {T<:AbstractFloat, U<:Number} =
    promote_type(T, typeof(v))(
        sum(transpose(t.m_inv[StaticArrays.SUnitRange(1,3), StaticArrays.SUnitRange(1,3)]) .* n, dims=1))

function Base.:|>(t::Transform{T}, r::Ray{U}) where {T<:AbstractFloat, U<:AbstractFloat}
    m² = magnitude²(r.d)
    if m² > 0.0
        δₜ = (abs(r.d) ⋅ absolute_error(t, r.o)) / m²
        o = r.o + r.d * δₜ
        return Ray{promote_type(T,U)}(t |> o, t |> r.d, r.time)
    end
    Ray{promote_type(T,U)}(t |> r.o, t |> r.d, r.time)
end

function Base.:|>(t::Transform{T}, b::Bounds{N,U}) where {N,T<:AbstractFloat, U<:AbstractFloat}
    promote_type(typeof(b), T)(
        sum(min.(
            t.m[StaticArrays.SUnitRange(1,3), StaticArrays.SUnitRange(1,4)] .* b.p_min,
            t.m[StaticArrays.SUnitRange(1,3), StaticArrays.SUnitRange(1,4)] .* b.p_max)),
        sum(max.(
            t.m[StaticArrays.SUnitRange(1,3), StaticArrays.SUnitRange(1,4)] .* b.p_min,
            t.m[StaticArrays.SUnitRange(1,3), StaticArrays.SUnitRange(1,4)] .* b.p_max)))
end
