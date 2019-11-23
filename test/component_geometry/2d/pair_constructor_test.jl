using Test
include("definitions.jl")
include("../../test_logging.jl")

pair_legal_monads = [[a] for a ∈ (0, 1, -1, 0.0, 4, -4, 500000000, -500000000, 847658787.834, -847658787.834, 2.568368, -2.568368)]
pair_illegal_monads = [[a] for a ∈ (NaN16, NaN32, NaN64)]


pair_legal_dyads = [vcat(x, y) for x = pair_legal_monads, y = pair_legal_monads]
pair_illegal_dyads = [vcat(x, y) for x = pair_illegal_monads, y = pair_legal_monads]

is_noninteger(a) = isa(a, AbstractFloat) && a != round(a, digits=0)

function any_are_noninteger(args)
    for arg in args
        if is_noninteger(arg)
            return true
        end
    end
    return false
end

function any_isnan(args)
    for arg in args
        if typeof(arg)<:AbstractFloat && isnan(arg)
            return true
        end
    end
    return false
end

function test_one_pair_constructor(type::Type, args=[0.0])
    secondindex = length(args) < 2 ? 1 : 2
    @eval begin
        testpair = $type($args...)
        @test testpair.x ≈ $args[1] ≈ testpair[1]
        @test testpair.y ≈ $args[$secondindex] ≈ testpair[$secondindex]
        if $args[1] ≈ $args[$secondindex]
            @test testpair[1] ≈ testpair[$secondindex]
        end
    end
end

function test_pair_constructor_cases_with(type, legal_args, illegal_args)
    @testset "with legal input: $arg" for arg ∈ legal_args
        if type <: IntegerPair && any_are_noninteger(arg)
            @eval begin
                @test_throws InexactError $type($(arg)...)
            end
        else
            test_one_pair_constructor(type, arg)
        end
    end


    @testset "with illegal input: $arg" for arg ∈ illegal_args
        if any_isnan(arg)
            @eval begin
                @test_throws AssertionError $type($(arg)...)
            end
        else
            @eval begin
                @test_throws MethodError $type($(arg)...)
            end
        end
    end

    @testset "with irrational input" begin
        if type <: IntegerPair
            @eval begin
                @test_throws MethodError $type(π)
            end
        else
            test_one_pair_constructor(type, π)
        end
    end
end


function test_all_pair_constructors()
    @testset "Pair constructor tests" begin
        log_test_batch_begin("Pair constructor")
        @testset "Constructor test set with type: $name" for (type, name) ∈ pair_type_iterable
            @testset "Niladic constructor for $name" begin
                test_one_pair_constructor(type)
                increment_progress()
            end #nilad

            @testset "Monadic constructors for $name" begin
                test_pair_constructor_cases_with(type, pair_legal_monads, pair_illegal_monads)
                increment_progress()
            end #monad

            @testset "Dyadic constructors for $name" begin
                test_pair_constructor_cases_with(type, pair_legal_dyads, pair_illegal_dyads)
                increment_progress()
            end
        end
        log_test_batch_end()
    end
end
