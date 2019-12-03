export ⋅, normalize, slerp

Base.:(+)(q₁::Quaternion{T}, q₂::Quaternion{U}) where {T,U} = Quaternion{promote_type(T,U)}(q₁.v + q₂.v, q₁.w + q₂.w)

Base.:(-)(q₁::Quaternion{T}, q₂::Quaternion{U}) where {T,U} = Quaternion{promote_type(T,U)}(q₁.v - q₂.v, q₁.w - q₂.w)

function Base.:(*)(q::Quaternion{T}, c::U) where {T, U<:Number}
    @assert !isnan(c)
    Quaternion{promote_type(T,U)}(q.v * c, q.w * c)
end

Base.:(*)(c::U, q::Quaternion{T}) where {T,U} = q * c

function Base.:(/)(q::Quaternion{U}, c::T) where {T<:Number,U}
    @assert c != zero(T)
    q * (one(U) / c)
end

⋅(q₁::Quaternion, q₂::Quaternion) = q₁.v ⋅ q₂.v + q₁.w * q₂.w

normalize(q::Quaternion) = q / √(q ⋅ q)

function slerp(t::T, q₁::Quaternion, q₂::Quaternion) where {T<:Number,U,V}
    cosθ = q₁ ⋅ q₂
    if cosθ > 0.9995
        return normalize((one(T) - t) * q₁ + t * q₂)
    else
        θ = acos(clamp(cosθ, -one(T), one(T)))
        θₚ = θ * t
        q⟂ = normalize(q₂ - q₁ * cosθ)
        return q₁ * cos(θₚ) + q⟂ * sin(θₚ)
    end
end
