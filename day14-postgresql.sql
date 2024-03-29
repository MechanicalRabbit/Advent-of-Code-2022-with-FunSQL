WITH RECURSIVE "segments_1" ("x1", "x2", "y1", "y2") AS (
  SELECT
    least("__4"."x", "__4"."lag") AS "x1",
    greatest("__4"."x", "__4"."lag") AS "x2",
    least("__4"."y", "__4"."lag_2") AS "y1",
    greatest("__4"."y", "__4"."lag_2") AS "y2"
  FROM (
    SELECT
      "__3"."x",
      "__3"."y",
      (lag("__3"."x") OVER (PARTITION BY "__3"."path_index" ORDER BY "__3"."point_index")) AS "lag",
      (lag("__3"."y") OVER (PARTITION BY "__3"."path_index" ORDER BY "__3"."point_index")) AS "lag_2",
      "__3"."point_index"
    FROM (
      SELECT
        ("__2"."captures"[1]::integer) AS "x",
        ("__2"."captures"[2]::integer) AS "y",
        "__2"."point_index",
        "__1"."path_index"
      FROM string_to_table($1, '
') WITH ORDINALITY AS "__1" ("path", "path_index")
      CROSS JOIN regexp_matches("__1"."path", '(\d+),(\d+)', 'g') WITH ORDINALITY AS "__2" ("captures", "point_index")
    ) AS "__3"
  ) AS "__4"
  WHERE ("__4"."point_index" > 1)
),
"max_y_1" ("max_y") AS (
  SELECT (max("segments_2"."y2") + 1) AS "max_y"
  FROM "segments_1" AS "segments_2"
),
"__5" ("x", "y") AS (
  SELECT
    500 AS "x",
    0 AS "y"
  UNION ALL
  SELECT
    "__8"."x",
    "__8"."y"
  FROM (
    SELECT DISTINCT
      ("__7"."x" + "values_2"."dx") AS "x",
      ("__7"."y" + 1) AS "y"
    FROM (
      SELECT
        "__6"."x",
        "__6"."y"
      FROM "__5" AS "__6"
      CROSS JOIN "max_y_1" AS "max_y_2"
      WHERE ("__6"."y" < "max_y_2"."max_y")
    ) AS "__7"
    CROSS JOIN (
      SELECT "values_1"."dx"
      FROM (
        VALUES
          (-1),
          (0),
          (1)
      ) AS "values_1" ("dx")
    ) AS "values_2"
  ) AS "__8"
  WHERE (NOT (EXISTS (
    SELECT NULL AS "_"
    FROM "segments_1" AS "segments_3"
    WHERE
      ("__8"."x" BETWEEN "segments_3"."x1" AND "segments_3"."x2") AND
      ("__8"."y" BETWEEN "segments_3"."y1" AND "segments_3"."y2")
  )))
),
"reachable_1" ("x", "y") AS (
  SELECT
    "__9"."x",
    "__9"."y"
  FROM "__5" AS "__9"
),
"__10" ("x", "y") AS (
  SELECT
    "reachable_2"."x",
    "reachable_2"."y"
  FROM "reachable_1" AS "reachable_2"
  CROSS JOIN "max_y_1" AS "max_y_3"
  WHERE ("reachable_2"."y" = "max_y_3"."max_y")
  UNION ALL
  SELECT
    "__12"."x",
    "__12"."y"
  FROM (
    SELECT DISTINCT
      ("__11"."x" + "values_4"."dx") AS "x",
      ("__11"."y" - 1) AS "y"
    FROM "__10" AS "__11"
    CROSS JOIN (
      SELECT "values_3"."dx"
      FROM (
        VALUES
          (-1),
          (0),
          (1)
      ) AS "values_3" ("dx")
    ) AS "values_4"
  ) AS "__12"
  WHERE (EXISTS (
    SELECT NULL AS "_"
    FROM "reachable_1" AS "reachable_3"
    WHERE
      ("reachable_3"."x" = "__12"."x") AND
      ("reachable_3"."y" = "__12"."y")
  ))
),
"fallthrough_1" ("x", "y") AS (
  SELECT
    "__13"."x",
    "__13"."y"
  FROM "__10" AS "__13"
),
"__14" ("x", "y") AS (
  SELECT
    500 AS "x",
    0 AS "y"
  UNION ALL
  SELECT
    "__17"."x",
    "__17"."y"
  FROM (
    SELECT DISTINCT
      "__16"."x",
      "__16"."y"
    FROM (
      SELECT
        ("__15"."x" + "values_6"."dx") AS "x",
        ("__15"."y" + 1) AS "y",
        "values_6"."dx",
        (NOT (EXISTS (
          SELECT NULL AS "_"
          FROM "fallthrough_1" AS "fallthrough_2"
          WHERE
            ("fallthrough_2"."x" = "__15"."x") AND
            ("fallthrough_2"."y" = ("__15"."y" + 1))
        ))) AS "down_rest",
        (NOT (EXISTS (
          SELECT NULL AS "_"
          FROM "fallthrough_1" AS "fallthrough_3"
          WHERE
            ("fallthrough_3"."x" = ("__15"."x" - 1)) AND
            ("fallthrough_3"."y" = ("__15"."y" + 1))
        ))) AS "down_left_rest"
      FROM "__14" AS "__15"
      CROSS JOIN (
        SELECT "values_5"."dx"
        FROM (
          VALUES
            (-1),
            (0),
            (1)
        ) AS "values_5" ("dx")
      ) AS "values_6"
    ) AS "__16"
    WHERE
      ("__16"."dx" = 0) OR
      (("__16"."dx" = -1) AND "__16"."down_rest") OR
      (("__16"."dx" = 1) AND "__16"."down_rest" AND "__16"."down_left_rest")
  ) AS "__17"
  WHERE (EXISTS (
    SELECT NULL AS "_"
    FROM "reachable_1" AS "reachable_4"
    WHERE
      ("reachable_4"."x" = "__17"."x") AND
      ("reachable_4"."y" = "__17"."y")
  ))
)
SELECT
  "__19"."part1",
  "reachable_6"."part2"
FROM (
  SELECT count(*) AS "part1"
  FROM "__14" AS "__18"
  WHERE (NOT (EXISTS (
    SELECT NULL AS "_"
    FROM "fallthrough_1" AS "fallthrough_4"
    WHERE
      ("fallthrough_4"."x" = "__18"."x") AND
      ("fallthrough_4"."y" = "__18"."y")
  )))
) AS "__19"
CROSS JOIN (
  SELECT count(*) AS "part2"
  FROM "reachable_1" AS "reachable_5"
) AS "reachable_6"
