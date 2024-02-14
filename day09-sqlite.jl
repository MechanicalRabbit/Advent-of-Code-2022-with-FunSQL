using FunSQL
using SQLite

const funsql_abs = FunSQL.Fun.abs
const funsql_as_integer = FunSQL.Fun."CAST(? AS INTEGER)"
const funsql_instr = FunSQL.Fun.instr
const funsql_sign = FunSQL.Fun.sign
const funsql_substr = FunSQL.Fun.substr

@funsql begin

split_first(text, sep = "\n") =
    instr($text, $sep) > 0 ? substr($text, 1, instr($text, $sep) - 1) : $text

split_rest(text, sep = "\n") =
    instr($text, $sep) > 0 ? substr($text, instr($text, $sep) + $(length(sep))) : ""

dx(dir) =
    $dir == "L" ? -1 : $dir == "R" ? 1 : 0

dy(dir) =
    $dir == "U" ? -1 : $dir == "D" ? 1 : 0

split_motions_one_step() =
    begin
        filter(rest != "")
        define(
            motion => motion + 1,
            dx => dx(substr(split_first(rest), 1, 1)),
            dy => dy(substr(split_first(rest), 1, 1)),
            length => as_integer(substr(split_first(rest), 3)),
            rest => split_rest(rest))
    end

split_motions(text) =
    begin
        define(
            motion => 0,
            rest => $text)
        split_motions_one_step()
        iterate(split_motions_one_step())
    end

expand_motions_one_step() =
    begin
        filter(step < length)
        define(step => step + 1)
    end

expand_motions() =
    begin
        define(step => 0)
        expand_motions_one_step()
        iterate(expand_motions_one_step())
    end

track_head() =
    begin
        split_motions(:input)
        expand_motions()
        partition(order_by = [motion, step])
        define(
            index => count(),
            x => sum(dx),
            y => sum(dy))
    end

moved() =
    abs(head.x - x) > 1 || abs(head.y - y) > 1

track_tail_one_step() =
    begin
        join(head => from(heads), on = index + 1 == head.index)
        define(
            index => index + 1,
            x => x + (moved() ? sign(head.x - x) : 0),
            y => y + (moved() ? sign(head.y - y) : 0))
    end

track_tail() =
    begin
        define(
            index => 0,
            x => 0,
            y => 0)
        track_tail_one_step()
        iterate(track_tail_one_step())
    end

solve_part1() =
    begin
        track_tail()
        group(x, y)
        group()
        define(part1 => count())
    end

track_tail(n) =
    $(n > 0 ? @funsql(track_tail().with(heads => track_tail($(n - 1)))) : @funsql(track_tail()))

solve_part2() =
    begin
        track_tail(8)
        group(x, y)
        group()
        define(part2 => count())
    end

solve_all() =
    begin
        solve_part1().cross_join(solve_part2())
        with(heads => track_head())
    end

const q = solve_all()

end # @funsql

if isempty(ARGS)
    println(FunSQL.render(q, dialect = :sqlite))
else
    const db = DBInterface.connect(FunSQL.DB{SQLite.DB})
    for file in ARGS
        input = read(file, String)
        output = first(DBInterface.execute(db, q, input = input))
        println("[$file] part1: $(output.part1), part2: $(output.part2)")
    end
end
