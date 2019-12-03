export CartesianTuple

struct CartesianTuple{N, T<:Number, U<:ComponentType}
    coordinates::SVector{N,T}

    function CartesianTuple{N,T,U}(args::SVector{N,T}) where {N,T,U}
        @assert !any(isnan.(args))
        new{N,T,U}(args)
    end

    function CartesianTuple{N,T,U}(args::Vararg{T,N}) where {N,T,U}
        @assert !any(isnan.(args))
        new{N,T,U}(SVector(args))
    end

    function CartesianTuple{N,T,U}(arg::T) where {N,T,U}
        @assert !isnan(arg)
        new{N,T,U}(@SVector fill(arg, N))
    end

    CartesianTuple{N,T,U}() where {N,T,U} = new{N,T,U}(zeros(SVector{N,T}))
end

CartesianTuple{N,T,U}(args::Vararg{Any,N}) where {N,T,U} = CartesianTuple{N,T,U}(convert.(T, args)...)
CartesianTuple{N,T,U}(arg) where {N,T,U} = CartesianTuple{N,T,U}(convert(T, arg))
CartesianTuple{N,T,U}(args::AbstractArray{T,N}) where {N,T,U} = CartesianTuple{N,T,U}(args...)
