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
    `? WITH ORDINALITY`($q)

array_get(a, i) =
    `?[?]`($a, $i)

as_integer(str) =
    `(?::integer)`($str)

parse_valves() =
    begin
        from(
            with_ordinality(
                regexp_matches(:input, "Valve (\\w+) has flow rate=(\\d+)", "g")),
            columns = [captures, index])
        define(
            valve => array_get(captures, 1),
            rate => as_integer(array_get(captures, 2)))
        partition(order_by = [index])
        define(
            mask => case(rate > 0, 1 << as_integer(count[filter = rate > 0])))
    end

parse_tunnels() =
    begin
        from(
            regexp_matches(:input, "Valve (\\w+) .* to valves? (.+)", "gn"),
            columns = [captures])
        define(
            tunnel_src => array_get(captures, 1))
        cross_join(
            from(
                string_to_table(array_get(captures, 2), ", "),
                columns = [tunnel_dst]))
    end

calculate_distances_step() =
    begin
        define(index => index + 1)
        join(curr => from(valves), index == curr.index)
        partition(src)
        define(src_to_curr => min[dist, filter = dst == curr.valve])
        partition(dst)
        define(curr_to_dst => min[dist, filter = src == curr.valve])
        define(dist => least(dist, src_to_curr + curr_to_dst))
    end

calculate_distances() =
    begin
        from(valves).define(src => valve)
        cross_join(from(valves).define(dst => valve))
        left_join(from(tunnels), src == tunnel_src && dst == tunnel_dst)
        define(
            dist => case(src == dst, 0, is_not_null(tunnel_src), 1),
            index => 0)
        iterate(calculate_distances_step())
        group(src, dst)
        define(dist => min[dist])
    end

solve_step(T) =
    begin
        join(
            from(distances).join(from(valves).filter(rate > 0), dst == valve),
            curr == src)
        filter(opened & mask == 0)
        define(
            curr => dst,
            opened => opened | mask,
            t => t + dist + 1)
        filter(t <= $T)
        define(total => total + rate * ($T - t + 1))
        group(t, curr, opened)
        define(total => max[total])
    end

solve_part1() =
    begin
        define(
            t => 1,
            curr => "AA",
            opened => 0,
            total => 0)
        iterate(solve_step(30))
        group()
        define(part1 => max[total])
    end

solve_part2() =
    let totals =
            begin
                define(
                    t => 1,
                    curr => "AA",
                    opened => 0,
                    total => 0)
                iterate(solve_step(26))
                group(opened)
                define(total => max[total])
            end
        from(totals)
        join(other => from(totals), opened & other.opened == 0)
        group()
        define(part2 => max[total + other.total])
    end

solve_all() =
    let valves = parse_valves(),
        tunnels = parse_tunnels(),
        distances = calculate_distances()
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
