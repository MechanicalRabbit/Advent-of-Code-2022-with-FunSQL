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

const funsql_ascii = FunSQL.Fun.ascii
const funsql_least = FunSQL.Fun.least
const funsql_string_to_table = FunSQL.Fun.string_to_table
const funsql_with_ordinality = FunSQL.Fun."? WITH ORDINALITY"

@funsql begin

parse_heights() =
    begin
        from(
            with_ordinality(string_to_table(:input, "\n")),
            columns = [line, row])
        cross_join(
            from(
                with_ordinality(string_to_table(line, missing)),
                columns = [char, col]))
        define(
            height =>
                ascii(char == "S" ? "a" : char == "E" ? "z" : char) - ascii("a"),
            start => char == "S",
            finish => char == "E")
    end

dist_lag() =
    case(height <= lag(height) + 1, lag(dist) + 1)

dist_lead() =
    case(height <= lead(height) + 1, lead(dist) + 1)

step() =
    begin
        partition()
        filter(is_null(min(dist, filter = finish)))
        partition(row, order_by = [col])
        define(
            left => dist_lag(),
            right => dist_lead())
        partition(col, order_by = [row])
        define(
            up => dist_lag(),
            down => dist_lead())
        define(dist => least(dist, left, right, up, down))
    end

solve(name, init) =
    begin
        from(heights)
        define(dist => case($init, 0))
        iterate(step())
        group()
        define($name => max(dist))
    end

solve_part1() =
    solve(part1, start)

solve_part2() =
    solve(part2, height == 0)

solve_all() =
    begin
        solve_part1().cross_join(solve_part2())
        with(heights => parse_heights())
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
