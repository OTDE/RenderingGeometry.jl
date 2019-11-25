export
Bounds2, Bounds3,
Bounds2i, Bounds2f, Bounds2d,
Bounds3i, Bounds3f, Bounds3d

struct Bounds{N, T<:Number, U<:Point{N, T}} <:FieldVector{2, T}

    p_min::U
    p_max::U

    Bounds{N,T,U}(p_min, p_max) where {N, T<:Number, U<:Point{N, T}} =
        new{N,T,U}(min(p_min, p_max), max(p_min, p_max))

    Bounds{N,T,U}(p) where {N, T<:Number, U<:Point{N, T}} = new{N,T,U}(p, p)

    Bounds{N,T,U}() where {N, T<:Number, U<:Point{N, T}} =
        new{N,T,U}(typeof(U)(typemax(T)), typeof(U)(typemin(T)))

end

Bounds2{T<:Number} = Bounds{2, T, Point2{T}}
Bounds3{T<:Number} = Bounds{3, T, Point3{T}}

Bounds2(p_min::Point2{T}, p_max::Point2{U}) where {T,U<:Number} =
    Bounds2{promote_type(T, U)}(p_min, p_max)

Bounds3(p_min::Point3{T}, p_max::Point3{U}) where {T,U<:Number} =
    Bounds3{promote_type(T, U)}(p_min, p_max)

Base.promote_rule(::Type{Bounds2{T}}, ::Type{Bounds2{U}}) where {T<:Number, U<:Number} =
    Bounds2{promote_type(T,U)}

Base.promote_rule(::Type{Bounds2{T}}, ::Type{Point{2,U}}) where {T<:Number, U<:Number} =
    Bounds2{promote_type(T,U)}

Base.promote_rule(::Type{Bounds3{T}}, ::Type{Bounds3{U}}) where {T<:Number, U<:Number} =
    Bounds3{promote_type(T,U)}

Base.promote_rule(::Type{Bounds3{T}}, ::Type{Point{3,U}}) where {T<:Number, U<:Number} =
    Bounds3{promote_type(T,U)}

Bounds2i = Bounds2{Int}
Bounds2f = Bounds2{Float32}
Bounds2d = Bounds2{Float64}

Bounds3i = Bounds3{Int}
Bounds3f = Bounds3{Float32}
Bounds3d = Bounds3{Float64}
