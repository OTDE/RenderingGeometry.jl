# Math functions unrelated to any particular structure.

@inline lerp(t::AbstractFloat, v₁::AbstractFloat, v₂::AbstractFloat) =
    (1.0 - t) * v₁ + t * v₂

@inline Γ(n::T) where T<:AbstractFloat = (n * eps(T)) / (1 - n * eps(T))
