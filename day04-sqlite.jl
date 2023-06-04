using FunSQL
using SQLite

@funsql begin

split_first(text, sep) =
    instr($text, $sep) > 0 ? substr($text, 1, instr($text, $sep) - 1) : $text

split_rest(text, sep) =
    instr($text, $sep) > 0 ? substr($text, instr($text, $sep) + $(length(sep))) : ""

split_lines_one_step() =
    begin
        filter(rest != "")
        define(
            line => split_first(rest, "\n"),
            rest => split_rest(rest, "\n"))
    end

split_lines(text) =
    begin
        define(rest => $text)
        split_lines_one_step()
        iterate(split_lines_one_step())
    end

as_integer(text) =
    `CAST(? AS INTEGER)`($text)

parse_assignments() =
    begin
        split_lines(:input)
        define(
            range1 => split_first(line, ","),
            range2 => split_rest(line, ","))
        define(
            l1 => as_integer(split_first(range1, "-")),
            r1 => as_integer(split_rest(range1, "-")),
            l2 => as_integer(split_first(range2, "-")),
            r2 => as_integer(split_rest(range2, "-")))
    end

solve_part1() =
    begin
        from(assignments)
        filter(l1 >= l2 && r1 <= r2 || l2 >= l1 && r2 <= r1)
        group()
        define(part1 => count[])
    end

solve_part2() =
    begin
        from(assignments)
        filter(max(l1, l2) <= min(r1, r2))
        group()
        define(part2 => count[])
    end

solve_all() =
    let assignments = parse_assignments()
        solve_part1().cross_join(solve_part2())
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
