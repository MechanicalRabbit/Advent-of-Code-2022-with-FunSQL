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

array_get(a, i) =
    `?[?]`($a, $i)

as_integer(str) =
    `(?::integer)`($str)

as_bigint(str) =
    `(?::bigint)`($str)

parse_positions() =
    begin
        from(
            regexp_matches(
                :input,
                "Sensor at x=(\\S+), y=(\\S+): closest beacon is at x=(\\S+), y=(\\S+)",
                "g"),
            columns = [captures])
        define(
            sx => as_integer(array_get(captures, 1)),
            sy => as_integer(array_get(captures, 2)),
            bx => as_integer(array_get(captures, 3)),
            by => as_integer(array_get(captures, 4)))
        define(range => abs(sx - bx) + abs(sy - by))
    end

merge_intervals() =
    begin
        partition(order_by = [l], frame = (mode = rows, finish = -1))
        define(bound => l <= max[r] + 1 ? 0 : 1)
        partition(order_by = [l, -bound], frame = rows)
        define(interval => sum[bound])
        group(interval)
        define(
            l => min[l],
            r => max[r])
    end

solve_part1() =
    begin
        from(positions)
        define(dist => abs(:y - sy))
        filter(dist <= range)
        define(
            l => sx - range + dist,
            r => sx + range - dist)
        merge_intervals()
        group()
        cross_join(beacons => from(positions).filter(by == :y).group())
        define(
            part1 => sum[r - l + 1] - beacons.count_distinct[bx])
    end

in_range(x, y) =
    abs(sx - $x) + abs(sy - $y) <= range

is_covered(X, Y, W, H) =
    begin
        from(positions)
        filter(
            in_range(:X, :Y) &&
            in_range(:X + :W - 1, :Y) &&
            in_range(:X, :Y + :H - 1) &&
            in_range(:X + :W - 1, :Y + :H - 1))
        bind(:X => $X, :Y => $Y, :W => $W, :H => $H)
    end

subdivide() =
    begin
        filter(w > 1 || h > 1)
        cross_join(from((; part = [0, 1])))
        define(
            x => x + (part == 1 && w > h ? w / 2 : 0),
            y => y + (part == 1 && w <= h ? h / 2 : 0),
            w => w <= h ? w : part == 0 ? w / 2 : w - w / 2,
            h => w > h ? h : part == 0 ? h / 2 : h - h / 2)
        filter(not_exists(is_covered(x, y, w, h)))
    end

solve_part2() =
    begin
        define(
            x => 0,
            y => 0,
            w => :size + 1,
            h => :size + 1)
        iterate(subdivide())
        filter(w == 1 && h == 1)
        select(part2 => x * as_bigint(4000000) + y)
    end

solve_all() =
    let positions = parse_positions()
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
        sample = endswith(file, ".sample-input")
        y = sample ? 10 : 2000000
        size = sample ? 20 : 4000000
        output = first(DBInterface.execute(db, q; input, y, size))
        println("[$file] part1: $(output.part1), part2: $(output.part2)")
    end
end
