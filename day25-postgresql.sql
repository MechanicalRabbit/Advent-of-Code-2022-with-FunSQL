WITH RECURSIVE "__1" ("value", "snafu") AS (
  SELECT
    (0::bigint) AS "value",
    "string_to_table_1"."snafu"
  FROM string_to_table($1, '
') AS "string_to_table_1" ("snafu")
  UNION ALL
  SELECT
    (("__3"."value" * 5) + (CASE WHEN ("__3"."ch" = '2') THEN 2 WHEN ("__3"."ch" = '1') THEN 1 WHEN ("__3"."ch" = '0') THEN 0 WHEN ("__3"."ch" = '-') THEN -1 WHEN ("__3"."ch" = '=') THEN -2 ELSE NULL END)) AS "value",
    "__3"."snafu"
  FROM (
    SELECT
      substr("__2"."snafu", 2) AS "snafu",
      "__2"."value",
      substr("__2"."snafu", 1, 1) AS "ch"
    FROM "__1" AS "__2"
    WHERE ("__2"."snafu" <> '')
  ) AS "__3"
),
"__5" ("snafu", "value") AS (
  SELECT
    '' AS "snafu",
    sum("__4"."value") AS "value"
  FROM "__1" AS "__4"
  WHERE ("__4"."snafu" = '')
  UNION ALL
  SELECT
    concat((CASE WHEN ("__7"."digit" = 2) THEN '2' WHEN ("__7"."digit" = 1) THEN '1' WHEN ("__7"."digit" = 0) THEN '0' WHEN ("__7"."digit" = -1) THEN '-' WHEN ("__7"."digit" = -2) THEN '=' ELSE NULL END), "__7"."snafu") AS "snafu",
    (("__7"."value" - "__7"."digit") / 5) AS "value"
  FROM (
    SELECT
      "__6"."snafu",
      "__6"."value",
      ((("__6"."value" + 2) % 5) - 2) AS "digit"
    FROM "__5" AS "__6"
    WHERE ("__6"."value" <> 0)
  ) AS "__7"
)
SELECT
  "__9"."part1",
  "__10"."part2"
FROM (
  SELECT "__8"."snafu" AS "part1"
  FROM "__5" AS "__8"
  WHERE ("__8"."value" = 0)
) AS "__9"
CROSS JOIN (
  SELECT NULL AS "part2"
) AS "__10"
