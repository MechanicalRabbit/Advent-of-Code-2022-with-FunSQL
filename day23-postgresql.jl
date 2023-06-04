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

with_ordinality(q) =
    `? WITH ORDINALITY`($q)

parse_elves() =
    begin
        from(
            with_ordinality(string_to_table(:input, "\n")),
            columns = [line, y])
        cross_join(
            from(
                with_ordinality(string_to_table(line, missing)),
                columns = [char, x]))
        filter(char == "#")
    end

round() =
    begin
        partition(x, order_by = [y])
        define(
            free_n => coalesce(lag[y], y) != y - 1,
            free_s => coalesce(lead[y], y) != y + 1)
        partition(y, order_by = [x])
        define(
            free_w => coalesce(lag[x], x) != x - 1,
            free_e => coalesce(lead[x], x) != x + 1)
        partition(x - y, order_by = [x + y])
        define(
            free_nw => coalesce(lag[x + y], x + y) != x + y - 2,
            free_se => coalesce(lead[x + y], x + y) != x + y + 2)
        partition(x + y, order_by = [x - y])
        define(
            free_sw => coalesce(lag[x - y], x - y) != x - y - 2,
            free_ne => coalesce(lead[x - y], x - y) != x - y + 2)
        define(
            alone =>
                free_n && free_ne && free_e && free_se &&
                free_s && free_sw && free_w && free_nw,
            can_move_n => free_n && free_ne && free_nw,
            can_move_s => free_s && free_se && free_sw,
            can_move_w => free_w && free_nw && free_sw,
            can_move_e => free_e && free_ne && free_se)
        define(
            xn => case(can_move_n && !alone, x),
            yn => case(can_move_n && !alone, y - 1),
            xs => case(can_move_s && !alone, x),
            ys => case(can_move_s && !alone, y + 1),
            xw => case(can_move_w && !alone, x - 1),
            yw => case(can_move_w && !alone, y),
            xe => case(can_move_e && !alone, x + 1),
            ye => case(can_move_e && !alone, y))
        define(
            next_x =>
                case(
                    t % 4 == 1,
                    coalesce(xn, xs, xw, xe, x),
                    t % 4 == 2,
                    coalesce(xs, xw, xe, xn, x),
                    t % 4 == 3,
                    coalesce(xw, xe, xn, xs, x),
                    coalesce(xe, xn, xs, xw, x)),
            next_y =>
                case(
                    t % 4 == 1,
                    coalesce(yn, ys, yw, ye, y),
                    t % 4 == 2,
                    coalesce(ys, yw, ye, yn, y),
                    t % 4 == 3,
                    coalesce(yw, ye, yn, ys, y),
                    coalesce(ye, yn, ys, yw, y)))
        partition(next_x, next_y)
        define(blocked => count[] > 1)
        define(
            x => case(!blocked, next_x, x),
            y => case(!blocked, next_y, y),
            t => t + 1)
    end

solve_part1() =
    begin
        from(elves)
        define(t => 1)
        iterate(
            begin
                filter(t <= 10)
                round()
            end)
        filter(t == 11)
        group()
        define(part1 => (max[x] - min[x] + 1) * (max[y] - min[y] + 1) - count[])
    end

solve_part2() =
    begin
        from(elves)
        define(t => 1)
        iterate(
            begin
                round()
                partition()
                filter(bool_or[!alone])
            end)
        group()
        define(part2 => max[t])
    end

solve_all() =
    let elves = parse_elves()
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
