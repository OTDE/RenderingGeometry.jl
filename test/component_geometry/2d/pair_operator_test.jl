using Test
using RenderingGeometry

include("definitions.jl")
include("../../test_logging.jl")

componentwise_ops = (:+, :-)
scalar_ops = (:*, :/)
unary_ops = (:-, abs)

function test_unary_operators(type, name)
    @testset "Unary operators for $name" begin
        @testset "with operator: $op" for op ∈ unary_ops
            @eval begin
                dataset = generate_set($type)
                operated_dataset = [$op(pair) for pair ∈ dataset]
                for (pair₁, pair₂) ∈ zip(dataset, operated_dataset)
                    for (index₁, index₂) ∈ zip(pair₁, pair₂)
                        @test $op(index₁) == index₂
                    end
                end
            end
        end
        increment_progress()
    end
end

function test_scalar_ops_with_single_type(type, op)
    if type<:IntegerPair
        test_scalar_ops_with_types(type, Int, op)
    elseif type<:FloatPair
        test_scalar_ops_with_types(type, Float32, op)
    else
        test_scalar_ops_with_types(type, Float64, op)
    end
end

function test_scalar_ops_with_types(type₁, type₂, op)
    @eval begin
        dataset = generate_set($type₁)
        dataset_type₂ = Array{$type₂, 1}([1, 25, 76, 20000])
        pair_dataset = [(pair, scalar) for pair ∈ dataset, scalar ∈ dataset_type₂]
        operated_dataset = [$op(pair, scalar) for (pair, scalar) ∈ pair_dataset]
        if $op == :/
            @test_throws AssertionError $op($type₁(2, 3), type₂(0))
        end
        for ((pair₁, scalar), pair₂) ∈ zip(pair_dataset, operated_dataset)
            for (index₁, index₂) ∈ zip(pair₁, pair₂)
                if $op == :*
                    @test index₂ ≈ $op(scalar, index₁)
                end
                @test $op(index₁, scalar) ≈ index₂
            end
        end
    end
end

function test_scalar_operators(type, name)
    @testset "Scalar operators for $name" begin
        @testset "with operator (same types): $op" for op ∈ scalar_ops
            test_scalar_ops_with_single_type(type, op)

        end

        @testset "with operator(different types): $op" for op ∈ scalar_ops
            for other_type in (Int, Float32, Float64)
                test_scalar_ops_with_types(type, other_type, op)

            end
        end
        increment_progress()
    end
end

test_componentwise_ops_with_single_type(type, op) = test_componentwise_ops_with_types(type, type, op)

function test_componentwise_ops_with_types(type₁, type₂, op)
    @eval begin
        dataset = generate_set($type₁)
        if $type₁<:$type₂
            pair_dataset = [(pair₁, pair₂) for pair₁ ∈ dataset, pair₂ ∈ dataset]
        else
            dataset_type₂ = generate_set($type₂)
            pair_dataset = [(pair₁, pair₂) for pair₁ ∈ dataset, pair₂ ∈ dataset_type₂]
        end
        operated_dataset = [$op(pair₁, pair₂) for (pair₁, pair₂) ∈ pair_dataset]
        for ((pair₁, pair₂), pair₃) ∈ zip(pair_dataset, operated_dataset)
            for (index₁, index₂, index₃) ∈ zip(pair₁, pair₂, pair₃)
                if $type₁<:$type₂
                    @test $op(index₁, index₂) == index₃
                else
                    @test typeof(index₃) == promote_type(typeof(index₁), typeof(index₂))
                    @test isapprox($op(index₁, index₂), index₃; atol=1)
                end
            end
        end
    end
end

function test_componentwise_operators(type, name)
    @testset "Componentwise operators for $name" begin
        @testset "with operator (same types): $op" for op ∈ componentwise_ops
            test_componentwise_ops_with_single_type(type, op)
        end

        @testset "with operator(different types): $op" for op ∈ componentwise_ops
            for other_type ∈ (type<:VectorPair ? pair_vector_types : pair_point_types)
                test_componentwise_ops_with_types(type, other_type, op)
            end
        end

        @testset "with equality operator:" begin
            @eval begin
                zero_pair = $type()
                @test zero_pair == $type(0, 0)
                with_values = $type(0, 4)
                @test with_values == $type(0, 4)
                @test zero_pair != with_values
            end
        end
        increment_progress()
    end
end



function test_all_pair_operators()
    @testset "Pair operator tests" begin
        log_test_batch_begin("Pair operator")
        @testset "Pair operator tests for $name" for (type, name) ∈ pair_type_iterable
            test_unary_operators(type, name)
            test_componentwise_operators(type, name)
            test_scalar_operators(type, name)
        end
        log_test_batch_end()
    end
end
