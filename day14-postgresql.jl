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

parse_segments() =
    begin
        from(
            with_ordinality(string_to_table(:input, "\n")),
            columns = [path, path_index])
        cross_join(
            from(
                with_ordinality(regexp_matches(path, "(\\d+),(\\d+)", "g")),
                columns = [captures, point_index]))
        define(
            x => as_integer(array_get(captures, 1)),
            y => as_integer(array_get(captures, 2)))
        partition(path_index, order_by = [point_index])
        filter(point_index > 1)
        define(
            prev_x => lag[x],
            prev_y => lag[y])
        define(
            x1 => least(x, prev_x),
            x2 => greatest(x, prev_x),
            y1 => least(y, prev_y),
            y2 => greatest(y, prev_y))
    end

on_segment(X, Y) =
    exists(
        begin
            from(segments)
            filter(between(:X, x1, x2) && between(:Y, y1, y2))
            bind(:X => $X, :Y => $Y)
        end)

max_y() =
    begin
        from(segments)
        group()
        define(max_y => max[y2] + 1)
    end

reachable_step() =
    begin
        cross_join(from(max_y))
        filter(y < max_y)
        cross_join(from((; dx = [-1, 0, 1])))
        group(
            x => x + dx,
            y => y + 1)
        filter(!on_segment(x, y))
    end

reachable() =
    begin
        define(
            x => 500,
            y => 0)
        iterate(reachable_step())
    end

is_reachable(X, Y) =
    exists(
        begin
            from(reachable)
            filter(x == :X && y == :Y)
            bind(:X => $X, :Y => $Y)
        end)

fallthrough_step() =
    begin
        cross_join(from((; dx = [-1, 0, 1])))
        group(
            x => x + dx,
            y => y - 1)
        filter(is_reachable(x, y))
    end

fallthrough() =
    begin
        from(reachable)
        cross_join(from(max_y))
        filter(y == max_y)
        iterate(fallthrough_step())
    end

is_fallthrough(X, Y) =
    exists(
        begin
            from(fallthrough)
            filter(x == :X && y == :Y)
            bind(:X => $X, :Y => $Y)
        end)

resting_step() =
    begin
        define(
            down_rest => !is_fallthrough(x, y + 1),
            down_left_rest => !is_fallthrough(x - 1, y + 1))
        cross_join(from((; dx = [-1, 0, 1])))
        define(
            x => x + dx,
            y => y + 1)
        filter(
            dx == 0 ||
            dx == -1 && down_rest ||
            dx == 1 && down_rest && down_left_rest)
        group(x, y)
        filter(is_reachable(x, y))
    end

solve_part1() =
    begin
        define(
            x => 500,
            y => 0)
        iterate(resting_step())
        filter(!is_fallthrough(x, y))
        group()
        define(part1 => count[])
    end

solve_part2() =
    begin
        from(reachable)
        group()
        define(part2 => count[])
    end

solve_all() =
    let segments = parse_segments(),
        max_y = max_y(),
        reachable = reachable(),
        fallthrough = fallthrough()
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
