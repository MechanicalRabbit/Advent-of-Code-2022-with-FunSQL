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

const funsql_as_integer = FunSQL.Fun."(?::integer)"
const funsql_as_bigint = FunSQL.Fun."(?::bigint)"
const funsql_array_get = FunSQL.Fun."?[?]"
const funsql_mod = FunSQL.Fun.mod
const funsql_regexp_matches = FunSQL.Fun.regexp_matches
const funsql_string_to_table = FunSQL.Fun.string_to_table

@funsql begin

parse_monkeys() =
    begin
        from(
            regexp_matches(
                :input,
                """
                Monkey ([0-9]+):
                  Starting items: ([0-9, ]+)
                  Operation: new = old ([+*]) (?:([0-9]+)|old)
                  Test: divisible by ([0-9]+)
                    If true: throw to monkey ([0-9]+)
                    If false: throw to monkey ([0-9]+)
                """,
                "g"),
            columns = [captures])
        define(
            index => as_integer(array_get(captures, 1)),
            levels => array_get(captures, 2),
            op => array_get(captures, 3),
            arg => as_integer(array_get(captures, 4)),
            test => as_bigint(array_get(captures, 5)),
            on_true => as_integer(array_get(captures, 6)),
            on_false => as_integer(array_get(captures, 7)))
    end

parse_items() =
    begin
        from(monkeys)
        cross_join(from(string_to_table(levels, ", "), columns = [level]))
        define(level => as_bigint(level))
    end

operation(level, op, arg) =
    $op == "+" ? $level + $arg : $level * coalesce($arg, $level)

process_one_item(; relief = level / 3, max_round = 20) =
    begin
        join(monkey => from(monkeys), on = index == monkey.index)
        define(level => operation(level, monkey.op, monkey.arg))
        define(level => $relief)
        define(
            next_index =>
                mod(level, monkey.test) == 0 ? monkey.on_true : monkey.on_false)
        define(
            round => round + (next_index < index ? 1 : 0),
            index => next_index)
        filter(round <= $max_round)
    end

answer(name) =
    begin
        group(index)
        define(total => count())
        partition(order_by = [total])
        define(score => total * lag(total))
        group()
        define($name => max(score))
    end

solve_part1() =
    begin
        from(items)
        define(round => 1)
        iterate(process_one_item())
        answer(part1)
    end

calculate_product() =
    begin
        define(
            index => 0,
            product => as_bigint(1))
        iterate(
            begin
                join(monkey => from(monkeys), on = index == monkey.index)
                define(
                    index => index + 1,
                    product => product * monkey.test)
            end)
        group()
        define(product => max(product))
    end

solve_part2() =
    begin
        from(items)
        define(round => 1)
        iterate(
            begin
                cross_join(from(product))
                process_one_item(relief = mod(level, product), max_round = 10000)
            end)
        answer(part2)
        with(product => calculate_product())
    end

solve_all() =
    begin
        solve_part1().cross_join(solve_part2())
        with(items => parse_items())
        with(monkeys => parse_monkeys())
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
