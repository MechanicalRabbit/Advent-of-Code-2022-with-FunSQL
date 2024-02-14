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

const funsql_array_get = FunSQL.Fun."?[?]"
const funsql_chr = FunSQL.Fun.chr
const funsql_collate_c = FunSQL.Fun." COLLATE \"C\""
const funsql_mod = FunSQL.Fun.mod
const funsql_regexp_match = FunSQL.Fun.regexp_match
const funsql_regexp_matches = FunSQL.Fun.regexp_matches
const funsql_with_ordinality = FunSQL.Fun."? WITH ORDINALITY"

@funsql begin

parse_packets() =
    begin
        from(
            with_ordinality(regexp_matches(:input, "\\S+", "g")),
            columns = [captures, index])
        define(packet => array_get(captures, 1))
    end

recode_step() =
    begin
        filter(rest != "")
        define(captures => regexp_match(rest, "(\\[\\]|10|.)(.*)"))
        define(
            token => array_get(captures, 1),
            rest => array_get(captures, 2))
        define(
            packet =>
                concat(
                    packet,
                    if token == "[]"
                        concat("/", chr(32 + depth))
                    elseif token == "10"
                        ":"
                    elseif token == "[" || token == "]"
                        ""
                    elseif token == ","
                        chr(58 + depth)
                    else
                        token
                    end),
            depth => depth + (token == "[" ? 1 : token == "]" ? -1 : 0))
    end

recode_packets() =
    begin
        parse_packets()
        define(
            rest => packet,
            packet => "",
            depth => 0)
        iterate(recode_step())
        filter(rest == "")
    end

solve_part1() =
    begin
        from(packets)
        partition(order_by = [index])
        define(ordered => lag(packet) < collate_c(packet))
        filter(mod(index, 2) == 0)
        group()
        define(part1 => sum(index / 2, filter = ordered))
    end

solve_part2() =
    begin
        from(packets)
        group()
        define(
            part2 =>
                (1 + count(filter = collate_c(packet) < "2")) *
                (2 + count(filter = collate_c(packet) < "6")))
    end

solve_all() =
    begin
        solve_part1().cross_join(solve_part2())
        with(packets => recode_packets())
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
