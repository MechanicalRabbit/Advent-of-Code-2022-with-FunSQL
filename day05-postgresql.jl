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

@funsql begin

with_ordinality(q) =
    `? WITH ORDINALITY`(q)

as_integer(str) =
    `(?::integer)`(str)

array_get(a, i) =
    `?[?]`(a, i)

string_agg(s, i) =
    `string_agg(?, NULL ORDER BY ?)`[s, i]

parse_stacks() =
    begin
        from(
            with_ordinality(string_to_table(split_part(:input, "\n 1", 1), "\n")),
            columns = [line, row])
        cross_join(
            from(
                with_ordinality(regexp_matches(line, ".(.). ?", "g")),
                columns = [captures, col]))
        define(
            col => as_integer(col),
            char => nullif(array_get(captures, 1), " "))
        group(col)
        define(stack => string_agg(char, row))
    end

parse_moves() =
    begin
        from(
            with_ordinality(regexp_matches(:input, "move (\\d+) from (\\d+) to (\\d+)", "g")),
            columns = [captures, index])
        define(
            count => as_integer(array_get(captures, 1)),
            from => as_integer(array_get(captures, 2)),
            to => as_integer(array_get(captures, 3)))
    end

maybe_reverse(str; reverse) =
    $(reverse ? FunSQL.Fun(:reverse, str) : str)

apply_move(; reverse) =
    begin
        join(move => from(moves), on = index == move.index)
        partition(order_by = [col])
        define(
            index => index + 1,
            stack =>
                if col == move.from
                    substr(stack, move.count + 1)
                elseif col == move.to
                    concat(
                        maybe_reverse(substr(lead[stack, move.from - col], 1, move.count),
                                      reverse = reverse),
                        stack)
                else
                    stack
                end)
    end

solve(name; reverse) =
    begin
        from(stacks)
        define(index => 1)
        iterate(apply_move(reverse = reverse))
        partition()
        filter(index == max[index])
        group()
        define(name => string_agg(substr(stack, 1, 1), col))
    end

solve_part1() =
    solve(part1, reverse = true)

solve_part2() =
    solve(part2, reverse = false)

solve_all() =
    let stacks = parse_stacks(),
        moves = parse_moves()
        solve_part1().cross_join(solve_part2())
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
