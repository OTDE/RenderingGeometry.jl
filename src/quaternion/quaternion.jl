
struct Quaternion{T<:AbstractFloat}
    v::Vector{3,T}
    w::T

    Quaternion{T}(v, w) where T<:AbstractFloat = new{T}(v, w)

    Quaternion{T}() where T<:AbstractFloat = new{T}(Vector3{T}(), 0.0)
end

Quaternion(v::CVector{3, U}, w::T) where {T<:AbstractFloat, U<:AbstractFloat} =
    Quaternion{promote_type(T,U)}(v, w)
