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
    "__5"."index",
    "__5"."round",
    "__5"."level"
  FROM (
    SELECT
      "__4"."next_index" AS "index",
      ("__4"."round" + (CASE WHEN ("__4"."next_index" < "__4"."index") THEN 1 ELSE 0 END)) AS "round",
      "__4"."level"
    FROM (
      SELECT
        "__3"."level",
        "__3"."round",
        (CASE WHEN (mod("__3"."level", "__3"."test") = 0) THEN "__3"."on_true" ELSE "__3"."on_false" END) AS "next_index",
        "__3"."index"
      FROM (
        SELECT
          ((CASE WHEN ("monkeys_3"."op" = '+') THEN ("__2"."level" + "monkeys_3"."arg") ELSE ("__2"."level" * coalesce("monkeys_3"."arg", "__2"."level")) END) / 3) AS "level",
          "__2"."round",
          "__2"."index",
          "monkeys_3"."test",
          "monkeys_3"."on_true",
          "monkeys_3"."on_false"
        FROM "__1" AS "__2"
        JOIN "monkeys_1" AS "monkeys_3" ON ("__2"."index" = "monkeys_3"."index")
      ) AS "__3"
    ) AS "__4"
  ) AS "__5"
  WHERE ("__5"."round" <= 20)
),
"__10" ("product", "index") AS (
  SELECT
    (1::bigint) AS "product",
    0 AS "index"
  UNION ALL
  SELECT
    ("__11"."product" * "monkeys_4"."test") AS "product",
    ("__11"."index" + 1) AS "index"
  FROM "__10" AS "__11"
  JOIN "monkeys_1" AS "monkeys_4" ON ("__11"."index" = "monkeys_4"."index")
),
"product_1" ("product") AS (
  SELECT max("__12"."product") AS "product"
  FROM "__10" AS "__12"
),
"__13" ("index", "round", "level") AS (
  SELECT
    "items_3"."index",
    1 AS "round",
    "items_3"."level"
  FROM "items_1" AS "items_3"
  UNION ALL
  SELECT
    "__17"."index",
    "__17"."round",
    "__17"."level"
  FROM (
    SELECT
      "__16"."next_index" AS "index",
      ("__16"."round" + (CASE WHEN ("__16"."next_index" < "__16"."index") THEN 1 ELSE 0 END)) AS "round",
      "__16"."level"
    FROM (
      SELECT
        "__15"."level",
        "__15"."round",
        (CASE WHEN (mod("__15"."level", "__15"."test") = 0) THEN "__15"."on_true" ELSE "__15"."on_false" END) AS "next_index",
        "__15"."index"
      FROM (
        SELECT
          mod((CASE WHEN ("monkeys_5"."op" = '+') THEN ("__14"."level" + "monkeys_5"."arg") ELSE ("__14"."level" * coalesce("monkeys_5"."arg", "__14"."level")) END), "product_2"."product") AS "level",
          "__14"."round",
          "__14"."index",
          "monkeys_5"."test",
          "monkeys_5"."on_true",
          "monkeys_5"."on_false"
        FROM "__13" AS "__14"
        CROSS JOIN "product_1" AS "product_2"
        JOIN "monkeys_1" AS "monkeys_5" ON ("__14"."index" = "monkeys_5"."index")
      ) AS "__15"
    ) AS "__16"
  ) AS "__17"
  WHERE ("__17"."round" <= 10000)
)
SELECT
  "__9"."part1",
  "__21"."part2"
FROM (
  SELECT max("__8"."score") AS "part1"
  FROM (
    SELECT ("__7"."total" * (lag("__7"."total") OVER (ORDER BY "__7"."total"))) AS "score"
    FROM (
      SELECT count(*) AS "total"
      FROM "__1" AS "__6"
      GROUP BY "__6"."index"
    ) AS "__7"
  ) AS "__8"
) AS "__9"
CROSS JOIN (
  SELECT max("__20"."score") AS "part2"
  FROM (
    SELECT ("__19"."total" * (lag("__19"."total") OVER (ORDER BY "__19"."total"))) AS "score"
    FROM (
      SELECT count(*) AS "total"
      FROM "__13" AS "__18"
      GROUP BY "__18"."index"
    ) AS "__19"
  ) AS "__20"
) AS "__21"
