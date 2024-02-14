WITH RECURSIVE "positions_1" ("sx", "range", "sy", "bx", "by") AS (
  SELECT
    "regexp_matches_2"."sx",
    (abs(("regexp_matches_2"."sx" - "regexp_matches_2"."bx")) + abs(("regexp_matches_2"."sy" - "regexp_matches_2"."by"))) AS "range",
    "regexp_matches_2"."sy",
    "regexp_matches_2"."bx",
    "regexp_matches_2"."by"
  FROM (
    SELECT
      ("regexp_matches_1"."captures"[1]::integer) AS "sx",
      ("regexp_matches_1"."captures"[2]::integer) AS "sy",
      ("regexp_matches_1"."captures"[3]::integer) AS "bx",
      ("regexp_matches_1"."captures"[4]::integer) AS "by"
    FROM regexp_matches($1, 'Sensor at x=(\S+), y=(\S+): closest beacon is at x=(\S+), y=(\S+)', 'g') AS "regexp_matches_1" ("captures")
  ) AS "regexp_matches_2"
),
"__1" ("x", "y", "w", "h") AS (
  SELECT
    0 AS "x",
    0 AS "y",
    ($2 + 1) AS "w",
    ($2 + 1) AS "h"
  UNION ALL
  SELECT
    "__4"."x",
    "__4"."y",
    "__4"."w",
    "__4"."h"
  FROM (
    SELECT
      ("__3"."x" + (CASE WHEN (("values_2"."part" = 1) AND ("__3"."w" > "__3"."h")) THEN ("__3"."w" / 2) ELSE 0 END)) AS "x",
      ("__3"."y" + (CASE WHEN (("values_2"."part" = 1) AND ("__3"."w" <= "__3"."h")) THEN ("__3"."h" / 2) ELSE 0 END)) AS "y",
      (CASE WHEN ("__3"."w" <= "__3"."h") THEN "__3"."w" WHEN ("values_2"."part" = 0) THEN ("__3"."w" / 2) ELSE ("__3"."w" - ("__3"."w" / 2)) END) AS "w",
      (CASE WHEN ("__3"."w" > "__3"."h") THEN "__3"."h" WHEN ("values_2"."part" = 0) THEN ("__3"."h" / 2) ELSE ("__3"."h" - ("__3"."h" / 2)) END) AS "h"
    FROM (
      SELECT
        "__2"."x",
        "__2"."w",
        "__2"."h",
        "__2"."y"
      FROM "__1" AS "__2"
      WHERE
        ("__2"."w" > 1) OR
        ("__2"."h" > 1)
    ) AS "__3"
    CROSS JOIN (
      SELECT "values_1"."part"
      FROM (
        VALUES
          (0),
          (1)
      ) AS "values_1" ("part")
    ) AS "values_2"
  ) AS "__4"
  WHERE (NOT EXISTS (
    SELECT NULL AS "_"
    FROM "positions_1" AS "positions_10"
    WHERE
      ((abs(("positions_10"."sx" - "__4"."x")) + abs(("positions_10"."sy" - "__4"."y"))) <= "positions_10"."range") AND
      ((abs(("positions_10"."sx" - (("__4"."x" + "__4"."w") - 1))) + abs(("positions_10"."sy" - "__4"."y"))) <= "positions_10"."range") AND
      ((abs(("positions_10"."sx" - "__4"."x")) + abs(("positions_10"."sy" - (("__4"."y" + "__4"."h") - 1)))) <= "positions_10"."range") AND
      ((abs(("positions_10"."sx" - (("__4"."x" + "__4"."w") - 1))) + abs(("positions_10"."sy" - (("__4"."y" + "__4"."h") - 1)))) <= "positions_10"."range")
  ))
)
SELECT
  ("positions_8"."sum" - "beacons_1"."count_distinct") AS "part1",
  "__6"."part2"
FROM (
  SELECT sum((("positions_7"."r" - "positions_7"."l") + 1)) AS "sum"
  FROM (
    SELECT
      max("positions_6"."r") AS "r",
      min("positions_6"."l") AS "l"
    FROM (
      SELECT
        (sum("positions_5"."bound") OVER (ORDER BY "positions_5"."l", (- "positions_5"."bound") ROWS UNBOUNDED PRECEDING)) AS "interval",
        "positions_5"."l",
        "positions_5"."r"
      FROM (
        SELECT
          "positions_4"."l",
          "positions_4"."r",
          (CASE WHEN ("positions_4"."l" <= ((max("positions_4"."r") OVER (ORDER BY "positions_4"."l" ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)) + 1)) THEN 0 ELSE 1 END) AS "bound"
        FROM (
          SELECT
            (("positions_3"."sx" - "positions_3"."range") + "positions_3"."dist") AS "l",
            (("positions_3"."sx" + "positions_3"."range") - "positions_3"."dist") AS "r"
          FROM (
            SELECT
              "positions_2"."sx",
              "positions_2"."range",
              abs(($3 - "positions_2"."sy")) AS "dist"
            FROM "positions_1" AS "positions_2"
          ) AS "positions_3"
          WHERE ("positions_3"."dist" <= "positions_3"."range")
        ) AS "positions_4"
      ) AS "positions_5"
    ) AS "positions_6"
    GROUP BY "positions_6"."interval"
  ) AS "positions_7"
) AS "positions_8"
CROSS JOIN (
  SELECT count(DISTINCT "positions_9"."bx") AS "count_distinct"
  FROM "positions_1" AS "positions_9"
  WHERE ("positions_9"."by" = $3)
) AS "beacons_1"
CROSS JOIN (
  SELECT (("__5"."x" * (4000000::bigint)) + "__5"."y") AS "part2"
  FROM "__1" AS "__5"
  WHERE
    ("__5"."w" = 1) AND
    ("__5"."h" = 1)
) AS "__6"
