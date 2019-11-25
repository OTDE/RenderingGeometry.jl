export Ray, point_at
# TODO: make this generic like the vec/point/norm library
struct Ray{T<:AbstractFloat}
    o::Point3{T}
    d::Vector3{T}
    time::T

    Ray{T}(o, d, time) where T<:AbstractFloat = new{T}(o, d, time)

    Ray{T}() where T<:AbstractFloat = new{T}(Point3{T}(), Vector3{T}(), 0.0)
end

Ray(o::Point3{T}, d::Vector3{T}, time::T) where T<:AbstractFloat = Ray{T}(o, d, time)

Ray(o::Point3{T}, d::Vector3{U}, time::V) where {T<:AbstractFloat, U<:AbstractFloat, V<:AbstractFloat} =
    Ray{promote_type(T, U, V)}(o, d, time)

Base.:|>(t::T, r::Ray{U}) where {T<:Number, U<:AbstractFloat} = r.o + r.d * t
