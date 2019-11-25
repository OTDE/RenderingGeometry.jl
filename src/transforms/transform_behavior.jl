export inv, transpose, translate, scale, has_scale,
rotate_x, rotate_y, rotate_z, rotate, look_at, *, swaps_handedness

Base.inv(t::Transform{T}) where T<:AbstractFloat = Transform{T}(t.m_inv, t.m)

Base.transpose(t::Transform{T}) where T<:AbstractFloat =
    Transform{T}(transpose(t.m), transpose(t.m_inv))

function translate(Δ::Vector{3,T}) where T<:AbstractFloat
    m = SMatrix{4,4,T}(
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        Δ.x, Δ.y, Δ.z, 1.0)
    m_inv = SMatrix{4,4,T}(
         1.0,  0.0, 0.0, 0.0,
         0.0,  1.0, 0.0, 0.0,
         0.0,  0.0, 1.0, 0.0,
        -Δ.x, -Δ.y, Δ.z, 1.0)
    Transform{T}(m, m_inv)
end

function scale(x::T, y::U, z::V) where {T<:AbstractFloat, U<:AbstractFloat, V<:AbstractFloat}
    m = SMatrix{4,4,promote_type(T,U,V)}(
        x,   0.0, 0.0, 0.0,
        0.0, y,   0.0, 0.0,
        0.0, 0.0, z,   0.0,
        0.0, 0.0, 0.0, 1.0)
    m_inv = SMatrix{4,4,promote_type(T,U,V)}(
         1.0/x, 0.0,   0.0,   0.0,
         0.0,   1.0/y, 0.0,   0.0,
         0.0,   0.0,   1.0/z, 0.0,
         0.0,   0.0,   0.0,   1.0)
    Transform{T}(m, m_inv)
end

function has_scale(t::Transform{T}) where T<:AbstractFloat
    @. axes = magnitude² |> t |> (Vector3{T}(1,0,0), Vector3{T}(0,1,0), Vector3{T}(0,0,1))
    all(axes .≈ 1.0)
end

function rotate_x(θ::T) where T<:AbstractFloat
    sinθ = (sin ∘ deg2rad)(θ)
    cosθ = (cos ∘ deg2rad)(θ)
    m = SMatrix{4,4,T}(
        1.0,  0.0,  0.0,  0.0,
        0.0,  cosθ, sinθ, 0.0,
        0.0, -sinθ, cosθ, 0.0,
        0.0,  0.0,  0.0,  1.0)
    Transform{T}(m, transpose(m))
end

function rotate_y(θ::T) where T<:AbstractFloat
    sinθ = (sin ∘ deg2rad)(θ)
    cosθ = (cos ∘ deg2rad)(θ)
    m = SMatrix{4,4,T}(
        cosθ, 0.0, -sinθ, 0.0,
        0.0,  1.0,  0.0,  0.0,
        sinθ, 0.0,  cosθ, 0.0,
        0.0,  0.0,  0.0,  1.0)
    Transform{T}(m, transpose(m))
end

function rotate_z(θ::T) where T<:AbstractFloat
    sinθ = (sin ∘ deg2rad)(θ)
    cosθ = (cos ∘ deg2rad)(θ)
    m = SMatrix{4,4,T}(
         cosθ, sinθ, 0.0, 0.0,
        -sinθ, cosθ, 0.0, 0.0,
         0.0,  0.0,  1.0, 0.0,
         0.0,  0.0,  0.0, 1.0)
    Transform{T}(m, transpose(m))
end

function rotate(θ::T, axis::Vector{3,U}) where {T<:AbstractFloat, U<:AbstractFloat}
    aₙ = normalize(axis)
    sinθ = (sin ∘ deg2rad)(θ)
    cosθ = (cos ∘ deg2rad)(θ)
    m = SMatrix{4,4,promote_type(T,U)}(
        a.x * a.x + (1 - a.x * a.x) * cosθ,
        a.x * a.y * (1 - cosθ) + a.z * sinθ,
        a.x * a.z * (1 - cosθ) - a.y * sinθ,
        0.0,
        a.x * a.y * (1 - cosθ) - a.z * sinθ,
        a.y * a.y + (1 - a.y * a.y) * cosθ,
        a.y * a.z * (1 - cosθ) + a.x * sinθ,
        0.0,
        a.x * a.z * (1 - cosθ) + a.y * sinθ,
        a.y * a.z * (1 - cosθ) - a.x * sinθ,
        a.z * a.z + (1 - a.z * a.z) * cosθ,
        0.0,
        0.0, 0.0, 0.0, 1.0)
    Transform{T}(m, transpose(m))
end

# I'm very sorry. I've learned about adding latex symbols and I can't stop. Please understand.
function look_at(📷::Point{3,T}, at::Point{3,U}, up::Vector{3,V}) where {T<:AbstractFloat, U<:AbstractFloat, V<:AbstractFloat}
    ↗ = normalize(at - eye)
    ← = normalize(normalize(up) × direction)
    ↑ = ↗ × ←
    m = SMatrix{4,4,promote_type(T,U,V)}(
        ←.x,  ←.y,   ←.z,  0.0,
        ↑.x,  ↑.y,   ↑.z,  0.0,
        ↗.x,  ↗.y,   ↗.z,  0.0,
        📷.x, 📷.y, 📷.z, 1.0)
    Transform(inv(m), m)
end

Base.*(t::Transform{T}, u::Transform{U}) where {T<:AbstractFloat} =
    Transform{promote_type(T,U)}(t.m * u.m, u.m_inv * t.m_inv)

swaps_handedness(t::Transform{T}) where T<:AbstractFloat =
    det(t.m[StaticArrays.SUnitRange(1,3), StaticArrays.SUnitRange(1,3)]) < 0.0

function Transform(q::Quaternion{T}) where T<:AbstractFloat
    m = SMatrix{4,4,T}(
        1 - 2 * (q.v.y * q.v.y + q.v.z * q.v.z),
        2 * (q.v.x * q.v.y + q.w * q.v.z),
        2 * (q.v.x * q.v.z - q.w * q.v.y),
        0.0,
        2 * (q.v.x * q.v.y - q.w * q.v.z),
        1 - 2 * (q.v.x * q.v.x + q.v.z * q.v.z),
        2 * (q.v.y * q.v.z + q.w * q.v.x),
        0.0,
        2 * (q.v.x * q.v.z + q.w * q.v.y),
        2 * (q.v.y * q.v.z - q.w * q.v.x),
        1 - 2 * (q.v.x * q.v.x + q.v.y * q.v.y),
        0.0,
        0.0, 0.0, 0.0, 1.0)
    Transform{T}(m, transpose(m))
end
