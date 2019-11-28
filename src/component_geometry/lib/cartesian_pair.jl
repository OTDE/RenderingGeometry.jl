export
Vector2i, Vector2f, Vector2d,
Point2i, Point2f, Point2d,
show

"""
    CartesianPair

Define an ordered pair in two-dimensional Cartesian space. Used as the
default implementation when another isn't provided by the user.

Use the fields to describe the positive or negative distance
along both the x and y axis.

"""
struct CartesianPair{T<:Number, U<:ComponentType} <:CartesianTuple{2, T, U}

    x::T
    y::T

    function CartesianPair{T,U}(x, y) where {T,U}
        @assert !isnan(x) && !isnan(y)
        new{T,U}(x, y)
    end

    function CartesianPair{T,U}((x, y)::NTuple{2, S}) where {S<:Number,T,U}
        @assert !isnan(x) && !isnan(y)
        new{T,U}(x, y)
    end

    function CartesianPair{T,U}(a::S) where {S<:Number,T,U}
        @assert !isnan(a)
        new{T,U}(a, a)
    end

    function CartesianPair{T,U}() where {T,U}
        new{T,U}(0, 0)
    end

end

"""
    Typed Cartesian pairs

Use as a base for the public-facing default 2D implementation.

"""
Vector2{T<:Number} = CartesianPair{T, Vec}
Point2{T<:Number} = CartesianPair{T, Pnt}

Base.promote_rule(::Type{Point2{T}}, ::Type{Vector2{U}}) where {T,U} =
    Point2{promote_type(T,U)}

Base.promote_rule(::Type{CartesianPair{S,U}}, ::Type{CartesianPair{T, U}}) where {S,T,U} =
        CartesianPair{promote_type(S, T), U}

Base.promote_rule(::Type{CartesianPair{T,U}}, ::Type{S}) where {S<:Number,T,U} =
        CartesianPair{promote_type(S, T), U}

Base.show(io::IO, a::CartesianPair{T,U}) where {T,U} =
    print("2-dimensional $(name(u)) with $T vertices: ($(a.x), $(a.y))")

"""
    Core 2D types

Use as the default cartesian types.

"""
const Vector2i = Vector2{Int}
const Vector2f = Vector2{Float32}
const Vector2d = Vector2{Float64}

const Point2i = Point2{Int}
const Point2f = Point2{Float32}
const Point2d = Point2{Float64}
