using FunSQL
using SQLite

function ScoreByLine(score_table)
    cases = FunSQL.SQLNode[]
    for i = 1:3
        for j = 1:3
            line = "$('A'+i-1) $('X'+j-1)"
            push!(cases, FunSQL.Get(:line) .== line, score_table[i, j])
        end
    end
    FunSQL.Fun(:case, cases...)
end

# Scores indexed by [opponent move, my move].
const scores_part1 = [(1+3) (2+6) (3+0); (1+0) (2+3) (3+6); (1+6) (2+0) (3+3)]

# Scores indexed by [opponent move, outcome].
const scores_part2 = [(3+0) (1+3) (2+6); (1+0) (2+3) (3+6); (2+0) (3+3) (1+6)]

@funsql begin

split_line(text) =
    instr($text, "\n") > 0 ? substr($text, 1, instr($text, "\n") - 1) : $text

split_rest(text) =
    instr($text, "\n") > 0 ? substr($text, instr($text, "\n") + 1) : ""

split_lines_one_step() =
    begin
        filter(rest != "")
        define(
            line => split_line(rest),
            rest => split_rest(rest))
    end

split_lines(text) =
    begin
        define(rest => $text)
        split_lines_one_step()
        iterate(split_lines_one_step())
    end

parse_guide() =
    split_lines(:input)

solve_part1() =
    begin
        from(guide)
        define(score => $(ScoreByLine(scores_part1)))
        group()
        define(part1 => sum[score])
    end

solve_part2() =
    begin
        from(guide)
        define(score => $(ScoreByLine(scores_part2)))
        group()
        define(part2 => sum[score])
    end

solve_all() =
    let guide = parse_guide()
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
