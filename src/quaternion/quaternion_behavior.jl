
Base.:+(q₁::Quaternion{T}, q₂::Quaternion{U}) where {T<:AbstractFloat, U<:AbstractFloat} =
    Quaternion{promote_type(T,U)}(q₁.v + q₂.v, q₁.w + q₂.w)

Base.:-(q₁::Quaternion{T}, q₂::Quaternion{U}) where {T<:AbstractFloat, U<:AbstractFloat} =
    Quaternion{promote_type(T,U)}(q₁.v - q₂.v, q₁.w - q₂.w)

function Base.:*(q::Quaternion{T}, c::U) where {T<:AbstractFloat, U<:AbstractFloat}
    @assert !isnan(c)
    Quaternion{promote_type(T,U)}(q.v * c, q.w * c)
end

Base.:*(c::U, q::Quaternion{T}) where {T<:AbstractFloat, U<:AbstractFloat} = q * c

function Base.:/(q::Quaternion{T}, c::U) where {T<:AbstractFloat, U<:AbstractFloat}
    @assert c != 0.0
    q * (1.0 / c)
end

⋅(q₁::Quaternion{T}, q₂::Quaternion{U}) where {T<:AbstractFloat, U<:AbstractFloat} = q₁.v ⋅ q₂.v + q₁.w * q₂.w

normalize(q::Quaternion{T}) where T<:AbstractFloat = q / √(q ⋅ q)

function slerp(t::T, q₁::Quaternion{U}, q₂::Quaternion{V}) where {T<:AbstractFloat, U<:AbstractFloat, V<:AbstractFloat}
    cosθ = q₁ ⋅ q₂
    if cosθ > 0.9995
        return normalize((1.0 - t) * q₁ + t * q₂)
    else
        θ = acos(clamp(cosθ, -1.0, 1.0))
        θₚ = θ * t
        q⟂ = normalize(q₂ - q₁ * cosθ)
        return q₁ * cos(θₚ) + q⟂ * sin(θₚ)
    end
end
