export
Vector2, Vector2i, Vector2f, Vector2s, Vector2d,
Point2, Point2i, Point2f, Point2s, Point2d,
Vector3, Vector3i, Vector3f, Vector3s, Vector3d,
Point3, Point3i, Point3f, Point3s, Point3d,
Normal3, Normal3i, Normal3f, Normal3s, Normal3d

const CartesianPair{T,U} = CartesianTuple{2,T,U}
const CartesianTriple{T,U} = CartesianTuple{3,T,U}

const VectorLike{N,T,U<:VecLike} = CartesianTuple{N,T,U}
const Vect{N,T} = CartesianTuple{N,T,Vec}
const Point{N,T} = CartesianTuple{N,T,Pnt}
const Normal{N,T} = CartesianTuple{N,T,Nrm}

const Vector2{T} = Vect{2,T}
const Point2{T} = Point{2,T}
const Vector3{T} = Vect{3,T}
const Point3{T} = Point{3,T}
const Normal3{T} = Normal{3,T}

for type ∈ (:Vector2, :Point2, :Vector3, :Point3, :Normal3)
    @eval begin
        const $(Symbol("$(type)i")) = $(type){Int}
        const $(Symbol("$(type)f")){T<:AbstractFloat} = $(type){T}
        const $(Symbol("$(type)s")) = $(type){Float32}
        const $(Symbol("$(type)d")) = $(type){Float64}
    end
end
