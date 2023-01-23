WITH RECURSIVE "stacks_1" ("stack", "col") AS (
  SELECT
    string_agg("__3"."char", NULL ORDER BY "__3"."row") AS "stack",
    "__3"."col"
  FROM (
    SELECT
      ("__2"."col"::integer) AS "col",
      nullif("__2"."captures"[1], ' ') AS "char",
      "__1"."row"
    FROM string_to_table(split_part($1, '
 1', 1), '
') WITH ORDINALITY AS "__1" ("line", "row")
    CROSS JOIN regexp_matches("__1"."line", '.(.). ?', 'g') WITH ORDINALITY AS "__2" ("captures", "col")
  ) AS "__3"
  GROUP BY "__3"."col"
),
"moves_1" ("index", "from", "count", "to") AS (
  SELECT
    "__4"."index",
    ("__4"."captures"[2]::integer) AS "from",
    ("__4"."captures"[1]::integer) AS "count",
    ("__4"."captures"[3]::integer) AS "to"
  FROM regexp_matches($1, 'move (\d+) from (\d+) to (\d+)', 'g') WITH ORDINALITY AS "__4" ("captures", "index")
),
"__5" ("stack", "col", "index") AS (
  SELECT
    "stacks_2"."stack",
    "stacks_2"."col",
    1 AS "index"
  FROM "stacks_1" AS "stacks_2"
  UNION ALL
  SELECT
    (CASE WHEN ("stacks_3"."col" = "moves_2"."from") THEN substr("stacks_3"."stack", ("moves_2"."count" + 1)) WHEN ("stacks_3"."col" = "moves_2"."to") THEN concat(reverse(substr((lead("stacks_3"."stack", ("moves_2"."from" - "stacks_3"."col")) OVER (ORDER BY "stacks_3"."col")), 1, "moves_2"."count")), "stacks_3"."stack") ELSE "stacks_3"."stack" END) AS "stack",
    "stacks_3"."col",
    ("stacks_3"."index" + 1) AS "index"
  FROM "__5" AS "stacks_3"
  JOIN "moves_1" AS "moves_2" ON ("stacks_3"."index" = "moves_2"."index")
),
"__7" ("stack", "col", "index") AS (
  SELECT
    "stacks_6"."stack",
    "stacks_6"."col",
    1 AS "index"
  FROM "stacks_1" AS "stacks_6"
  UNION ALL
  SELECT
    (CASE WHEN ("stacks_7"."col" = "moves_3"."from") THEN substr("stacks_7"."stack", ("moves_3"."count" + 1)) WHEN ("stacks_7"."col" = "moves_3"."to") THEN concat(substr((lead("stacks_7"."stack", ("moves_3"."from" - "stacks_7"."col")) OVER (ORDER BY "stacks_7"."col")), 1, "moves_3"."count"), "stacks_7"."stack") ELSE "stacks_7"."stack" END) AS "stack",
    "stacks_7"."col",
    ("stacks_7"."index" + 1) AS "index"
  FROM "__7" AS "stacks_7"
  JOIN "moves_1" AS "moves_3" ON ("stacks_7"."index" = "moves_3"."index")
)
SELECT
  "stacks_5"."part1",
  "stacks_9"."part2"
FROM (
  SELECT string_agg(substr("stacks_4"."stack", 1, 1), NULL ORDER BY "stacks_4"."col") AS "part1"
  FROM (
    SELECT
      "__6"."stack",
      "__6"."col",
      "__6"."index",
      (max("__6"."index") OVER ()) AS "max"
    FROM "__5" AS "__6"
  ) AS "stacks_4"
  WHERE ("stacks_4"."index" = "stacks_4"."max")
) AS "stacks_5"
CROSS JOIN (
  SELECT string_agg(substr("stacks_8"."stack", 1, 1), NULL ORDER BY "stacks_8"."col") AS "part2"
  FROM (
    SELECT
      "__8"."stack",
      "__8"."col",
      "__8"."index",
      (max("__8"."index") OVER ()) AS "max"
    FROM "__7" AS "__8"
  ) AS "stacks_8"
  WHERE ("stacks_8"."index" = "stacks_8"."max")
) AS "stacks_9"
