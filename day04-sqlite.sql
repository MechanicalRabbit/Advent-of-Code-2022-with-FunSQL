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
"assignments_1" ("l1", "l2", "r1", "r2") AS (
  SELECT
    CAST((CASE WHEN (instr("__4"."range1", '-') > 0) THEN substr("__4"."range1", 1, (instr("__4"."range1", '-') - 1)) ELSE "__4"."range1" END) AS INTEGER) AS "l1",
    CAST((CASE WHEN (instr("__4"."range2", '-') > 0) THEN substr("__4"."range2", 1, (instr("__4"."range2", '-') - 1)) ELSE "__4"."range2" END) AS INTEGER) AS "l2",
    CAST((CASE WHEN (instr("__4"."range1", '-') > 0) THEN substr("__4"."range1", (instr("__4"."range1", '-') + 1)) ELSE '' END) AS INTEGER) AS "r1",
    CAST((CASE WHEN (instr("__4"."range2", '-') > 0) THEN substr("__4"."range2", (instr("__4"."range2", '-') + 1)) ELSE '' END) AS INTEGER) AS "r2"
  FROM (
    SELECT
      (CASE WHEN (instr("__3"."line", ',') > 0) THEN substr("__3"."line", 1, (instr("__3"."line", ',') - 1)) ELSE "__3"."line" END) AS "range1",
      (CASE WHEN (instr("__3"."line", ',') > 0) THEN substr("__3"."line", (instr("__3"."line", ',') + 1)) ELSE '' END) AS "range2"
    FROM "__1" AS "__3"
  ) AS "__4"
)
SELECT
  "assignments_3"."part1",
  "assignments_5"."part2"
FROM (
  SELECT count(*) AS "part1"
  FROM "assignments_1" AS "assignments_2"
  WHERE
    (("assignments_2"."l1" >= "assignments_2"."l2") AND ("assignments_2"."r1" <= "assignments_2"."r2")) OR
    (("assignments_2"."l2" >= "assignments_2"."l1") AND ("assignments_2"."r2" <= "assignments_2"."r1"))
) AS "assignments_3"
CROSS JOIN (
  SELECT count(*) AS "part2"
  FROM "assignments_1" AS "assignments_4"
  WHERE (max("assignments_4"."l1", "assignments_4"."l2") <= min("assignments_4"."r1", "assignments_4"."r2"))
) AS "assignments_5"
