abstract type ComponentType end
abstract type VecLike <:ComponentType end
struct Vec <:VecLike end
struct Pnt <:ComponentType end
struct Nrm <:VecLike end

name(x::Type{Vec}) = "Vector"
name(x::Type{Pnt}) = "Point"
name(x::Type{Nrm}) = "Normal"

promote_rule(::Type{T}, ::Type{Pnt}) where T<:VecLike = T

abstract type CartesianTuple{N, T<:Number, U<:ComponentType} <:FieldVector{N, T} end
VectorLike{N, T<:Number} = CartesianTuple{N, T, U} where U<:VecLike

CVector{N, T<:Number} = CartesianTuple{N, T, Vec}
Point{N, T<:Number} = CartesianTuple{N, T, Pnt}
Normal{N, T<:Number} = CartesianTuple{N, T, Nrm}
