export
Vector3i, Vector3f, Vector3d,
Point3i, Point3f, Point3d,
Normal3i, Normal3f, Normal3d,
show

"""
    CartesianTriple

Define an ordered triple in three-dimensional Cartesian space.

Use the fields to describe the positive or negative distance
along the x, y, and z axes.

"""
struct CartesianTriple{T<:Number, U<:ComponentType} <:CartesianTuple{3,T,U}

    x::T
    y::T
    z::T

    function CartesianTriple{T,U}(x, y, z) where {T<:Number, U<:ComponentType}
        @assert !isnan(x) && !isnan(y) && !isnan(z)
        new{T,U}(x, y, z)
    end

    function CartesianTriple{T,U}((x, y, z)::NTuple{3, S}) where {S<:Number, T<:Number, U<:ComponentType}
        @assert !isnan(x) && !isnan(y) && !isnan(z)
        new{T,U}(x, y, z)
    end

    function CartesianTriple{T,U}(a::S) where {S<:Number, T<:Number, U<:ComponentType}
        @assert !isnan(a)
        new{T,U}(a, a, a)
    end

    function CartesianTriple{T,U}() where {T<:Real, U<:ComponentType}
        new{T,U}(0, 0, 0)
    end

end

Base.show(io::IO, a::CartesianTriple{T,U}) where {T<:Number, U<:ComponentType} =
    print("3-dimensional $(name(U)) with $T vertices: ($(a.x), $(a.y), $(a.z))")

"""
    Typed Cartesian pairs

Use as a base for the public-facing 3D aliases.

"""
Vector3{T<:Real} = CartesianTriple{T, Vec}
Point3{T<:Real} = CartesianTriple{T, Pnt}
Normal3{T<:Real} = CartesianTriple{T, Nrm}

# Convenience type for overlapping behavior (dot, cross, etc.)
Vec3Like{T<:Real} = CartesianTriple{T, U} where U<:VecLike

# These let us define some generic operations on tuples while retaining type aliasing.

Base.promote_rule(::Type{Point3{T}}, ::Type{Vector3{U}}) where {T,U} = Point3{promote_type(T,U)}

Base.promote_rule(::Type{CartesianTriple{S,U}}, ::Type{CartesianTriple{T,U}}) where {S,T,U} =
    CartesianTriple{promote_type(S,T),U}

Base.promote_rule(::Type{CartesianTriple{S,U}}, ::Type{T}) where {S,T,U} =
    CartesianTriple{promote_type(S,T),U}

Base.promote_rule(::Type{Normal3{T}}, ::Type{Vector3{U}}) where {T,U} = Vector3{promote_type(T,U)}

"""
    Core 3D types

Use as the basis for Vector, Point, and Normal-based math in 2D.

"""
const Vector3i = Vector3{Int}
const Vector3f = Vector3{Float32}
const Vector3d = Vector3{Float64}

const Point3i = Point3{Int}
const Point3f = Point3{Float32}
const Point3d = Point3{Float64}

const Normal3i = Normal3{Int}
const Normal3f = Normal3{Float32}
const Normal3d = Normal3{Float64}
