export Vector2, Vector3, Point2, Point3, Normal3, convert

# Definitions for constructing and converting between types conveniently.

for type ∈ (:Vector2, :Vector3, :Point2, :Point3, :Normal3)
    @eval begin
        @inline Base.convert(::Type{$(type){T}}, a::$(type){U}) where {T,U<:Number} =
            $(type){T}(a)
    end
end

for type ∈ (:Vector3, :Point3, :Normal3)
    @eval begin
        $(type)(x::T, y::T, z::T) where T<:Number = $(type){T}(x, y, z)
        $(type)(x::Number, y::Number, z::Number) = $(type)(promote(x, y, z))
    end
end

Vector2(x::T, y::T) where T<:Number = Vector2{T}((x, y))
Vector2(x::Number, y::Number) = Vector2(promote(x, y))

Point2(x::T, y::T) where T<:Number = Point2{T}(x, y, z)
Point2(x::Number, y::Number) = Point2{T}(promote(x, y, z))

as_vector(::Type{Point2{T}}) where T<:Number = Vector2{T}
as_vector(::Type{Point3{T}}) where T<:Number = Vector3{T}

@inline Vector3(p::Point3{T}) where T<:Number = Vector3{T}(p)

@inline Vector3(n::Normal3{T}) where T<:Number = Vector3{T}(n)

@inline Normal3(v::Vector3{T}) where T<:Number = Normal3{T}(v)

@inline Point2(v::Vector2{T}) where T<:Number = Point2{T}(v.x, v.y)

@inline Point2(p::Point3{T}) where T<:Number = Point2{T}(p.x, p.y)

@inline Vector2(p::Point2{T}) where T<:Number = Vector2{T}(p.x, p.y)

@inline Vector2(p::Point3{T}) where T<:Number = Vector2{T}(p.x, p.y)
