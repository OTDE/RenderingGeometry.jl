export Transform

struct Transform{T<:Number}
    m::SMatrix{4,4,T}
    m_inv::SMatrix{4,4,T}

    function Transform{T}(args::NTuple{16, T}) where T
        m = SMatrix{4, 4}(args)
        new{T}(m, inv(m))
    end

    Transform{T}(m) where T = new{T}(m, inv(m))

    Transform{T}() where T =
        new{T}(one(SMatrix{4,4}), one(SMatrix{4,4}))

    Transform{T}(m, m_inv) where T = new{T}(m, m_inv)
end

Transform(m::SMatrix{4,4,T}) where T = Transform{T}(m)
Transform(m::SMatrix{4,4,T}, m_inv::SMatrix{4,4,U}) where {T,U} = Transform{promote_type(T,U)}(m, m_inv)
