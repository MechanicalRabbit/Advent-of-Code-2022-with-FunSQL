WITH RECURSIVE "__1" ("dir", "size", "rest") AS (
  SELECT
    (CASE WHEN ((CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, 1, (instr(?1, '
') - 1)) ELSE ?1 END) = '$ cd /') THEN '/' WHEN ((CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, 1, (instr(?1, '
') - 1)) ELSE ?1 END) = '$ cd ..') THEN rtrim(rtrim(NULL, '/'), 'abcdefghijklmnopqrstuvwxyz') WHEN (substr((CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, 1, (instr(?1, '
') - 1)) ELSE ?1 END), 1, 4) = '$ cd') THEN (NULL || substr((CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, 1, (instr(?1, '
') - 1)) ELSE ?1 END), 6) || '/') ELSE NULL END) AS "dir",
    CAST((CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, 1, (instr(?1, '
') - 1)) ELSE ?1 END) AS INTEGER) AS "size",
    (CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, (instr(?1, '
') + 1)) ELSE '' END) AS "rest"
  WHERE (?1 <> '')
  UNION ALL
  SELECT
    (CASE WHEN ((CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", 1, (instr("__2"."rest", '
') - 1)) ELSE "__2"."rest" END) = '$ cd /') THEN '/' WHEN ((CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", 1, (instr("__2"."rest", '
') - 1)) ELSE "__2"."rest" END) = '$ cd ..') THEN rtrim(rtrim("__2"."dir", '/'), 'abcdefghijklmnopqrstuvwxyz') WHEN (substr((CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", 1, (instr("__2"."rest", '
') - 1)) ELSE "__2"."rest" END), 1, 4) = '$ cd') THEN ("__2"."dir" || substr((CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", 1, (instr("__2"."rest", '
') - 1)) ELSE "__2"."rest" END), 6) || '/') ELSE "__2"."dir" END) AS "dir",
    CAST((CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", 1, (instr("__2"."rest", '
') - 1)) ELSE "__2"."rest" END) AS INTEGER) AS "size",
    (CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", (instr("__2"."rest", '
') + 1)) ELSE '' END) AS "rest"
  FROM "__1" AS "__2"
  WHERE ("__2"."rest" <> '')
),
"dirs_1" ("size", "dir") AS (
  SELECT
    sum("__3"."size") AS "size",
    "__3"."dir"
  FROM "__1" AS "__3"
  GROUP BY "__3"."dir"
),
"totals_1" ("total") AS (
  SELECT sum("dirs_3"."size") AS "total"
  FROM "dirs_1" AS "dirs_2"
  JOIN "dirs_1" AS "dirs_3" ON (substr("dirs_3"."dir", 1, length("dirs_2"."dir")) = "dirs_2"."dir")
  GROUP BY "dirs_2"."dir"
)
SELECT
  "totals_3"."part1",
  "totals_6"."part2"
FROM (
  SELECT sum("totals_2"."total") AS "part1"
  FROM "totals_1" AS "totals_2"
  WHERE ("totals_2"."total" <= 100000)
) AS "totals_3"
CROSS JOIN (
  SELECT min("totals_5"."total") AS "part2"
  FROM (
    SELECT
      "totals_4"."total",
      ((max("totals_4"."total") OVER ()) - 40000000) AS "limit"
    FROM "totals_1" AS "totals_4"
  ) AS "totals_5"
  WHERE ("totals_5"."total" >= "totals_5"."limit")
) AS "totals_6"
