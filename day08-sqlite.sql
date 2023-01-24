WITH RECURSIVE "__1" ("row", "line", "rest") AS (
  SELECT
    (0 + 1) AS "row",
    (CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, 1, (instr(?1, '
') - 1)) ELSE ?1 END) AS "line",
    (CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, (instr(?1, '
') + 1)) ELSE '' END) AS "rest"
  WHERE (?1 <> '')
  UNION ALL
  SELECT
    ("__2"."row" + 1) AS "row",
    (CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", 1, (instr("__2"."rest", '
') - 1)) ELSE "__2"."rest" END) AS "line",
    (CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", (instr("__2"."rest", '
') + 1)) ELSE '' END) AS "rest"
  FROM "__1" AS "__2"
  WHERE ("__2"."rest" <> '')
),
"__4" ("height", "col", "row", "rest") AS (
  SELECT
    CAST(substr("__3"."line", 1, 1) AS INTEGER) AS "height",
    (0 + 1) AS "col",
    "__3"."row",
    substr("__3"."line", 2) AS "rest"
  FROM "__1" AS "__3"
  WHERE ("__3"."line" <> '')
  UNION ALL
  SELECT
    CAST(substr("__5"."rest", 1, 1) AS INTEGER) AS "height",
    ("__5"."col" + 1) AS "col",
    "__5"."row",
    substr("__5"."rest", 2) AS "rest"
  FROM "__4" AS "__5"
  WHERE ("__5"."rest" <> '')
),
"heights_1" ("height", "col", "row") AS (
  SELECT
    "__6"."height",
    "__6"."col",
    "__6"."row"
  FROM "__4" AS "__6"
)
SELECT
  "heights_7"."part1",
  "heights_13"."part2"
FROM (
  SELECT count(*) AS "part1"
  FROM (
    SELECT
      "heights_5"."height",
      "heights_5"."up",
      "heights_5"."down",
      "heights_5"."left",
      coalesce((max("heights_5"."height") OVER (PARTITION BY "heights_5"."row" ORDER BY (- "heights_5"."col") ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)), -1) AS "right"
    FROM (
      SELECT
        "heights_4"."height",
        "heights_4"."up",
        "heights_4"."down",
        coalesce((max("heights_4"."height") OVER (PARTITION BY "heights_4"."row" ORDER BY "heights_4"."col" ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)), -1) AS "left",
        "heights_4"."row",
        "heights_4"."col"
      FROM (
        SELECT
          "heights_3"."height",
          "heights_3"."up",
          coalesce((max("heights_3"."height") OVER (PARTITION BY "heights_3"."col" ORDER BY (- "heights_3"."row") ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)), -1) AS "down",
          "heights_3"."row",
          "heights_3"."col"
        FROM (
          SELECT
            "heights_2"."height",
            coalesce((max("heights_2"."height") OVER (PARTITION BY "heights_2"."col" ORDER BY "heights_2"."row" ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)), -1) AS "up",
            "heights_2"."row",
            "heights_2"."col"
          FROM "heights_1" AS "heights_2"
        ) AS "heights_3"
      ) AS "heights_4"
    ) AS "heights_5"
  ) AS "heights_6"
  WHERE
    ("heights_6"."height" > "heights_6"."up") OR
    ("heights_6"."height" > "heights_6"."down") OR
    ("heights_6"."height" > "heights_6"."left") OR
    ("heights_6"."height" > "heights_6"."right")
) AS "heights_7"
CROSS JOIN (
  SELECT max(("heights_12"."up" * "heights_12"."down" * "heights_12"."left" * "heights_12"."right")) AS "part2"
  FROM (
    SELECT
      "heights_11"."up",
      "heights_11"."down",
      "heights_11"."left",
      coalesce(((- "heights_11"."col") - coalesce((max((- "heights_11"."col")) FILTER (WHERE ("heights_11"."height" >= "heights_11"."threshold")) OVER (PARTITION BY "heights_11"."threshold", "heights_11"."row" ORDER BY (- "heights_11"."col") ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)), (min((- "heights_11"."col")) OVER (PARTITION BY "heights_11"."threshold", "heights_11"."row" ORDER BY (- "heights_11"."col") ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)))), 0) AS "right",
      "heights_11"."height",
      "heights_11"."threshold"
    FROM (
      SELECT
        "heights_10"."up",
        "heights_10"."down",
        coalesce(("heights_10"."col" - coalesce((max("heights_10"."col") FILTER (WHERE ("heights_10"."height" >= "heights_10"."threshold")) OVER (PARTITION BY "heights_10"."threshold", "heights_10"."row" ORDER BY "heights_10"."col" ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)), (min("heights_10"."col") OVER (PARTITION BY "heights_10"."threshold", "heights_10"."row" ORDER BY "heights_10"."col" ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)))), 0) AS "left",
        "heights_10"."height",
        "heights_10"."threshold",
        "heights_10"."col",
        "heights_10"."row"
      FROM (
        SELECT
          "heights_9"."up",
          coalesce(((- "heights_9"."row") - coalesce((max((- "heights_9"."row")) FILTER (WHERE ("heights_9"."height" >= "heights_9"."threshold")) OVER (PARTITION BY "heights_9"."threshold", "heights_9"."col" ORDER BY (- "heights_9"."row") ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)), (min((- "heights_9"."row")) OVER (PARTITION BY "heights_9"."threshold", "heights_9"."col" ORDER BY (- "heights_9"."row") ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)))), 0) AS "down",
          "heights_9"."height",
          "heights_9"."threshold",
          "heights_9"."col",
          "heights_9"."row"
        FROM (
          SELECT
            coalesce(("heights_8"."row" - coalesce((max("heights_8"."row") FILTER (WHERE ("heights_8"."height" >= "values_2"."threshold")) OVER (PARTITION BY "values_2"."threshold", "heights_8"."col" ORDER BY "heights_8"."row" ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)), (min("heights_8"."row") OVER (PARTITION BY "values_2"."threshold", "heights_8"."col" ORDER BY "heights_8"."row" ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)))), 0) AS "up",
            "heights_8"."height",
            "values_2"."threshold",
            "heights_8"."col",
            "heights_8"."row"
          FROM "heights_1" AS "heights_8"
          CROSS JOIN (
            SELECT "values_1"."column1" AS "threshold"
            FROM (
              VALUES
                (0),
                (1),
                (2),
                (3),
                (4),
                (5),
                (6),
                (7),
                (8),
                (9)
            ) AS "values_1"
          ) AS "values_2"
        ) AS "heights_9"
      ) AS "heights_10"
    ) AS "heights_11"
  ) AS "heights_12"
  WHERE ("heights_12"."height" = "heights_12"."threshold")
) AS "heights_13"
