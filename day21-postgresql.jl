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

as_bigint(str) =
    `(?::bigint)`($str)

parse_jobs() =
    begin
        from(
            regexp_matches(:input, "(\\w+): (?:(\\d+)|(\\w+) (.) (\\w+))", "g"),
            columns = [captures])
        define(
            var => array_get(captures, 1),
            val => as_bigint(array_get(captures, 2)),
            ref1 => array_get(captures, 3),
            op => array_get(captures, 4),
            ref2 => array_get(captures, 5))
    end

evaluate_step() =
    begin
        partition()
        filter(is_null(min[val, filter = var == "root"]))
        partition(is_null(val) ? ref1 : var)
        define(ref1_val => min[val])
        partition(is_null(val) ? ref2 : var)
        define(ref2_val => min[val])
        define(
            val =>
                coalesce(
                    val,
                    if op == "+"
                        ref1_val + ref2_val
                    elseif op == "-"
                        ref1_val - ref2_val
                    elseif op == "*"
                        ref1_val * ref2_val
                    elseif op == "/"
                        ref1_val / ref2_val
                    end))
    end

solve_part1() =
    begin
        from(jobs)
        iterate(evaluate_step())
        group()
        define(part1 => min[val, filter = var == "root"])
    end

evaluate_frac_step() =
    begin
        partition()
        filter(is_null(min[a, filter = var == "root"]))
        partition(is_null(a) ? ref1 : var)
        define(
            a1 => min[a],
            b1 => min[b],
            c1 => min[c],
            d1 => min[d])
        partition(is_null(a) ? ref2 : var)
        define(
            a2 => min[a],
            b2 => min[b],
            c2 => min[c],
            d2 => min[d])
        define(
            a =>
                coalesce(
                    a,
                    if op == "+"
                        a1 * d2 + b1 * c2 + a2 * d1 + b2 * c1
                    elseif op == "-"
                        a1 * d2 + b1 * c2 - a2 * d1 - b2 * c1
                    elseif op == "*"
                        a1 * b2 + b1 * a2
                    elseif op == "/"
                        a1 * d2 + b1 * c2
                    end),
            b =>
                coalesce(
                    b,
                    if op == "+"
                        b1 * d2 + b2 * d1
                    elseif op == "-"
                        b1 * d2 - b2 * d1
                    elseif op == "*"
                        b1 * b2
                    elseif op == "/"
                        b1 * d2
                    end),
            c =>
                coalesce(
                    c,
                    if op == "+" || op == "-" || op == "*"
                        c1 * d2 + d1 * c2
                    elseif op == "/"
                        c1 * b2 + d1 * a2
                    end),
            d =>
                coalesce(
                    d,
                    if op == "+" || op == "-" || op == "*"
                        d1 * d2
                    elseif op == "/"
                        d1 * b2
                    end))
        define(g => gcd(gcd(gcd(a, b), c), d))
        define(
            a => a / g,
            b => b / g,
            c => c / g,
            d => d / g)
    end

solve_part2() =
    begin
        from(jobs)
        define(
            a => as_bigint(case(var == "humn", 1, is_not_null(val), 0)),
            b => as_bigint(case(var == "humn", 0, is_not_null(val), val)),
            c => as_bigint(case(var == "humn", 0, is_not_null(val), 0)),
            d => as_bigint(case(var == "humn", 1, is_not_null(val), 1)))
        iterate(evaluate_frac_step())
        partition()
        define(
            root_ref1 => min[ref1, filter = var == "root"],
            root_ref2 => min[ref2, filter = var == "root"])
        group()
        define(
            a1 => min[a, filter = var == root_ref1],
            b1 => min[b, filter = var == root_ref1],
            c1 => min[c, filter = var == root_ref1],
            d1 => min[d, filter = var == root_ref1],
            a2 => min[a, filter = var == root_ref2],
            b2 => min[b, filter = var == root_ref2],
            c2 => min[c, filter = var == root_ref2],
            d2 => min[d, filter = var == root_ref2])
        select(part2 => - (b1 * d2 - b2 * d1) / (a1 * d2 + b1 * c2 - a2 * d1 - b2 * c1))
    end

solve_all() =
    let jobs = parse_jobs()
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
