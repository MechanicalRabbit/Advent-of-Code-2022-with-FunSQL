WITH RECURSIVE "__1" ("index", "line", "rest") AS (
  SELECT
    (0 + 1) AS "index",
    (CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, 1, (instr(?1, '
') - 1)) ELSE ?1 END) AS "line",
    (CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, (instr(?1, '
') + 1)) ELSE '' END) AS "rest"
  WHERE (?1 <> '')
  UNION ALL
  SELECT
    ("__2"."index" + 1) AS "index",
    (CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", 1, (instr("__2"."rest", '
') - 1)) ELSE "__2"."rest" END) AS "line",
    (CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", (instr("__2"."rest", '
') + 1)) ELSE '' END) AS "rest"
  FROM "__1" AS "__2"
  WHERE ("__2"."rest" <> '')
),
"rucksacks_1" ("index", "line") AS (
  SELECT
    "__3"."index",
    "__3"."line"
  FROM "__1" AS "__3"
),
"characters_1" ("char", "priority") AS (
  SELECT
    "values_1"."column1" AS "char",
    "values_1"."column2" AS "priority"
  FROM (
    VALUES
      ('a', 1),
      ('b', 2),
      ('c', 3),
      ('d', 4),
      ('e', 5),
      ('f', 6),
      ('g', 7),
      ('h', 8),
      ('i', 9),
      ('j', 10),
      ('k', 11),
      ('l', 12),
      ('m', 13),
      ('n', 14),
      ('o', 15),
      ('p', 16),
      ('q', 17),
      ('r', 18),
      ('s', 19),
      ('t', 20),
      ('u', 21),
      ('v', 22),
      ('w', 23),
      ('x', 24),
      ('y', 25),
      ('z', 26),
      ('A', 27),
      ('B', 28),
      ('C', 29),
      ('D', 30),
      ('E', 31),
      ('F', 32),
      ('G', 33),
      ('H', 34),
      ('I', 35),
      ('J', 36),
      ('K', 37),
      ('L', 38),
      ('M', 39),
      ('N', 40),
      ('O', 41),
      ('P', 42),
      ('Q', 43),
      ('R', 44),
      ('S', 45),
      ('T', 46),
      ('U', 47),
      ('V', 48),
      ('W', 49),
      ('X', 50),
      ('Y', 51),
      ('Z', 52)
  ) AS "values_1"
)
SELECT
  "rucksacks_3"."part1",
  "rucksacks_7"."part2"
FROM (
  SELECT sum("characters_2"."priority") AS "part1"
  FROM "rucksacks_1" AS "rucksacks_2"
  JOIN "characters_1" AS "characters_2" ON (instr(substr("rucksacks_2"."line", 1, (length("rucksacks_2"."line") / 2)), "characters_2"."char") AND instr(substr("rucksacks_2"."line", (1 + (length("rucksacks_2"."line") / 2))), "characters_2"."char"))
) AS "rucksacks_3"
CROSS JOIN (
  SELECT sum("characters_3"."priority") AS "part2"
  FROM (
    SELECT
      "rucksacks_5"."line1",
      "rucksacks_5"."line2",
      "rucksacks_5"."line3"
    FROM (
      SELECT
        (lag("rucksacks_4"."line", 2) OVER (ORDER BY "rucksacks_4"."index")) AS "line1",
        (lag("rucksacks_4"."line", 1) OVER (ORDER BY "rucksacks_4"."index")) AS "line2",
        "rucksacks_4"."line" AS "line3",
        "rucksacks_4"."index"
      FROM "rucksacks_1" AS "rucksacks_4"
    ) AS "rucksacks_5"
    WHERE (mod("rucksacks_5"."index", 3) = 0)
  ) AS "rucksacks_6"
  JOIN "characters_1" AS "characters_3" ON (instr("rucksacks_6"."line1", "characters_3"."char") AND instr("rucksacks_6"."line2", "characters_3"."char") AND instr("rucksacks_6"."line3", "characters_3"."char"))
) AS "rucksacks_7"
