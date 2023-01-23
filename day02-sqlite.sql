WITH RECURSIVE "__1" ("line", "rest") AS (
  SELECT
    (CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, 1, (instr(?1, '
') - 1)) ELSE ?1 END) AS "line",
    (CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, (instr(?1, '
') + 1)) ELSE '' END) AS "rest"
  WHERE (?1 <> '')
  UNION ALL
  SELECT
    (CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", 1, (instr("__2"."rest", '
') - 1)) ELSE "__2"."rest" END) AS "line",
    (CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", (instr("__2"."rest", '
') + 1)) ELSE '' END) AS "rest"
  FROM "__1" AS "__2"
  WHERE ("__2"."rest" <> '')
),
"guide_1" ("line") AS (
  SELECT "__3"."line"
  FROM "__1" AS "__3"
)
SELECT
  "guide_3"."part1",
  "guide_5"."part2"
FROM (
  SELECT sum((CASE WHEN ("guide_2"."line" = 'A X') THEN 4 WHEN ("guide_2"."line" = 'A Y') THEN 8 WHEN ("guide_2"."line" = 'A Z') THEN 3 WHEN ("guide_2"."line" = 'B X') THEN 1 WHEN ("guide_2"."line" = 'B Y') THEN 5 WHEN ("guide_2"."line" = 'B Z') THEN 9 WHEN ("guide_2"."line" = 'C X') THEN 7 WHEN ("guide_2"."line" = 'C Y') THEN 2 WHEN ("guide_2"."line" = 'C Z') THEN 6 END)) AS "part1"
  FROM "guide_1" AS "guide_2"
) AS "guide_3"
CROSS JOIN (
  SELECT sum((CASE WHEN ("guide_4"."line" = 'A X') THEN 3 WHEN ("guide_4"."line" = 'A Y') THEN 4 WHEN ("guide_4"."line" = 'A Z') THEN 8 WHEN ("guide_4"."line" = 'B X') THEN 1 WHEN ("guide_4"."line" = 'B Y') THEN 5 WHEN ("guide_4"."line" = 'B Z') THEN 9 WHEN ("guide_4"."line" = 'C X') THEN 2 WHEN ("guide_4"."line" = 'C Y') THEN 6 WHEN ("guide_4"."line" = 'C Z') THEN 7 END)) AS "part2"
  FROM "guide_1" AS "guide_4"
) AS "guide_5"
