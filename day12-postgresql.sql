WITH RECURSIVE "heights_1" ("height", "col", "row", "finish", "start") AS (
  SELECT
    (ascii((CASE WHEN ("__2"."char" = 'S') THEN 'a' WHEN ("__2"."char" = 'E') THEN 'z' ELSE "__2"."char" END)) - ascii('a')) AS "height",
    "__2"."col",
    "__1"."row",
    ("__2"."char" = 'E') AS "finish",
    ("__2"."char" = 'S') AS "start"
  FROM string_to_table($1, '
') WITH ORDINALITY AS "__1" ("line", "row")
  CROSS JOIN string_to_table("__1"."line", NULL) WITH ORDINALITY AS "__2" ("char", "col")
),
"__3" ("dist", "height", "col", "row", "finish") AS (
  SELECT
    (CASE WHEN "heights_2"."start" THEN 0 END) AS "dist",
    "heights_2"."height",
    "heights_2"."col",
    "heights_2"."row",
    "heights_2"."finish"
  FROM "heights_1" AS "heights_2"
  UNION ALL
  SELECT
    least("__6"."dist", "__6"."left", "__6"."right", (CASE WHEN ("__6"."height" <= ((lag("__6"."height") OVER (PARTITION BY "__6"."col" ORDER BY "__6"."row")) + 1)) THEN ((lag("__6"."dist") OVER (PARTITION BY "__6"."col" ORDER BY "__6"."row")) + 1) END), (CASE WHEN ("__6"."height" <= ((lead("__6"."height") OVER (PARTITION BY "__6"."col" ORDER BY "__6"."row")) + 1)) THEN ((lead("__6"."dist") OVER (PARTITION BY "__6"."col" ORDER BY "__6"."row")) + 1) END)) AS "dist",
    "__6"."height",
    "__6"."col",
    "__6"."row",
    "__6"."finish"
  FROM (
    SELECT
      "__5"."height",
      "__5"."col",
      "__5"."row",
      "__5"."finish",
      "__5"."dist",
      (CASE WHEN ("__5"."height" <= ((lag("__5"."height") OVER (PARTITION BY "__5"."row" ORDER BY "__5"."col")) + 1)) THEN ((lag("__5"."dist") OVER (PARTITION BY "__5"."row" ORDER BY "__5"."col")) + 1) END) AS "left",
      (CASE WHEN ("__5"."height" <= ((lead("__5"."height") OVER (PARTITION BY "__5"."row" ORDER BY "__5"."col")) + 1)) THEN ((lead("__5"."dist") OVER (PARTITION BY "__5"."row" ORDER BY "__5"."col")) + 1) END) AS "right"
    FROM (
      SELECT
        "__4"."height",
        "__4"."col",
        "__4"."row",
        "__4"."finish",
        "__4"."dist",
        (min("__4"."dist") FILTER (WHERE "__4"."finish") OVER ()) AS "min"
      FROM "__3" AS "__4"
    ) AS "__5"
    WHERE ("__5"."min" IS NULL)
  ) AS "__6"
),
"__9" ("dist", "height", "col", "row", "finish") AS (
  SELECT
    (CASE WHEN ("heights_3"."height" = 0) THEN 0 END) AS "dist",
    "heights_3"."height",
    "heights_3"."col",
    "heights_3"."row",
    "heights_3"."finish"
  FROM "heights_1" AS "heights_3"
  UNION ALL
  SELECT
    least("__12"."dist", "__12"."left", "__12"."right", (CASE WHEN ("__12"."height" <= ((lag("__12"."height") OVER (PARTITION BY "__12"."col" ORDER BY "__12"."row")) + 1)) THEN ((lag("__12"."dist") OVER (PARTITION BY "__12"."col" ORDER BY "__12"."row")) + 1) END), (CASE WHEN ("__12"."height" <= ((lead("__12"."height") OVER (PARTITION BY "__12"."col" ORDER BY "__12"."row")) + 1)) THEN ((lead("__12"."dist") OVER (PARTITION BY "__12"."col" ORDER BY "__12"."row")) + 1) END)) AS "dist",
    "__12"."height",
    "__12"."col",
    "__12"."row",
    "__12"."finish"
  FROM (
    SELECT
      "__11"."height",
      "__11"."col",
      "__11"."row",
      "__11"."finish",
      "__11"."dist",
      (CASE WHEN ("__11"."height" <= ((lag("__11"."height") OVER (PARTITION BY "__11"."row" ORDER BY "__11"."col")) + 1)) THEN ((lag("__11"."dist") OVER (PARTITION BY "__11"."row" ORDER BY "__11"."col")) + 1) END) AS "left",
      (CASE WHEN ("__11"."height" <= ((lead("__11"."height") OVER (PARTITION BY "__11"."row" ORDER BY "__11"."col")) + 1)) THEN ((lead("__11"."dist") OVER (PARTITION BY "__11"."row" ORDER BY "__11"."col")) + 1) END) AS "right"
    FROM (
      SELECT
        "__10"."height",
        "__10"."col",
        "__10"."row",
        "__10"."finish",
        "__10"."dist",
        (min("__10"."dist") FILTER (WHERE "__10"."finish") OVER ()) AS "min"
      FROM "__9" AS "__10"
    ) AS "__11"
    WHERE ("__11"."min" IS NULL)
  ) AS "__12"
)
SELECT
  "__8"."part1",
  "__14"."part2"
FROM (
  SELECT max("__7"."dist") AS "part1"
  FROM "__3" AS "__7"
) AS "__8"
CROSS JOIN (
  SELECT max("__13"."dist") AS "part2"
  FROM "__9" AS "__13"
) AS "__14"
