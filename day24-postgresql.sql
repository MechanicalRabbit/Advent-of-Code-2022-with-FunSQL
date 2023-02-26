WITH RECURSIVE "map_1" ("x", "y", "char") AS (
  SELECT
    "__2"."x",
    "__1"."y",
    "__2"."char"
  FROM string_to_table($1, '
') WITH ORDINALITY AS "__1" ("line", "y")
  CROSS JOIN string_to_table("__1"."line", NULL) WITH ORDINALITY AS "__2" ("char", "x")
),
"size_1" ("max_x", "max_y") AS (
  SELECT
    max("map_2"."x") AS "max_x",
    max("map_2"."y") AS "max_y"
  FROM "map_1" AS "map_2"
),
"blizzards_1" ("x", "dx", "max_x", "y", "dy", "max_y") AS (
  SELECT
    "map_3"."x",
    (CASE WHEN ("map_3"."char" = '>') THEN 1 WHEN ("map_3"."char" = '<') THEN -1 ELSE 0 END) AS "dx",
    "size_2"."max_x",
    "map_3"."y",
    (CASE WHEN ("map_3"."char" = 'v') THEN 1 WHEN ("map_3"."char" = '^') THEN -1 ELSE 0 END) AS "dy",
    "size_2"."max_y"
  FROM "map_1" AS "map_3"
  CROSS JOIN "size_1" AS "size_2"
  WHERE ("map_3"."char" IN ('>', 'v', '<', '^'))
),
"__3" ("t", "x", "y", "done") AS (
  SELECT
    0 AS "t",
    2 AS "x",
    1 AS "y",
    FALSE AS "done"
  UNION ALL
  SELECT
    "__7"."t",
    "__7"."x",
    "__7"."y",
    (("__7"."x" = ("size_3"."max_x" - 1)) AND ("__7"."y" = "size_3"."max_y")) AS "done"
  FROM (
    SELECT DISTINCT
      ("__6"."t" + 1) AS "t",
      ("__6"."x" + "values_2"."dx") AS "x",
      ("__6"."y" + "values_2"."dy") AS "y"
    FROM (
      SELECT
        "__5"."x",
        "__5"."y",
        "__5"."t"
      FROM (
        SELECT
          "__4"."x",
          "__4"."y",
          "__4"."t",
          (bool_or("__4"."done") OVER ()) AS "bool_or"
        FROM "__3" AS "__4"
      ) AS "__5"
      WHERE (NOT "__5"."bool_or")
    ) AS "__6"
    CROSS JOIN (
      SELECT
        "values_1"."dx",
        "values_1"."dy"
      FROM (
        VALUES
          (0, 0),
          (1, 0),
          (-1, 0),
          (0, 1),
          (0, -1)
      ) AS "values_1" ("dx", "dy")
    ) AS "values_2"
  ) AS "__7"
  CROSS JOIN "size_1" AS "size_3"
  WHERE
    ((("__7"."x" = 2) AND ("__7"."y" = 1)) OR (("__7"."x" = ("size_3"."max_x" - 1)) AND ("__7"."y" = "size_3"."max_y")) OR (("__7"."x" BETWEEN 2 AND ("size_3"."max_x" - 1)) AND ("__7"."y" BETWEEN 2 AND ("size_3"."max_y" - 1)))) AND
    (NOT EXISTS (
      SELECT NULL
      FROM "blizzards_1" AS "blizzards_2"
      WHERE
        ((((((("blizzards_2"."x" + ("blizzards_2"."dx" * "__7"."t")) - 2) % ("blizzards_2"."max_x" - 2)) + ("blizzards_2"."max_x" - 2)) % ("blizzards_2"."max_x" - 2)) + 2) = "__7"."x") AND
        ((((((("blizzards_2"."y" + ("blizzards_2"."dy" * "__7"."t")) - 2) % ("blizzards_2"."max_y" - 2)) + ("blizzards_2"."max_y" - 2)) % ("blizzards_2"."max_y" - 2)) + 2) = "__7"."y")
    ))
),
"__10" ("t", "x", "y", "done") AS (
  SELECT
    0 AS "t",
    2 AS "x",
    1 AS "y",
    FALSE AS "done"
  UNION ALL
  SELECT
    "__14"."t",
    "__14"."x",
    "__14"."y",
    (("__14"."x" = ("size_4"."max_x" - 1)) AND ("__14"."y" = "size_4"."max_y")) AS "done"
  FROM (
    SELECT DISTINCT
      ("__13"."t" + 1) AS "t",
      ("__13"."x" + "values_4"."dx") AS "x",
      ("__13"."y" + "values_4"."dy") AS "y"
    FROM (
      SELECT
        "__12"."x",
        "__12"."y",
        "__12"."t"
      FROM (
        SELECT
          "__11"."x",
          "__11"."y",
          "__11"."t",
          (bool_or("__11"."done") OVER ()) AS "bool_or"
        FROM "__10" AS "__11"
      ) AS "__12"
      WHERE (NOT "__12"."bool_or")
    ) AS "__13"
    CROSS JOIN (
      SELECT
        "values_3"."dx",
        "values_3"."dy"
      FROM (
        VALUES
          (0, 0),
          (1, 0),
          (-1, 0),
          (0, 1),
          (0, -1)
      ) AS "values_3" ("dx", "dy")
    ) AS "values_4"
  ) AS "__14"
  CROSS JOIN "size_1" AS "size_4"
  WHERE
    ((("__14"."x" = 2) AND ("__14"."y" = 1)) OR (("__14"."x" = ("size_4"."max_x" - 1)) AND ("__14"."y" = "size_4"."max_y")) OR (("__14"."x" BETWEEN 2 AND ("size_4"."max_x" - 1)) AND ("__14"."y" BETWEEN 2 AND ("size_4"."max_y" - 1)))) AND
    (NOT EXISTS (
      SELECT NULL
      FROM "blizzards_1" AS "blizzards_3"
      WHERE
        ((((((("blizzards_3"."x" + ("blizzards_3"."dx" * "__14"."t")) - 2) % ("blizzards_3"."max_x" - 2)) + ("blizzards_3"."max_x" - 2)) % ("blizzards_3"."max_x" - 2)) + 2) = "__14"."x") AND
        ((((((("blizzards_3"."y" + ("blizzards_3"."dy" * "__14"."t")) - 2) % ("blizzards_3"."max_y" - 2)) + ("blizzards_3"."max_y" - 2)) % ("blizzards_3"."max_y" - 2)) + 2) = "__14"."y")
    ))
),
"__16" ("t", "x", "y", "done") AS (
  SELECT
    "__15"."t",
    "__15"."x",
    "__15"."y",
    FALSE AS "done"
  FROM "__10" AS "__15"
  WHERE "__15"."done"
  UNION ALL
  SELECT
    "__20"."t",
    "__20"."x",
    "__20"."y",
    (("__20"."x" = 2) AND ("__20"."y" = 1)) AS "done"
  FROM (
    SELECT DISTINCT
      ("__19"."t" + 1) AS "t",
      ("__19"."x" + "values_6"."dx") AS "x",
      ("__19"."y" + "values_6"."dy") AS "y"
    FROM (
      SELECT
        "__18"."x",
        "__18"."y",
        "__18"."t"
      FROM (
        SELECT
          "__17"."x",
          "__17"."y",
          "__17"."t",
          (bool_or("__17"."done") OVER ()) AS "bool_or"
        FROM "__16" AS "__17"
      ) AS "__18"
      WHERE (NOT "__18"."bool_or")
    ) AS "__19"
    CROSS JOIN (
      SELECT
        "values_5"."dx",
        "values_5"."dy"
      FROM (
        VALUES
          (0, 0),
          (1, 0),
          (-1, 0),
          (0, 1),
          (0, -1)
      ) AS "values_5" ("dx", "dy")
    ) AS "values_6"
  ) AS "__20"
  CROSS JOIN "size_1" AS "size_5"
  WHERE
    ((("__20"."x" = 2) AND ("__20"."y" = 1)) OR (("__20"."x" = ("size_5"."max_x" - 1)) AND ("__20"."y" = "size_5"."max_y")) OR (("__20"."x" BETWEEN 2 AND ("size_5"."max_x" - 1)) AND ("__20"."y" BETWEEN 2 AND ("size_5"."max_y" - 1)))) AND
    (NOT EXISTS (
      SELECT NULL
      FROM "blizzards_1" AS "blizzards_4"
      WHERE
        ((((((("blizzards_4"."x" + ("blizzards_4"."dx" * "__20"."t")) - 2) % ("blizzards_4"."max_x" - 2)) + ("blizzards_4"."max_x" - 2)) % ("blizzards_4"."max_x" - 2)) + 2) = "__20"."x") AND
        ((((((("blizzards_4"."y" + ("blizzards_4"."dy" * "__20"."t")) - 2) % ("blizzards_4"."max_y" - 2)) + ("blizzards_4"."max_y" - 2)) % ("blizzards_4"."max_y" - 2)) + 2) = "__20"."y")
    ))
),
"__22" ("t", "x", "y", "done") AS (
  SELECT
    "__21"."t",
    "__21"."x",
    "__21"."y",
    FALSE AS "done"
  FROM "__16" AS "__21"
  WHERE "__21"."done"
  UNION ALL
  SELECT
    "__26"."t",
    "__26"."x",
    "__26"."y",
    (("__26"."x" = ("size_6"."max_x" - 1)) AND ("__26"."y" = "size_6"."max_y")) AS "done"
  FROM (
    SELECT DISTINCT
      ("__25"."t" + 1) AS "t",
      ("__25"."x" + "values_8"."dx") AS "x",
      ("__25"."y" + "values_8"."dy") AS "y"
    FROM (
      SELECT
        "__24"."x",
        "__24"."y",
        "__24"."t"
      FROM (
        SELECT
          "__23"."x",
          "__23"."y",
          "__23"."t",
          (bool_or("__23"."done") OVER ()) AS "bool_or"
        FROM "__22" AS "__23"
      ) AS "__24"
      WHERE (NOT "__24"."bool_or")
    ) AS "__25"
    CROSS JOIN (
      SELECT
        "values_7"."dx",
        "values_7"."dy"
      FROM (
        VALUES
          (0, 0),
          (1, 0),
          (-1, 0),
          (0, 1),
          (0, -1)
      ) AS "values_7" ("dx", "dy")
    ) AS "values_8"
  ) AS "__26"
  CROSS JOIN "size_1" AS "size_6"
  WHERE
    ((("__26"."x" = 2) AND ("__26"."y" = 1)) OR (("__26"."x" = ("size_6"."max_x" - 1)) AND ("__26"."y" = "size_6"."max_y")) OR (("__26"."x" BETWEEN 2 AND ("size_6"."max_x" - 1)) AND ("__26"."y" BETWEEN 2 AND ("size_6"."max_y" - 1)))) AND
    (NOT EXISTS (
      SELECT NULL
      FROM "blizzards_1" AS "blizzards_5"
      WHERE
        ((((((("blizzards_5"."x" + ("blizzards_5"."dx" * "__26"."t")) - 2) % ("blizzards_5"."max_x" - 2)) + ("blizzards_5"."max_x" - 2)) % ("blizzards_5"."max_x" - 2)) + 2) = "__26"."x") AND
        ((((((("blizzards_5"."y" + ("blizzards_5"."dy" * "__26"."t")) - 2) % ("blizzards_5"."max_y" - 2)) + ("blizzards_5"."max_y" - 2)) % ("blizzards_5"."max_y" - 2)) + 2) = "__26"."y")
    ))
)
SELECT
  "__9"."part1",
  "__28"."part2"
FROM (
  SELECT max("__8"."t") AS "part1"
  FROM "__3" AS "__8"
) AS "__9"
CROSS JOIN (
  SELECT max("__27"."t") AS "part2"
  FROM "__22" AS "__27"
) AS "__28"
