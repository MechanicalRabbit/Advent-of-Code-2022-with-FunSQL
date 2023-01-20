WITH RECURSIVE "__1" ("chunk", "index", "rest") AS (
  SELECT
    (CASE WHEN (instr(?1, '

') > 0) THEN substr(?1, 1, (instr(?1, '

') - 1)) ELSE ?1 END) AS "chunk",
    (0 + 1) AS "index",
    (CASE WHEN (instr(?1, '

') > 0) THEN substr(?1, (instr(?1, '

') + 2)) ELSE '' END) AS "rest"
  WHERE (?1 <> '')
  UNION ALL
  SELECT
    (CASE WHEN (instr("__2"."rest", '

') > 0) THEN substr("__2"."rest", 1, (instr("__2"."rest", '

') - 1)) ELSE "__2"."rest" END) AS "chunk",
    ("__2"."index" + 1) AS "index",
    (CASE WHEN (instr("__2"."rest", '

') > 0) THEN substr("__2"."rest", (instr("__2"."rest", '

') + 2)) ELSE '' END) AS "rest"
  FROM "__1" AS "__2"
  WHERE ("__2"."rest" <> '')
),
"__4" ("elf", "chunk", "rest") AS (
  SELECT
    "__3"."index" AS "elf",
    (CASE WHEN (instr("__3"."chunk", '
') > 0) THEN substr("__3"."chunk", 1, (instr("__3"."chunk", '
') - 1)) ELSE "__3"."chunk" END) AS "chunk",
    (CASE WHEN (instr("__3"."chunk", '
') > 0) THEN substr("__3"."chunk", (instr("__3"."chunk", '
') + 1)) ELSE '' END) AS "rest"
  FROM "__1" AS "__3"
  WHERE ("__3"."chunk" <> '')
  UNION ALL
  SELECT
    "__5"."elf",
    (CASE WHEN (instr("__5"."rest", '
') > 0) THEN substr("__5"."rest", 1, (instr("__5"."rest", '
') - 1)) ELSE "__5"."rest" END) AS "chunk",
    (CASE WHEN (instr("__5"."rest", '
') > 0) THEN substr("__5"."rest", (instr("__5"."rest", '
') + 1)) ELSE '' END) AS "rest"
  FROM "__4" AS "__5"
  WHERE ("__5"."rest" <> '')
),
"inventories_1" ("elf", "calories") AS (
  SELECT
    "__6"."elf",
    CAST("__6"."chunk" AS INTEGER) AS "calories"
  FROM "__4" AS "__6"
)
SELECT
  "inventories_4"."part1",
  "inventories_8"."part2"
FROM (
  SELECT max("inventories_3"."sum") AS "part1"
  FROM (
    SELECT sum("inventories_2"."calories") AS "sum"
    FROM "inventories_1" AS "inventories_2"
    GROUP BY "inventories_2"."elf"
  ) AS "inventories_3"
) AS "inventories_4"
CROSS JOIN (
  SELECT sum("inventories_7"."total") AS "part2"
  FROM (
    SELECT "inventories_6"."total"
    FROM (
      SELECT sum("inventories_5"."calories") AS "total"
      FROM "inventories_1" AS "inventories_5"
      GROUP BY "inventories_5"."elf"
    ) AS "inventories_6"
    ORDER BY "inventories_6"."total" DESC
    LIMIT 3
  ) AS "inventories_7"
) AS "inventories_8"
