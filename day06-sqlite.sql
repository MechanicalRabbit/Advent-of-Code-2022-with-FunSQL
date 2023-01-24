WITH RECURSIVE "__2" ("index", "char", "rest") AS (
  SELECT
    ("__1"."index" + 1) AS "index",
    substr("__1"."rest", 1, 1) AS "char",
    substr("__1"."rest", 2) AS "rest"
  FROM (
    SELECT
      0 AS "index",
      rtrim(?1, '
') AS "rest"
  ) AS "__1"
  WHERE ("__1"."rest" <> '')
  UNION ALL
  SELECT
    ("__3"."index" + 1) AS "index",
    substr("__3"."rest", 1, 1) AS "char",
    substr("__3"."rest", 2) AS "rest"
  FROM "__2" AS "__3"
  WHERE ("__3"."rest" <> '')
),
"starts_1" ("start", "length") AS (
  SELECT
    min("__6"."index") AS "start",
    "__6"."length"
  FROM (
    SELECT
      ("__5"."index" - (max("__5"."rep_index") OVER (ORDER BY "__5"."index"))) AS "length",
      "__5"."index"
    FROM (
      SELECT
        "__4"."index",
        coalesce((max("__4"."index") OVER (PARTITION BY "__4"."char" ORDER BY "__4"."index" ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)), 0) AS "rep_index"
      FROM "__2" AS "__4"
    ) AS "__5"
  ) AS "__6"
  GROUP BY "__6"."length"
)
SELECT
  "starts_3"."part1",
  "starts_5"."part2"
FROM (
  SELECT "starts_2"."start" AS "part1"
  FROM "starts_1" AS "starts_2"
  WHERE ("starts_2"."length" = 4)
) AS "starts_3"
CROSS JOIN (
  SELECT "starts_4"."start" AS "part2"
  FROM "starts_1" AS "starts_4"
  WHERE ("starts_4"."length" = 14)
) AS "starts_5"
