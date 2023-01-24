WITH RECURSIVE "__1" ("addx", "ip", "line", "rest") AS (
  SELECT
    CAST(substr((CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, 1, (instr(?1, '
') - 1)) ELSE ?1 END), 6) AS INTEGER) AS "addx",
    (0 + 1) AS "ip",
    (CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, 1, (instr(?1, '
') - 1)) ELSE ?1 END) AS "line",
    (CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, (instr(?1, '
') + 1)) ELSE '' END) AS "rest"
  WHERE (?1 <> '')
  UNION ALL
  SELECT
    CAST(substr((CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", 1, (instr("__2"."rest", '
') - 1)) ELSE "__2"."rest" END), 6) AS INTEGER) AS "addx",
    ("__2"."ip" + 1) AS "ip",
    (CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", 1, (instr("__2"."rest", '
') - 1)) ELSE "__2"."rest" END) AS "line",
    (CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", (instr("__2"."rest", '
') + 1)) ELSE '' END) AS "rest"
  FROM "__1" AS "__2"
  WHERE ("__2"."rest" <> '')
),
"cycles_1" ("x", "cycle") AS (
  SELECT
    (1 + (sum(("__3"."addx" * "values_2"."tick")) OVER (ORDER BY "__3"."ip", "values_2"."tick" ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING))) AS "x",
    (1 + coalesce((count(*) OVER (ORDER BY "__3"."ip", "values_2"."tick" ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)), 0)) AS "cycle"
  FROM "__1" AS "__3"
  LEFT JOIN (
    SELECT "values_1"."column1" AS "tick"
    FROM (
      VALUES
        (0),
        (1)
    ) AS "values_1"
  ) AS "values_2" ON ("__3"."line" <> 'noop')
)
SELECT
  "cycles_3"."part1",
  "cycles_8"."part2"
FROM (
  SELECT sum(("cycles_2"."x" * "cycles_2"."cycle")) AS "part1"
  FROM "cycles_1" AS "cycles_2"
  WHERE (mod(("cycles_2"."cycle" + 20), 40) = 0)
) AS "cycles_3"
CROSS JOIN (
  SELECT group_concat("cycles_7"."line", '
') AS "part2"
  FROM (
    SELECT group_concat("cycles_6"."pixel", '') AS "line"
    FROM (
      SELECT
        "cycles_5"."row",
        (CASE WHEN ("cycles_5"."col" BETWEEN "cycles_5"."x" AND ("cycles_5"."x" + 2)) THEN '#' ELSE '.' END) AS "pixel"
      FROM (
        SELECT
          (1 + (("cycles_4"."cycle" - 1) / 40)) AS "row",
          (1 + mod(("cycles_4"."cycle" - 1), 40)) AS "col",
          "cycles_4"."x"
        FROM "cycles_1" AS "cycles_4"
      ) AS "cycles_5"
      ORDER BY
        "cycles_5"."row",
        "cycles_5"."col"
    ) AS "cycles_6"
    GROUP BY "cycles_6"."row"
    ORDER BY "cycles_6"."row"
  ) AS "cycles_7"
) AS "cycles_8"
