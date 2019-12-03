
struct Quaternion{T<:Number}
    v::Vector3{T}
    w::T

    Quaternion{T}(v, w) where T = new{T}(v, w)

    Quaternion{T}() where T = new{T}(Vector3{T}(), one(T))
end

Quaternion(v::Vector3{U}, w::T) where {T,U} = Quaternion{promote_type(T,U)}(v, w)
