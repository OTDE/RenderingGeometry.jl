using Test
using RenderingGeometry

function test_precision_conversion(type₁, type₂)
    @eval begin
        dataset = generate_set($type₁)
        converted_dataset = [convert($type₂, pair) for pair ∈ dataset]
        reconverted_dataset = [convert($type₁, pair) for pair ∈ converted_dataset]
        for (pair₁, pair₂, pair₃) ∈ zip(dataset, converted_dataset, reconverted_dataset)
            @test typeof(pair₁) == typeof(pair₃) == $type₁
            @test typeof(pair₂) == $type₂
        end
    end
end

function test_type_casting(type₁, type₂)
    @eval begin
        dataset = generate_set($type₁)
        converted_dataset = [convert($type₂, pair) for pair ∈ dataset]
        for (pair₁, pair₂) ∈ zip(dataset, converted_dataset)
            @test typeof(pair₂) <: $type₂
            for (index₁, index₂) ∈ zip(pair₁, pair₂)
                @test typeof(index₁) == typeof(index₂)
                @test isapprox(index₁, index₂; atol=1)
            end
        end
    end
end

function test_all_pair_conversions()
    @testset "Pair conversion tests" begin
        log_test_batch_begin("Pair conversion")
        @testset "Vector conversion tests: $name₁ → $name₂" for (type₁, name₁) ∈ pair_vector_iterable, (type₂, name₂) ∈ pair_vector_iterable
            test_precision_conversion(type₁, type₂)
            increment_progress()
        end

        @testset "Point conversion tests: $name₁ → $name₂" for (type₁, name₁) ∈ pair_point_iterable, (type₂, name₂) ∈ pair_point_iterable
            test_precision_conversion(type₁, type₂)
            increment_progress()
        end

        @testset "Special cases: $name₁ → $name₂" for ((type₁, name₁), (type₂, name₂)) ∈ zip(pair_vector_iterable, pair_point_iterable)
            test_type_casting(type₁, type₂)
            increment_progress()
        end

        @testset "Special cases: $name₁ → $name₂" for ((type₁, name₁), (type₂, name₂)) ∈ zip(pair_point_iterable, pair_vector_iterable)
            test_type_casting(type₁, type₂)
            increment_progress()
        end
        log_test_batch_end()
    end
end
