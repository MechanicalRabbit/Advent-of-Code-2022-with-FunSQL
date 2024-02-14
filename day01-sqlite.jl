using FunSQL
using SQLite

const funsql_as_integer = FunSQL.Fun."CAST(? AS INTEGER)"
const funsql_instr = FunSQL.Fun.instr
const funsql_substr = FunSQL.Fun.substr

@funsql begin

split_first(text, sep) =
    instr($text, $sep) > 0 ? substr($text, 1, instr($text, $sep) - 1) : $text

split_rest(text, sep) =
    instr($text, $sep) > 0 ? substr($text, instr($text, $sep) + $(length(sep))) : ""

split_step(sep) =
    begin
        filter(rest != "")
        define(
            index => index + 1,
            chunk => split_first(rest, $sep),
            rest => split_rest(rest, $sep))
    end

split(text, sep) =
    begin
        define(
            index => 0,
            rest => $text)
        split_step($sep)
        iterate(split_step($sep))
    end

parse_inventories() =
    begin
        split(:input, "\n\n")
        define(elf => index)
        split(chunk, "\n")
        define(calories => as_integer(chunk))
    end

solve_part1() =
    begin
        from(inventories)
        group(elf)
        group()
        define(part1 => max(sum(calories)))
    end

solve_part2() =
    begin
        from(inventories)
        group(elf)
        define(total => sum(calories))
        order(total.desc())
        limit(3)
        group()
        define(part2 => sum(total))
    end

solve_all() =
    begin
        solve_part1().cross_join(solve_part2())
        with(inventories => parse_inventories())
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
