WITH RECURSIVE "__1" ("value", "snafu") AS (
  SELECT
    0::bigint AS "value",
    "string_to_table_1"."snafu"
  FROM string_to_table($1, '
') AS "string_to_table_1" ("snafu")
  UNION ALL
  SELECT
    (("string_to_table_3"."value" * 5) + (CASE WHEN ("string_to_table_3"."ch" = '2') THEN 2 WHEN ("string_to_table_3"."ch" = '1') THEN 1 WHEN ("string_to_table_3"."ch" = '0') THEN 0 WHEN ("string_to_table_3"."ch" = '-') THEN -1 WHEN ("string_to_table_3"."ch" = '=') THEN -2 ELSE NULL END)) AS "value",
    "string_to_table_3"."snafu"
  FROM (
    SELECT
      substr("string_to_table_2"."snafu", 2) AS "snafu",
      "string_to_table_2"."value",
      substr("string_to_table_2"."snafu", 1, 1) AS "ch"
    FROM "__1" AS "string_to_table_2"
    WHERE ("string_to_table_2"."snafu" <> '')
  ) AS "string_to_table_3"
),
"__3" ("snafu", "value") AS (
  SELECT
    '' AS "snafu",
    sum("__2"."value") AS "value"
  FROM "__1" AS "__2"
  WHERE ("__2"."snafu" = '')
  UNION ALL
  SELECT
    concat((CASE WHEN ("string_to_table_5"."digit" = 2) THEN '2' WHEN ("string_to_table_5"."digit" = 1) THEN '1' WHEN ("string_to_table_5"."digit" = 0) THEN '0' WHEN ("string_to_table_5"."digit" = -1) THEN '-' WHEN ("string_to_table_5"."digit" = -2) THEN '=' ELSE NULL END), "string_to_table_5"."snafu") AS "snafu",
    (("string_to_table_5"."value" - "string_to_table_5"."digit") / 5) AS "value"
  FROM (
    SELECT
      "string_to_table_4"."snafu",
      "string_to_table_4"."value",
      ((("string_to_table_4"."value" + 2) % 5) - 2) AS "digit"
    FROM "__3" AS "string_to_table_4"
    WHERE ("string_to_table_4"."value" <> 0)
  ) AS "string_to_table_5"
)
SELECT
  "string_to_table_6"."part1",
  "__5"."part2"
FROM (
  SELECT "__4"."snafu" AS "part1"
  FROM "__3" AS "__4"
  WHERE ("__4"."value" = 0)
) AS "string_to_table_6"
CROSS JOIN (
  SELECT NULL AS "part2"
) AS "__5"
