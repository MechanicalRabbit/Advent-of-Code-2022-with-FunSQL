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
    "bounds_7"."x",
    "bounds_7"."y",
    "bounds_7"."z",
    "bounds_7"."fresh"
  FROM (
    SELECT
      "bounds_6"."x",
      "bounds_6"."y",
      "bounds_6"."z",
      bool_and("bounds_6"."fresh") AS "fresh"
    FROM (
      SELECT
        ("bounds_5"."x" + "values_2"."dx") AS "x",
        ("bounds_5"."y" + "values_2"."dy") AS "y",
        ("bounds_5"."z" + "values_2"."dz") AS "z",
        (("values_2"."dx" <> 0) OR ("values_2"."dy" <> 0) OR ("values_2"."dz" <> 0)) AS "fresh"
      FROM (
        SELECT
          "bounds_4"."x",
          "bounds_4"."y",
          "bounds_4"."z"
        FROM (
          SELECT
            "bounds_3"."x",
            "bounds_3"."y",
            "bounds_3"."z",
            (bool_or("bounds_3"."fresh") OVER ()) AS "bool_or"
          FROM "__1" AS "bounds_3"
        ) AS "bounds_4"
        WHERE "bounds_4"."bool_or"
      ) AS "bounds_5"
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
    ) AS "bounds_6"
    GROUP BY
      "bounds_6"."x",
      "bounds_6"."y",
      "bounds_6"."z"
  ) AS "bounds_7"
  CROSS JOIN "bounds_1" AS "bounds_8"
  WHERE
    ("bounds_7"."x" BETWEEN "bounds_8"."min_x" AND "bounds_8"."max_x") AND
    ("bounds_7"."y" BETWEEN "bounds_8"."min_y" AND "bounds_8"."max_y") AND
    ("bounds_7"."z" BETWEEN "bounds_8"."min_z" AND "bounds_8"."max_z") AND
    (NOT EXISTS (
      SELECT NULL
      FROM "cubes_1" AS "cubes_7"
      WHERE
        ("cubes_7"."x" = "bounds_7"."x") AND
        ("cubes_7"."y" = "bounds_7"."y") AND
        ("cubes_7"."z" = "bounds_7"."z")
    ))
)
SELECT
  ((6 * "cubes_4"."count") - (2 * "pairs_1"."count")) AS "part1",
  "bounds_10"."part2"
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
      "__2"."x" AS "fill_x",
      "__2"."y" AS "fill_y",
      "__2"."z" AS "fill_z"
    FROM "__1" AS "__2"
  ) AS "bounds_9"
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
  JOIN "cubes_1" AS "cubes_8" ON (("cubes_8"."x" = ("bounds_9"."fill_x" + "values_4"."dx")) AND ("cubes_8"."y" = ("bounds_9"."fill_y" + "values_4"."dy")) AND ("cubes_8"."z" = ("bounds_9"."fill_z" + "values_4"."dz")))
) AS "bounds_10"
