WITH RECURSIVE "monkeys_1" ("test", "on_true", "on_false", "op", "arg", "index", "levels") AS (
  SELECT
    ("regexp_matches_1"."captures"[5]::bigint) AS "test",
    ("regexp_matches_1"."captures"[6]::integer) AS "on_true",
    ("regexp_matches_1"."captures"[7]::integer) AS "on_false",
    "regexp_matches_1"."captures"[3] AS "op",
    ("regexp_matches_1"."captures"[4]::integer) AS "arg",
    ("regexp_matches_1"."captures"[1]::integer) AS "index",
    "regexp_matches_1"."captures"[2] AS "levels"
  FROM regexp_matches($1, 'Monkey ([0-9]+):
  Starting items: ([0-9, ]+)
  Operation: new = old ([+*]) (?:([0-9]+)|old)
  Test: divisible by ([0-9]+)
    If true: throw to monkey ([0-9]+)
    If false: throw to monkey ([0-9]+)
', 'g') AS "regexp_matches_1" ("captures")
),
"items_1" ("index", "level") AS (
  SELECT
    "monkeys_2"."index",
    ("string_to_table_1"."level"::bigint) AS "level"
  FROM "monkeys_1" AS "monkeys_2"
  CROSS JOIN string_to_table("monkeys_2"."levels", ', ') AS "string_to_table_1" ("level")
),
"__1" ("index", "round", "level") AS (
  SELECT
    "items_2"."index",
    1 AS "round",
    "items_2"."level"
  FROM "items_1" AS "items_2"
  UNION ALL
  SELECT
    "items_6"."index",
    "items_6"."round",
    "items_6"."level"
  FROM (
    SELECT
      "items_5"."next_index" AS "index",
      ("items_5"."round" + (CASE WHEN ("items_5"."next_index" < "items_5"."index") THEN 1 ELSE 0 END)) AS "round",
      "items_5"."level"
    FROM (
      SELECT
        "items_4"."level",
        (CASE WHEN (mod("items_4"."level", "items_4"."test") = 0) THEN "items_4"."on_true" ELSE "items_4"."on_false" END) AS "next_index",
        "items_4"."round",
        "items_4"."index"
      FROM (
        SELECT
          ((CASE WHEN ("monkeys_3"."op" = '+') THEN ("items_3"."level" + "monkeys_3"."arg") ELSE ("items_3"."level" * coalesce("monkeys_3"."arg", "items_3"."level")) END) / 3) AS "level",
          "items_3"."round",
          "items_3"."index",
          "monkeys_3"."test",
          "monkeys_3"."on_true",
          "monkeys_3"."on_false"
        FROM "__1" AS "items_3"
        JOIN "monkeys_1" AS "monkeys_3" ON ("items_3"."index" = "monkeys_3"."index")
      ) AS "items_4"
    ) AS "items_5"
  ) AS "items_6"
  WHERE ("items_6"."round" <= 20)
),
"__3" ("product", "index") AS (
  SELECT
    (1::bigint) AS "product",
    0 AS "index"
  UNION ALL
  SELECT
    ("__4"."product" * "monkeys_4"."test") AS "product",
    ("__4"."index" + 1) AS "index"
  FROM "__3" AS "__4"
  JOIN "monkeys_1" AS "monkeys_4" ON ("__4"."index" = "monkeys_4"."index")
),
"product_1" ("product") AS (
  SELECT max("__5"."product") AS "product"
  FROM "__3" AS "__5"
),
"__6" ("index", "round", "level") AS (
  SELECT
    "items_10"."index",
    1 AS "round",
    "items_10"."level"
  FROM "items_1" AS "items_10"
  UNION ALL
  SELECT
    "items_14"."index",
    "items_14"."round",
    "items_14"."level"
  FROM (
    SELECT
      "items_13"."next_index" AS "index",
      ("items_13"."round" + (CASE WHEN ("items_13"."next_index" < "items_13"."index") THEN 1 ELSE 0 END)) AS "round",
      "items_13"."level"
    FROM (
      SELECT
        "items_12"."level",
        (CASE WHEN (mod("items_12"."level", "items_12"."test") = 0) THEN "items_12"."on_true" ELSE "items_12"."on_false" END) AS "next_index",
        "items_12"."round",
        "items_12"."index"
      FROM (
        SELECT
          mod((CASE WHEN ("monkeys_5"."op" = '+') THEN ("items_11"."level" + "monkeys_5"."arg") ELSE ("items_11"."level" * coalesce("monkeys_5"."arg", "items_11"."level")) END), "product_2"."product") AS "level",
          "items_11"."round",
          "items_11"."index",
          "monkeys_5"."test",
          "monkeys_5"."on_true",
          "monkeys_5"."on_false"
        FROM "__6" AS "items_11"
        CROSS JOIN "product_1" AS "product_2"
        JOIN "monkeys_1" AS "monkeys_5" ON ("items_11"."index" = "monkeys_5"."index")
      ) AS "items_12"
    ) AS "items_13"
  ) AS "items_14"
  WHERE ("items_14"."round" <= 10000)
)
SELECT
  "items_9"."part1",
  "items_17"."part2"
FROM (
  SELECT max("items_8"."score") AS "part1"
  FROM (
    SELECT ("items_7"."total" * (lag("items_7"."total") OVER (ORDER BY "items_7"."total"))) AS "score"
    FROM (
      SELECT count(*) AS "total"
      FROM "__1" AS "__2"
      GROUP BY "__2"."index"
    ) AS "items_7"
  ) AS "items_8"
) AS "items_9"
CROSS JOIN (
  SELECT max("items_16"."score") AS "part2"
  FROM (
    SELECT ("items_15"."total" * (lag("items_15"."total") OVER (ORDER BY "items_15"."total"))) AS "score"
    FROM (
      SELECT count(*) AS "total"
      FROM "__6" AS "__7"
      GROUP BY "__7"."index"
    ) AS "items_15"
  ) AS "items_16"
) AS "items_17"
