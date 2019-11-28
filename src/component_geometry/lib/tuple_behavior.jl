export +, -, *, /, ==, abs, convert

# General operations on Cartesian Tuples.

@inline Base.:+(a::CartesianTuple, b::CartesianTuple) = promote_type(typeof(a), typeof(b))(a .+ b)

@inline Base.:-(a::VectorLike, b::VectorLike) = promote_type(typeof(a), typeof(b))(a .- b)

@inline function Base.:*(a::CartesianTuple, b::Number)
                @assert !isnan(b)
                promote_type(typeof(a), typeof(b))(a .* b)
        end

@inline Base.:*(a::Number, b::CartesianTuple) = b * a

@inline function Base.:/(a::CartesianTuple, b::Number)
                @assert b != zero(typeof(b))
                inverse = one(eltype(a)) / b
                a * inverse
        end

@inline Base.:(==)(a::CartesianTuple{N,S,U}, b::CartesianTuple{N,T,U}) where
                {S<:Number, T<:Number, U<:ComponentType, N} = all(a .== b)

@inline Base.:(==)(a::CartesianTuple{N,S,U}, b::CartesianTuple{N,T,V}) where
                {S<:Number, T<:Number, U<:ComponentType, V<:ComponentType, N} = false

@inline Base.abs(a::CartesianTuple) = typeof(a)(abs.(a))

@inline Base.:-(a::CartesianTuple) = typeof(a)((-).(a))

@inline Base.convert(::Type{CartesianTuple{N,S,U}}, a::CartesianTuple{N,T,U}) where {S<:Number, T<:Number, U<:ComponentType, N} =
                promote_type(typeof(a), S)(a)

# Special behaviors for Point-Vector operations.

@inline Base.:+(a::Point{N,S}, b::CVector{N,T}) where {N, S<:Number, T<:Number} =
        promote_type(typeof(a), typeof(b))(a .+ b)

@inline Base.:-(a::Point{N,S}, b::CVector{N,T}) where {N, S<:Number, T<:Number} =
        promote_type(typeof(a), typeof(b))(a .- b)
