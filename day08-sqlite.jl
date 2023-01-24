using FunSQL
using SQLite

@funsql begin

split_first(text, sep) =
    instr(text, sep) > 0 ? substr(text, 1, instr(text, sep) - 1) : text

split_rest(text, sep) =
    instr(text, sep) > 0 ? substr(text, instr(text, sep) + $(length(sep))) : ""

split_lines_one_step() =
    begin
        filter(rest != "")
        define(
            row => row + 1,
            line => split_first(rest, "\n"),
            rest => split_rest(rest, "\n"))
    end

split_lines(text) =
    begin
        define(
            row => 0,
            rest => text)
        split_lines_one_step()
        iterate(split_lines_one_step())
    end

split_heights_one_step() =
    begin
        filter(rest != "")
        define(
            col => col + 1,
            height => `CAST(? AS INTEGER)`(substr(rest, 1, 1)),
            rest => substr(rest, 2))
    end

split_heights(line) =
    begin
        define(
            col => 0,
            rest => line)
        split_heights_one_step()
        iterate(split_heights_one_step())
    end

parse_heights() =
    split_lines(:input).split_heights(line)

define_max_height(dir, dim1, dim2) =
    begin
        partition(
            dim1,
            order_by = [dim2],
            frame = (mode = rows, start = -Inf, finish = -1))
        define(dir => coalesce(max[height], -1))
    end

solve_part1() =
    begin
        from(heights)
        define_max_height(up, col, row)
        define_max_height(down, col, -row)
        define_max_height(left, row, col)
        define_max_height(right, row, -col)
        filter(height > up || height > down || height > left || height > right)
        group()
        define(part1 => count[])
    end

visibility(dim) =
    coalesce(dim - coalesce(max[dim, filter = height >= threshold], min[dim]), 0)

define_visibility(dir, dim1, dim2) =
    begin
        partition(
            by = [threshold, dim1],
            order_by = [dim2],
            frame = (mode = rows, start = -Inf, finish = -1))
        define(dir => visibility(dim2))
    end

solve_part2() =
    begin
        from(heights)
        cross_join(from((; threshold = 0:9)))
        define_visibility(up, col, row)
        define_visibility(down, col, -row)
        define_visibility(left, row, col)
        define_visibility(right, row, -col)
        filter(height == threshold)
        define(score => up * down * left * right)
        group()
        define(part2 => max[score])
    end

solve_all() =
    let heights = parse_heights()
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
