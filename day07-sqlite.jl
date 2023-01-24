using FunSQL
using SQLite

@funsql begin

split_first(text, sep) =
    instr(text, sep) > 0 ? substr(text, 1, instr(text, sep) - 1) : text

split_rest(text, sep) =
    instr(text, sep) > 0 ? substr(text, instr(text, sep) + $(length(sep))) : ""

current_dir(line) =
    if line == "\$ cd /"
        "/"
    elseif line == "\$ cd .."
        rtrim(rtrim(dir, "/"), $(join('a':'z')))
    elseif substr(line, 1, 4) == "\$ cd"
        concat(dir, substr(line, 6), "/")
    else
        dir
    end

split_lines_one_step() =
    begin
        filter(rest != "")
        define(
            dir => current_dir(split_first(rest, "\n")),
            size => `CAST(? AS INTEGER)`(split_first(rest, "\n")),
            rest => split_rest(rest, "\n"))
    end

split_lines(text) =
    begin
        define(
            rest => text,
            dir => missing)
        split_lines_one_step()
        iterate(split_lines_one_step())
    end

parse_dirs() =
    begin
        split_lines(:input)
        group(dir)
        define(size => sum[size])
    end

calculate_totals() =
    begin
        from(dirs)
        join(
            nested => from(dirs),
            on = substr(nested.dir, 1, length(dir)) == dir)
        group(dir)
        define(total => sum[nested.size])
    end

solve_part1() =
    begin
        from(totals)
        filter(total <= 100000)
        group()
        define(part1 => sum[total])
    end

solve_part2() =
    begin
        from(totals)
        partition()
        define(limit => max[total] - $(70000000 - 30000000))
        filter(total >= limit)
        group()
        define(part2 => min[total])
    end

solve_all() =
    let dirs = parse_dirs(),
        totals = calculate_totals()
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
