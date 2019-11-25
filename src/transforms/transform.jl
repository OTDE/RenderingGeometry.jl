export Transform

struct Transform{T<:AbstractFloat}
    m::SMatrix{4,4,T}
    m_inv::SMatrix{4,4,T}

    function Transform{T}(args::NTuple{16, T}) where T<:AbstractFloat
        m = SMatrix{4, 4}(args)
        new{T}(m, inv(m))
    end

    Transform{T}(m) where T<:AbstractFloat = new{T}(m, inv(m))

    Transform{T}() where T<:AbstractFloat =
        new{T}(one(SMatrix{4,4}), one(SMatrix{4,4}))

    Transform{T}(m, m_inv) where T<:AbstractFloat = new{T}(m, m_inv)
end

Transform(m::SMatrix{4,4,T}) where T<:AbstractFloat = Transform{T}(m)

Transform(m::SMatrix{4,4,T}, m_inv::SMatrix{4,4,U}) where {T<:AbstractFloat, U<:AbstractFloat} =
    Transform{promote_type(T,U)}(m, m_inv) 
