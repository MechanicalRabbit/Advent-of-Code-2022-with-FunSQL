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

as_bigint(n) =
    `?::bigint`(n)

parse_requirements() =
    from(
        string_to_table(:input, "\n"),
        columns = [snafu])

from_snafu_step() =
    begin
        filter(snafu != "")
        define(
            ch => substr(snafu, 1, 1),
            snafu => substr(snafu, 2))
        define(
            digit =>
                ch == "2" ? 2 :
                ch == "1" ? 1 :
                ch == "0" ? 0 :
                ch == "-" ? -1 :
                ch == "=" ? -2 : missing)
        define(
            value => value * 5 + digit)
    end

to_snafu_step() =
    begin
        filter(value != 0)
        define(
            digit => (value + 2) % 5 - 2)
        define(
            ch =>
                digit == 2 ? "2" :
                digit == 1 ? "1" :
                digit == 0 ? "0" :
                digit == -1 ? "-" :
                digit == -2 ? "=" : missing)
        define(
            snafu => concat(ch, snafu),
            value => (value - digit) / 5)
    end

solve_part1() =
    begin
        parse_requirements()
        define(value => as_bigint(0))
        iterate(from_snafu_step())
        filter(snafu == "")
        group()
        define(
            value => sum[value],
            snafu => "")
        iterate(to_snafu_step())
        filter(value == 0)
        select(part1 => snafu)
    end

solve_part2() =
    select(part2 => missing)

solve_all() =
    solve_part1().cross_join(solve_part2())

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
