export Ray, scale_differentials, point_at

struct Ray
    o::Point3d
    d::Vector3d
    time::Float64

    Ray(o, d, time) where T<:Number = new(o, d, time)

    Ray() = new(Point3d(), Vector3d(), 0.0)
end

scale_differentials((ray, rₓ, rᵧ)::NTuple{3,Ray}, s::T) where T<:Real =
    (ray,
    Ray(ray.o + (rₓ.o - o) * s, ray.d + (rₓ.d - d) * s),
    Ray(ray.o + (rᵧ.o - o) * s, ray.d + (rᵧ.d - d) * s))

point_at(r::Ray, t::T) where T<:Real = r.o + r.d * t
