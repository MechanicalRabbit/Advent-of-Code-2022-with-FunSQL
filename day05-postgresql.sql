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
"moves_1" ("from", "count", "to", "index") AS (
  SELECT
    ("__4"."captures"[2]::integer) AS "from",
    ("__4"."captures"[1]::integer) AS "count",
    ("__4"."captures"[3]::integer) AS "to",
    "__4"."index"
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
    (CASE WHEN ("__6"."col" = "moves_2"."from") THEN substr("__6"."stack", ("moves_2"."count" + 1)) WHEN ("__6"."col" = "moves_2"."to") THEN concat(reverse(substr((lead("__6"."stack", ("moves_2"."from" - "__6"."col")) OVER (ORDER BY "__6"."col")), 1, "moves_2"."count")), "__6"."stack") ELSE "__6"."stack" END) AS "stack",
    "__6"."col",
    ("__6"."index" + 1) AS "index"
  FROM "__5" AS "__6"
  JOIN "moves_1" AS "moves_2" ON ("__6"."index" = "moves_2"."index")
),
"__10" ("stack", "col", "index") AS (
  SELECT
    "stacks_3"."stack",
    "stacks_3"."col",
    1 AS "index"
  FROM "stacks_1" AS "stacks_3"
  UNION ALL
  SELECT
    (CASE WHEN ("__11"."col" = "moves_3"."from") THEN substr("__11"."stack", ("moves_3"."count" + 1)) WHEN ("__11"."col" = "moves_3"."to") THEN concat(substr((lead("__11"."stack", ("moves_3"."from" - "__11"."col")) OVER (ORDER BY "__11"."col")), 1, "moves_3"."count"), "__11"."stack") ELSE "__11"."stack" END) AS "stack",
    "__11"."col",
    ("__11"."index" + 1) AS "index"
  FROM "__10" AS "__11"
  JOIN "moves_1" AS "moves_3" ON ("__11"."index" = "moves_3"."index")
)
SELECT
  "__9"."part1",
  "__14"."part2"
FROM (
  SELECT string_agg(substr("__8"."stack", 1, 1), NULL ORDER BY "__8"."col") AS "part1"
  FROM (
    SELECT
      "__7"."stack",
      "__7"."col",
      "__7"."index",
      (max("__7"."index") OVER ()) AS "max"
    FROM "__5" AS "__7"
  ) AS "__8"
  WHERE ("__8"."index" = "__8"."max")
) AS "__9"
CROSS JOIN (
  SELECT string_agg(substr("__13"."stack", 1, 1), NULL ORDER BY "__13"."col") AS "part2"
  FROM (
    SELECT
      "__12"."stack",
      "__12"."col",
      "__12"."index",
      (max("__12"."index") OVER ()) AS "max"
    FROM "__10" AS "__12"
  ) AS "__13"
  WHERE ("__13"."index" = "__13"."max")
) AS "__14"
