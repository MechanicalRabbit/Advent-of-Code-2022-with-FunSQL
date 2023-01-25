WITH RECURSIVE "heights_1" ("col", "row", "finish", "height", "start") AS (
  SELECT
    "__2"."col",
    "__1"."row",
    ("__2"."char" = 'E') AS "finish",
    (ascii((CASE WHEN ("__2"."char" = 'S') THEN 'a' WHEN ("__2"."char" = 'E') THEN 'z' ELSE "__2"."char" END)) - ascii('a')) AS "height",
    ("__2"."char" = 'S') AS "start"
  FROM string_to_table($1, '
') WITH ORDINALITY AS "__1" ("line", "row")
  CROSS JOIN string_to_table("__1"."line", NULL) WITH ORDINALITY AS "__2" ("char", "col")
),
"__3" ("dist", "col", "row", "finish", "height") AS (
  SELECT
    (CASE WHEN "heights_2"."start" THEN 0 END) AS "dist",
    "heights_2"."col",
    "heights_2"."row",
    "heights_2"."finish",
    "heights_2"."height"
  FROM "heights_1" AS "heights_2"
  UNION ALL
  SELECT
    least("heights_5"."dist", "heights_5"."left", "heights_5"."right", (CASE WHEN ("heights_5"."height" <= ((lag("heights_5"."height") OVER (PARTITION BY "heights_5"."col" ORDER BY "heights_5"."row")) + 1)) THEN ((lag("heights_5"."dist") OVER (PARTITION BY "heights_5"."col" ORDER BY "heights_5"."row")) + 1) END), (CASE WHEN ("heights_5"."height" <= ((lead("heights_5"."height") OVER (PARTITION BY "heights_5"."col" ORDER BY "heights_5"."row")) + 1)) THEN ((lead("heights_5"."dist") OVER (PARTITION BY "heights_5"."col" ORDER BY "heights_5"."row")) + 1) END)) AS "dist",
    "heights_5"."col",
    "heights_5"."row",
    "heights_5"."finish",
    "heights_5"."height"
  FROM (
    SELECT
      "heights_4"."col",
      "heights_4"."row",
      "heights_4"."finish",
      "heights_4"."height",
      "heights_4"."dist",
      (CASE WHEN ("heights_4"."height" <= ((lag("heights_4"."height") OVER (PARTITION BY "heights_4"."row" ORDER BY "heights_4"."col")) + 1)) THEN ((lag("heights_4"."dist") OVER (PARTITION BY "heights_4"."row" ORDER BY "heights_4"."col")) + 1) END) AS "left",
      (CASE WHEN ("heights_4"."height" <= ((lead("heights_4"."height") OVER (PARTITION BY "heights_4"."row" ORDER BY "heights_4"."col")) + 1)) THEN ((lead("heights_4"."dist") OVER (PARTITION BY "heights_4"."row" ORDER BY "heights_4"."col")) + 1) END) AS "right"
    FROM (
      SELECT
        "heights_3"."col",
        "heights_3"."row",
        "heights_3"."finish",
        "heights_3"."height",
        "heights_3"."dist",
        (min("heights_3"."dist") FILTER (WHERE "heights_3"."finish") OVER ()) AS "min"
      FROM "__3" AS "heights_3"
    ) AS "heights_4"
    WHERE ("heights_4"."min" IS NULL)
  ) AS "heights_5"
),
"__5" ("dist", "col", "row", "finish", "height") AS (
  SELECT
    (CASE WHEN ("heights_7"."height" = 0) THEN 0 END) AS "dist",
    "heights_7"."col",
    "heights_7"."row",
    "heights_7"."finish",
    "heights_7"."height"
  FROM "heights_1" AS "heights_7"
  UNION ALL
  SELECT
    least("heights_10"."dist", "heights_10"."left", "heights_10"."right", (CASE WHEN ("heights_10"."height" <= ((lag("heights_10"."height") OVER (PARTITION BY "heights_10"."col" ORDER BY "heights_10"."row")) + 1)) THEN ((lag("heights_10"."dist") OVER (PARTITION BY "heights_10"."col" ORDER BY "heights_10"."row")) + 1) END), (CASE WHEN ("heights_10"."height" <= ((lead("heights_10"."height") OVER (PARTITION BY "heights_10"."col" ORDER BY "heights_10"."row")) + 1)) THEN ((lead("heights_10"."dist") OVER (PARTITION BY "heights_10"."col" ORDER BY "heights_10"."row")) + 1) END)) AS "dist",
    "heights_10"."col",
    "heights_10"."row",
    "heights_10"."finish",
    "heights_10"."height"
  FROM (
    SELECT
      "heights_9"."col",
      "heights_9"."row",
      "heights_9"."finish",
      "heights_9"."height",
      "heights_9"."dist",
      (CASE WHEN ("heights_9"."height" <= ((lag("heights_9"."height") OVER (PARTITION BY "heights_9"."row" ORDER BY "heights_9"."col")) + 1)) THEN ((lag("heights_9"."dist") OVER (PARTITION BY "heights_9"."row" ORDER BY "heights_9"."col")) + 1) END) AS "left",
      (CASE WHEN ("heights_9"."height" <= ((lead("heights_9"."height") OVER (PARTITION BY "heights_9"."row" ORDER BY "heights_9"."col")) + 1)) THEN ((lead("heights_9"."dist") OVER (PARTITION BY "heights_9"."row" ORDER BY "heights_9"."col")) + 1) END) AS "right"
    FROM (
      SELECT
        "heights_8"."col",
        "heights_8"."row",
        "heights_8"."finish",
        "heights_8"."height",
        "heights_8"."dist",
        (min("heights_8"."dist") FILTER (WHERE "heights_8"."finish") OVER ()) AS "min"
      FROM "__5" AS "heights_8"
    ) AS "heights_9"
    WHERE ("heights_9"."min" IS NULL)
  ) AS "heights_10"
)
SELECT
  "heights_6"."part1",
  "heights_11"."part2"
FROM (
  SELECT max("__4"."dist") AS "part1"
  FROM "__3" AS "__4"
) AS "heights_6"
CROSS JOIN (
  SELECT max("__6"."dist") AS "part2"
  FROM "__5" AS "__6"
) AS "heights_11"
