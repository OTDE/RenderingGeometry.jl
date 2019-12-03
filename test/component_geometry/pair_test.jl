using Test
using RenderingGeometry

include("definitions.jl")
include("../test_logging.jl")
include("pair_constructor_test.jl")
include("pair_conversion_test.jl")
include("pair_operator_test.jl")

function run_pair_tests()
    @testset "Pair tests" begin
        test_all_pair_constructors()
        test_all_pair_conversions()
        test_all_pair_operators()
    end
end
