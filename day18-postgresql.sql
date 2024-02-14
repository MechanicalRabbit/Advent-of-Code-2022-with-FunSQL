WITH RECURSIVE "cubes_1" ("x", "y", "z") AS (
  SELECT
    ("regexp_matches_1"."captures"[1]::integer) AS "x",
    ("regexp_matches_1"."captures"[2]::integer) AS "y",
    ("regexp_matches_1"."captures"[3]::integer) AS "z"
  FROM regexp_matches($1, '(\d+),(\d+),(\d+)', 'g') AS "regexp_matches_1" ("captures")
),
"bounds_1" ("min_x", "max_x", "min_y", "max_y", "min_z", "max_z") AS (
  SELECT
    (min("cubes_2"."x") - 1) AS "min_x",
    (max("cubes_2"."x") + 1) AS "max_x",
    (min("cubes_2"."y") - 1) AS "min_y",
    (max("cubes_2"."y") + 1) AS "max_y",
    (min("cubes_2"."z") - 1) AS "min_z",
    (max("cubes_2"."z") + 1) AS "max_z"
  FROM "cubes_1" AS "cubes_2"
),
"__1" ("x", "y", "z", "fresh") AS (
  SELECT
    "bounds_2"."min_x" AS "x",
    "bounds_2"."min_y" AS "y",
    "bounds_2"."min_z" AS "z",
    TRUE AS "fresh"
  FROM "bounds_1" AS "bounds_2"
  UNION ALL
  SELECT
    "__6"."x",
    "__6"."y",
    "__6"."z",
    "__6"."fresh"
  FROM (
    SELECT
      "__5"."x",
      "__5"."y",
      "__5"."z",
      bool_and("__5"."fresh") AS "fresh"
    FROM (
      SELECT
        ("__4"."x" + "values_2"."dx") AS "x",
        ("__4"."y" + "values_2"."dy") AS "y",
        ("__4"."z" + "values_2"."dz") AS "z",
        (("values_2"."dx" <> 0) OR ("values_2"."dy" <> 0) OR ("values_2"."dz" <> 0)) AS "fresh"
      FROM (
        SELECT
          "__3"."x",
          "__3"."y",
          "__3"."z"
        FROM (
          SELECT
            "__2"."x",
            "__2"."y",
            "__2"."z",
            (bool_or("__2"."fresh") OVER ()) AS "bool_or"
          FROM "__1" AS "__2"
        ) AS "__3"
        WHERE "__3"."bool_or"
      ) AS "__4"
      CROSS JOIN (
        SELECT
          "values_1"."dx",
          "values_1"."dy",
          "values_1"."dz"
        FROM (
          VALUES
            (0, 0, 0),
            (1, 0, 0),
            (-1, 0, 0),
            (0, 1, 0),
            (0, -1, 0),
            (0, 0, 1),
            (0, 0, -1)
        ) AS "values_1" ("dx", "dy", "dz")
      ) AS "values_2"
    ) AS "__5"
    GROUP BY
      "__5"."x",
      "__5"."y",
      "__5"."z"
  ) AS "__6"
  CROSS JOIN "bounds_1" AS "bounds_3"
  WHERE
    ("__6"."x" BETWEEN "bounds_3"."min_x" AND "bounds_3"."max_x") AND
    ("__6"."y" BETWEEN "bounds_3"."min_y" AND "bounds_3"."max_y") AND
    ("__6"."z" BETWEEN "bounds_3"."min_z" AND "bounds_3"."max_z") AND
    (NOT EXISTS (
      SELECT NULL AS "_"
      FROM "cubes_1" AS "cubes_7"
      WHERE
        ("cubes_7"."x" = "__6"."x") AND
        ("cubes_7"."y" = "__6"."y") AND
        ("cubes_7"."z" = "__6"."z")
    ))
)
SELECT
  ((6 * "cubes_4"."count") - (2 * "pairs_1"."count")) AS "part1",
  "__9"."part2"
FROM (
  SELECT count(*) AS "count"
  FROM "cubes_1" AS "cubes_3"
) AS "cubes_4"
CROSS JOIN (
  SELECT count(*) AS "count"
  FROM "cubes_1" AS "cubes_5"
  JOIN "cubes_1" AS "cubes_6" ON (((("cubes_5"."x" + 1) = "cubes_6"."x") AND ("cubes_5"."y" = "cubes_6"."y") AND ("cubes_5"."z" = "cubes_6"."z")) OR (("cubes_5"."x" = "cubes_6"."x") AND (("cubes_5"."y" + 1) = "cubes_6"."y") AND ("cubes_5"."z" = "cubes_6"."z")) OR (("cubes_5"."x" = "cubes_6"."x") AND ("cubes_5"."y" = "cubes_6"."y") AND (("cubes_5"."z" + 1) = "cubes_6"."z")))
) AS "pairs_1"
CROSS JOIN (
  SELECT count(*) AS "part2"
  FROM (
    SELECT DISTINCT
      "__7"."x" AS "fill_x",
      "__7"."y" AS "fill_y",
      "__7"."z" AS "fill_z"
    FROM "__1" AS "__7"
  ) AS "__8"
  CROSS JOIN (
    SELECT
      "values_3"."dx",
      "values_3"."dy",
      "values_3"."dz"
    FROM (
      VALUES
        (1, 0, 0),
        (-1, 0, 0),
        (0, 1, 0),
        (0, -1, 0),
        (0, 0, 1),
        (0, 0, -1)
    ) AS "values_3" ("dx", "dy", "dz")
  ) AS "values_4"
  JOIN "cubes_1" AS "cubes_8" ON (("cubes_8"."x" = ("__8"."fill_x" + "values_4"."dx")) AND ("cubes_8"."y" = ("__8"."fill_y" + "values_4"."dy")) AND ("cubes_8"."z" = ("__8"."fill_z" + "values_4"."dz")))
) AS "__9"
