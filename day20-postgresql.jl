using FunSQL
using LibPQ
using DBInterface

# Make LibPQ compatible with DBInterface.
DBInterface.connect(::Type{LibPQ.Connection}, args...; kws...) =
    LibPQ.Connection(args...; kws...)

DBInterface.prepare(conn::LibPQ.Connection, args...; kws...) =
    LibPQ.prepare(conn, args...; kws...)

DBInterface.execute(conn::Union{LibPQ.Connection, LibPQ.Statement}, args...; kws...) =
    LibPQ.execute(conn, args...; kws...)

const var"funsql_%" = FunSQL.Fun."%"
const funsql_array_get = FunSQL.Fun."?[?]"
const funsql_as_bigint = FunSQL.Fun."(?::bigint)"
const funsql_regexp_matches = FunSQL.Fun.regexp_matches
const funsql_with_ordinality = FunSQL.Fun."? WITH ORDINALITY"

@funsql begin

parse_numbers() =
    begin
        from(
            with_ordinality(regexp_matches(:input, "[-0-9]+", "g")),
            columns = [captures, index])
        define(
            original_index => index,
            value => as_bigint(array_get(captures, 1)))
    end

calculate_length() =
    begin
        from(numbers)
        group()
        define(length => count())
    end

mod1(x, n) =
    (($x - 1) % $n + $n) % $n + 1

mix_step() =
    begin
        filter(mix_index <= length)
        partition()
        define(
            move_from => min(index, filter = original_index == mix_index),
            move_delta => min(value, filter = original_index == mix_index))
        define(
            move_to => mod1(move_from + move_delta, length - 1))
        define(
            index =>
                if index == move_from
                    move_to
                elseif between(index, move_from + 1, move_to)
                    index - 1
                elseif between(index, move_to, move_from - 1)
                    index + 1
                else
                    index
                end)
        define(mix_index => mix_index + 1)
    end

mix() =
    begin
        define(mix_index => 1)
        iterate(mix_step())
        filter(mix_index == length + 1)
    end

answer(name) =
    begin
        partition()
        define(index0 => min(index, filter = value == 0))
        define(
            index1000 => mod1(index0 + 1000, length),
            index2000 => mod1(index0 + 2000, length),
            index3000 => mod1(index0 + 3000, length))
        group()
        define(
            $name =>
                sum(value, filter = in(index, index1000, index2000, index3000)))
    end

solve_part1() =
    begin
        from(numbers)
        cross_join(from(length))
        mix()
        answer(part1)
    end

repeat(q, n) =
    $(n > 1 ? q |> @funsql(repeat($q, $(n - 1))) : q)

solve_part2() =
    begin
        from(numbers)
        define(value => value * 811589153)
        cross_join(from(length))
        repeat(mix(), 10)
        answer(part2)
    end

solve_all() =
    begin
        solve_part1().cross_join(solve_part2())
        with(length => calculate_length())
        with(numbers => parse_numbers())
    end

const q = solve_all()

end # @funsql

if isempty(ARGS)
    println(FunSQL.render(q, dialect = :postgresql))
else
    const db = DBInterface.connect(FunSQL.DB{LibPQ.Connection}, "")
    for file in ARGS
        input = read(file, String)
        output = first(DBInterface.execute(db, q, input = input))
        println("[$file] part1: $(output.part1), part2: $(output.part2)")
    end
end
