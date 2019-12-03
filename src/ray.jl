export Ray

struct Ray{T<:Number}
    o::Point3{T}
    d::Vector3{T}
    time::T

    Ray{T}(o, d, time) where T = new{T}(o, d, time)

    Ray{T}() where T = new{T}(Point3{T}(), Vector3{T}(), 0.0)
end

Ray(o::Point3{T}, d::Vector3{T}, time::T) where T = Ray{T}(o, d, time)

Ray(o::Point3{T}, d::Vector3{U}, time::V) where {T,U,V} = Ray{promote_type(T, U, V)}(o, d, time)

Base.:(|>)(t::T, r::Ray{U}) where {T<:Number, U<:AbstractFloat} = r.o + r.d * t
