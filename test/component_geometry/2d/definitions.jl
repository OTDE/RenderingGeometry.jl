using RenderingGeometry

"""

    2D Component Geometry Definitions

Use for cycling through tests common to certain types.
"""
const pair_types = (Vector2i, Vector2f, Vector2d, Point2i, Point2f, Point2d)
const pair_symbols = (:Vector2i, :Vector2f, :Vector2d, :Point2i, :Point2f, :Point2d)
pair_type_iterable = zip(pair_types, pair_symbols)

const pair_int_types = (pair_types[1], pair_types[3])
const pair_int_symbols = (pair_symbols[1], pair_symbols[3])
pair_int_iterable = zip(pair_int_types, pair_int_symbols)

const pair_float_types = (pair_types[2:3]..., pair_types[5:end]...)
const pair_float_symbols = (pair_symbols[2:3]..., pair_symbols[5:end]...)
pair_float_iterable = zip(pair_float_types, pair_float_symbols)

const pair_vector_types = pair_types[1:3]
const pair_vector_symbols = pair_symbols[1:3]
pair_vector_iterable = zip(pair_vector_types, pair_vector_symbols)

const pair_point_types = pair_types[4:end]
const pair_point_symbols = pair_symbols[4:end]
pair_point_iterable = zip(pair_point_types, pair_point_symbols)

IntegerPair = Union{Vector2i, Point2i}
FloatPair = Union{Vector2f, Point2f}
DoublePair = Union{Vector2d, Point2d}

VectorPair = Union{Vector2i, Vector2f, Vector2d}
PointPair = Union{Point2i, Point2f, Point2d}

function generate_set(type::Type)
    vcat([type(), type(rand(-5000:1:5000, 1)...)], [type(rand(-5000:1:5000, 2)...) for i in 1:2])
end
