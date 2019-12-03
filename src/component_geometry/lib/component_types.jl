abstract type ComponentType end
abstract type VecLike <:ComponentType end
struct Vec <:VecLike end
struct Pnt <:ComponentType end
struct Nrm <:VecLike end

name(x::Type{Vec}) = "Vector"
name(x::Type{Pnt}) = "Point"
name(x::Type{Nrm}) = "Normal"
