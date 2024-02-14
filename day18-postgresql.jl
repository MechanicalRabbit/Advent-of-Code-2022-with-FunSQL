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
const funsql_as_integer = FunSQL.Fun."(?::integer)"
const funsql_bool_and = FunSQL.Agg.bool_and
const funsql_bool_or = FunSQL.Agg.bool_or
const funsql_regexp_matches = FunSQL.Fun.regexp_matches

@funsql begin

parse_cubes() =
    begin
        from(
            regexp_matches(:input, "(\\d+),(\\d+),(\\d+)", "g"),
            columns = [captures])
        define(
            x => as_integer(array_get(captures, 1)),
            y => as_integer(array_get(captures, 2)),
            z => as_integer(array_get(captures, 3)))
    end

solve_part1() =
    begin
        from(cubes)
        group()
        cross_join(
            pairs =>
                begin
                    from(cubes).define(x1 => x, y1 => y, z1 => z)
                    join(
                        from(cubes).define(x2 => x, y2 => y, z2 => z),
                        on =
                            x1 + 1 == x2 && y1 == y2 && z1 == z2 ||
                            x1 == x2 && y1 + 1 == y2 && z1 == z2 ||
                            x1 == x2 && y1 == y2 && z1 + 1 == z2)
                    group()
                end)
        define(part1 => 6 * count() - 2 * pairs.count())
    end

not_a_cube(X, Y, Z) =
    not_exists(
        begin
            from(cubes)
            filter(x == :X && y == :Y && z == :Z)
            bind(:X => $X, :Y => $Y, :Z => $Z)
        end)

calculate_bounds() =
    begin
        from(cubes)
        group()
        define(
            min_x => min(x) - 1,
            max_x => max(x) + 1,
            min_y => min(y) - 1,
            max_y => max(y) + 1,
            min_z => min(z) - 1,
            max_z => max(z) + 1)
    end

flood_step() =
    begin
        partition()
        filter(bool_or(fresh))
        cross_join(
            from(
                (dx = [0, 1, -1, 0, 0, 0, 0],
                 dy = [0, 0, 0, 1, -1, 0, 0],
                 dz = [0, 0, 0, 0, 0, 1, -1])))
        define(
            x => x + dx,
            y => y + dy,
            z => z + dz,
            fresh => dx != 0 || dy != 0 || dz != 0)
        group(x, y, z)
        define(fresh => bool_and(fresh))
        cross_join(from(bounds))
        filter(
            between(x, min_x, max_x) &&
            between(y, min_y, max_y) &&
            between(z, min_z, max_z) &&
            not_a_cube(x, y, z))
    end

solve_part2() =
    begin
        from(bounds)
        define(
            x => min_x,
            y => min_y,
            z => min_z,
            fresh => true)
        iterate(flood_step())
        group(
            fill_x => x,
            fill_y => y,
            fill_z => z)
        cross_join(
            from(
                (dx = [1, -1, 0, 0, 0, 0],
                 dy = [0, 0, 1, -1, 0, 0],
                 dz = [0, 0, 0, 0, 1, -1])))
        define(
            fill_x => fill_x + dx,
            fill_y => fill_y + dy,
            fill_z => fill_z + dz)
        join(from(cubes), on = x == fill_x && y == fill_y && z == fill_z)
        group()
        define(part2 => count())
    end

solve_all() =
    begin
        solve_part1().cross_join(solve_part2())
        with(bounds => calculate_bounds())
        with(cubes => parse_cubes())
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
