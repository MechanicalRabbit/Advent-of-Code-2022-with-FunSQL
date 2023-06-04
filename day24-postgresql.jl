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

parse_map() =
    begin
        from(
            with_ordinality(string_to_table(:input, "\n")),
            columns = [line, y])
        cross_join(
            from(
                with_ordinality(string_to_table(line, missing)),
                columns = [char, x]))
    end

calculate_size() =
    begin
        from(map)
        group()
        define(
            max_x => max[x],
            max_y => max[y])
    end

calculate_blizzards() =
    begin
        from(map)
        cross_join(from(size))
        filter(in(char, ">", "v", "<", "^"))
        define(
            dx => case(char == ">", 1, char == "<", -1, 0),
            dy => case(char == "v", 1, char == "^", -1, 0))
    end

mod(x, n) =
    ($x % $n + $n) % $n

mod_walls(x, n) =
    mod($x - 2, $n - 2) + 2

not_in_blizzard(X, Y, T) =
    not_exists(
        begin
            from(blizzards)
            filter(
                mod_walls(x + dx * :T, max_x) == :X &&
                mod_walls(y + dy * :T, max_y) == :Y)
            bind(:X => $X, :Y => $Y, :T => $T)
        end)

at_start() =
    x == 2 && y == 1

at_finish() =
    x == max_x - 1 && y == max_y

in_valley() =
    between(x, 2, max_x - 1) && between(y, 2, max_y - 1)

travel_step(; goal = at_finish()) =
    begin
        partition()
        filter(!bool_or[done])
        cross_join(
            from(
                (dx = [0, 1, -1, 0, 0],
                 dy = [0, 0, 0, 1, -1])))
        define(
            x => x + dx,
            y => y + dy,
            t => t + 1)
        group(x, y, t)
        cross_join(from(size))
        filter(at_start() || at_finish() || in_valley())
        filter(not_in_blizzard(x, y, t))
        define(done => $goal)
    end

solve_part1() =
    begin
        define(
            x => 2,
            y => 1,
            t => 0,
            done => false)
        iterate(travel_step())
        group()
        define(part1 => max[t])
    end

solve_part2() =
    begin
        define(
            x => 2,
            y => 1,
            t => 0,
            done => false)
        iterate(travel_step(goal = at_finish()))
        filter(done)
        define(done => false)
        iterate(travel_step(goal = at_start()))
        filter(done)
        define(done => false)
        iterate(travel_step(goal = at_finish()))
        group()
        define(part2 => max[t])
    end

solve_all() =
    let map = parse_map(),
        size = calculate_size(),
        blizzards = calculate_blizzards()
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
