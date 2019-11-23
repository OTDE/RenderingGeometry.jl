# Math functions unrelated to any particular structure.

@inline lerp(t::AbstractFloat, v₁::AbstractFloat, v₂::AbstractFloat) =
    (1.0 - t) * v₁ + t * v₂
