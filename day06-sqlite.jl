using FunSQL
using SQLite

const funsql_rtrim = FunSQL.Fun.rtrim
const funsql_substr = FunSQL.Fun.substr

@funsql begin

split_chars_one_step() =
    begin
        filter(rest != "")
        define(
            index => index + 1,
            char => substr(rest, 1, 1),
            rest => substr(rest, 2))
    end

split_chars(text) =
    begin
        define(
            index => 0,
            rest => $text)
        split_chars_one_step()
        iterate(split_chars_one_step())
    end

make_starts() =
    begin
        split_chars(rtrim(:input, "\n"))
        partition(char, order_by = [index], frame = (mode = rows, finish = -1))
        define(rep_index => coalesce(max(index), 0))
        partition(order_by = [index])
        define(length => index - max(rep_index))
        group(length)
        define(start => min(index))
    end

solve(name, l) =
    begin
        from(starts)
        filter(length == $l)
        select($name => start)
    end

solve_part1() =
    solve(part1, 4)

solve_part2() =
    solve(part2, 14)

solve_all() =
    begin
        solve_part1().cross_join(solve_part2())
        with(starts => make_starts())
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
