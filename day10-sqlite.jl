using FunSQL
using SQLite

@funsql begin

split_first(text, sep = "\n") =
    instr(text, sep) > 0 ? substr(text, 1, instr(text, sep) - 1) : text

split_rest(text, sep = "\n") =
    instr(text, sep) > 0 ? substr(text, instr(text, sep) + $(length(sep))) : ""

addx(line) =
    `CAST(? AS INTEGER)`(substr(line, 6))

split_one_instruction() =
    begin
        filter(rest != "")
        define(
            ip => ip + 1,
            line => split_first(rest),
            addx => addx(split_first(rest)),
            rest => split_rest(rest))
    end

split_instructions(text) =
    begin
        define(
            ip => 0,
            rest => text)
        split_one_instruction()
        iterate(split_one_instruction())
    end

expand_cycles() =
    begin
        split_instructions(:input)
        left_join(from((; tick = [0, 1])), on = line != "noop")
        partition(
            order_by = [ip, tick],
            frame = (mode = rows, start = -Inf, finish = -1))
        define(
            cycle => 1 + coalesce(count[], 0),
            x => 1 + sum[addx * tick])
    end

solve_part1() =
    begin
        from(cycles)
        filter(mod(cycle + 20, 40) == 0)
        group()
        define(part1 => sum[x * cycle])
    end

solve_part2() =
    begin
        from(cycles)
        define(
            row => 1 + (cycle - 1) / 40,
            col => 1 + mod(cycle - 1, 40))
        define(pixel => between(col, x, x + 2) ? "#" : ".")
        order(row, col)
        group(row)
        define(line => group_concat[pixel, ""])
        order(row)
        group()
        define(part2 => group_concat[line, "\n"])
    end

solve_all() =
    let cycles = expand_cycles()
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
        println("[$file] part1:\n$(output.part1)\n[$file] part2:\n$(output.part2)")
    end
end
