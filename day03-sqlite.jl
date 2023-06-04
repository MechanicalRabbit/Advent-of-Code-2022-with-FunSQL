using FunSQL
using SQLite

@funsql begin

split_line(text) =
    instr($text, "\n") > 0 ? substr($text, 1, instr($text, "\n") - 1) : $text

split_rest(text) =
    instr($text, "\n") > 0 ? substr($text, instr($text, "\n") + 1) : ""

split_lines_one_step() =
    begin
        filter(rest != "")
        define(
            index => index + 1,
            line => split_line(rest),
            rest => split_rest(rest))
    end

split_lines(text) =
    begin
        define(
            index => 0,
            rest => $text)
        split_lines_one_step()
        iterate(split_lines_one_step())
    end

parse_rucksacks() =
    split_lines(:input)

from_characters() =
    from($([(char = string(ch),
             priority = ch in 'a':'z' ? ch - 'a' + 1 : ch - 'A' + 27)
            for ch in [('a':'z')..., ('A':'Z')...]]))

solve_part1() =
    begin
        from(rucksacks)
        define(
            left => substr(line, 1, length(line) / 2),
            right => substr(line, 1 + length(line) / 2))
        join(from(characters), on = instr(left, char) && instr(right, char))
        group()
        define(part1 => sum[priority])
    end

solve_part2() =
    begin
        from(rucksacks)
        partition(order_by = [index])
        define(
            line1 => lag[line, 2],
            line2 => lag[line, 1],
            line3 => line)
        filter(mod(index, 3) == 0)
        join(
            from(characters),
            on = instr(line1, char) && instr(line2, char) && instr(line3, char))
        group()
        define(part2 => sum[priority])
    end

solve_all() =
    let rucksacks = parse_rucksacks(),
        characters = from_characters()
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
