export +, -, *, /, ==, abs, convert

# General operations on Cartesian Tuples.

@inline Base.:+(a::CartesianTuple{N,S,U}, b::CartesianTuple{N,T,U}) where
                {S<:Number, T<:Number, U<:ComponentType, N} = promote_type(typeof(a), typeof(b))(a .+ b)

@inline Base.:-(a::VectorLike{N,S}, b::VectorLike{N,T}) where
                {S<:Number, T<:Number, N} = promote_type(typeof(a), typeof(b))(a .- b)

@inline function Base.:*(a::CartesianTuple{N,S,U}, b::T) where {S<:Number, T<:Number, U<:ComponentType, N}
                @assert !isnan(b)
                promote_type(typeof(a), typeof(b))(a .* b)
        end

@inline Base.:*(a::T, b::CartesianTuple{N,S,U}) where
                {S<:Number, T<:Number, U<:ComponentType, N} = b * a

@inline function Base.:/(a::CartesianTuple{N,S,U}, b::T) where {S<:Number, T<:Number, U<:ComponentType, N}
                @assert b != zero(T)
                inverse = one(S) / b
                a * inverse
        end

@inline Base.:(==)(a::CartesianTuple{N,S,U}, b::CartesianTuple{N,T,U}) where
                {S<:Number, T<:Number, U<:ComponentType, N} = all(a .== b)

@inline Base.:(==)(a::CartesianTuple{N,S,U}, b::CartesianTuple{N,T,V}) where
                {S<:Number, T<:Number, U<:ComponentType, V<:ComponentType, N} = false

@inline Base.abs(a::CartesianTuple{N,T,U}) where {N, T<:Number, U<:ComponentType} = typeof(a)(abs.(a))

@inline Base.:-(a::CartesianTuple{N,T,U}) where {N, T<:Number, U<:ComponentType} = typeof(a)((-).(a))

@inline Base.convert(::Type{CartesianTuple{N,S,U}}, a::CartesianTuple{N,T,U}) where {S<:Number, T<:Number, U<:ComponentType, N} =
                promote_type(typeof(a), S)(a)

# Special behaviors for Point-Vector operations.

@inline Base.:+(a::Point{N,S}, b::CVector{N,T}) where {N, S<:Number, T<:Number} =
        promote_type(typeof(a), typeof(b))(a .+ b)

@inline Base.:-(a::Point{N,S}, b::CVector{N,T}) where {N, S<:Number, T<:Number} =
        promote_type(typeof(a), typeof(b))(a .- b)
