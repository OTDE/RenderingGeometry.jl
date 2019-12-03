export distance², distance, lerp, permute

# Point functions.

@inline distance²(p::Point, q::Point) = magnitude²(p - q)

@inline distance(p::Point, q::Point) = magnitude(p - q)

@inline Base.floor(p::Point) = typeof(p)(floor.(p.coordinates)...)

@inline Base.ceil(p::Point) = typeof(p)(ceil.(p.coordinates)...)

@inline Base.min(a::Point, b::Point) = promote_type(typeof(a), typeof(b))(min.(a.coordinates, b.coordinates)...)

@inline Base.max(a::Point, b::Point) = promote_type(typeof(a), typeof(b))(max.(a.coordinates, b.coordinates)...)

@inline lerp(t::T, p₀::Point, p₁::Point) where T<:Number = (one(T) - t) * p₀ + t * p₁

@inline permute(a::Point3{T}, (x, y, z)) where T = typeof(a)(a[x], a[y], a[z])

@inline Base.:(-)(a::Point{N,T}, b::Point{N,U}) where {N,T,U} = Vect{N, promote_type(T,U)}(a.coordinates - b.coordinates)
