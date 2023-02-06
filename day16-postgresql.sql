WITH RECURSIVE "valves_1" ("mask", "valve", "rate", "index") AS (
  SELECT
    (CASE WHEN ("__2"."rate" > 0) THEN (1 << ((count(*) FILTER (WHERE ("__2"."rate" > 0)) OVER (ORDER BY "__2"."index"))::integer)) END) AS "mask",
    "__2"."valve",
    "__2"."rate",
    "__2"."index"
  FROM (
    SELECT
      "__1"."captures"[1] AS "valve",
      ("__1"."captures"[2]::integer) AS "rate",
      "__1"."index"
    FROM regexp_matches($1, 'Valve (\w+) has flow rate=(\d+)', 'g') WITH ORDINALITY AS "__1" ("captures", "index")
  ) AS "__2"
),
"tunnels_1" ("tunnel_src", "tunnel_dst") AS (
  SELECT
    "regexp_matches_1"."captures"[1] AS "tunnel_src",
    "string_to_table_1"."tunnel_dst"
  FROM regexp_matches($1, 'Valve (\w+) .* to valves? (.+)', 'gn') AS "regexp_matches_1" ("captures")
  CROSS JOIN string_to_table("regexp_matches_1"."captures"[2], ', ') AS "string_to_table_1" ("tunnel_dst")
),
"__3" ("src", "dst", "dist", "index") AS (
  SELECT
    "valves_2"."valve" AS "src",
    "valves_3"."valve" AS "dst",
    (CASE WHEN ("valves_2"."valve" = "valves_3"."valve") THEN 0 WHEN ("tunnels_2"."tunnel_src" IS NOT NULL) THEN 1 END) AS "dist",
    0 AS "index"
  FROM "valves_1" AS "valves_2"
  CROSS JOIN "valves_1" AS "valves_3"
  LEFT JOIN "tunnels_1" AS "tunnels_2" ON (("valves_2"."valve" = "tunnels_2"."tunnel_src") AND ("valves_3"."valve" = "tunnels_2"."tunnel_dst"))
  UNION ALL
  SELECT
    "valves_7"."src",
    "valves_7"."dst",
    least("valves_7"."dist", ("valves_7"."src_to_curr" + (min("valves_7"."dist") FILTER (WHERE ("valves_7"."src" = "valves_7"."valve")) OVER (PARTITION BY "valves_7"."dst")))) AS "dist",
    "valves_7"."index"
  FROM (
    SELECT
      "valves_5"."src",
      "valves_5"."dst",
      "valves_5"."index",
      "valves_5"."dist",
      (min("valves_5"."dist") FILTER (WHERE ("valves_5"."dst" = "valves_6"."valve")) OVER (PARTITION BY "valves_5"."src")) AS "src_to_curr",
      "valves_6"."valve"
    FROM (
      SELECT
        "valves_4"."src",
        "valves_4"."dst",
        ("valves_4"."index" + 1) AS "index",
        "valves_4"."dist"
      FROM "__3" AS "valves_4"
    ) AS "valves_5"
    JOIN "valves_1" AS "valves_6" ON ("valves_5"."index" = "valves_6"."index")
  ) AS "valves_7"
),
"distances_1" ("dist", "dst", "src") AS (
  SELECT
    min("__4"."dist") AS "dist",
    "__4"."dst",
    "__4"."src"
  FROM "__3" AS "__4"
  GROUP BY
    "__4"."src",
    "__4"."dst"
),
"__5" ("total", "t", "opened", "curr") AS (
  SELECT
    0 AS "total",
    1 AS "t",
    0 AS "opened",
    'AA' AS "curr"
  UNION ALL
  SELECT
    max(("__7"."total" + ("__7"."rate" * ((30 - "__7"."t") + 1)))) AS "total",
    "__7"."t",
    "__7"."opened",
    "__7"."curr"
  FROM (
    SELECT
      ("__6"."t" + "distances_3"."dist" + 1) AS "t",
      "distances_3"."dst" AS "curr",
      ("__6"."opened" | "distances_3"."mask") AS "opened",
      "__6"."total",
      "distances_3"."rate"
    FROM "__5" AS "__6"
    JOIN (
      SELECT
        "valves_9"."rate",
        "distances_2"."dist",
        "distances_2"."dst",
        "valves_9"."mask",
        "distances_2"."src"
      FROM "distances_1" AS "distances_2"
      JOIN (
        SELECT
          "valves_8"."rate",
          "valves_8"."mask",
          "valves_8"."valve"
        FROM "valves_1" AS "valves_8"
        WHERE ("valves_8"."rate" > 0)
      ) AS "valves_9" ON ("distances_2"."dst" = "valves_9"."valve")
    ) AS "distances_3" ON ("__6"."curr" = "distances_3"."src")
    WHERE (("__6"."opened" & "distances_3"."mask") = 0)
  ) AS "__7"
  WHERE ("__7"."t" <= 30)
  GROUP BY
    "__7"."t",
    "__7"."curr",
    "__7"."opened"
),
"__10" ("opened", "total", "t", "curr") AS (
  SELECT
    0 AS "opened",
    0 AS "total",
    1 AS "t",
    'AA' AS "curr"
  UNION ALL
  SELECT
    "__12"."opened",
    max(("__12"."total" + ("__12"."rate" * ((26 - "__12"."t") + 1)))) AS "total",
    "__12"."t",
    "__12"."curr"
  FROM (
    SELECT
      ("__11"."t" + "distances_5"."dist" + 1) AS "t",
      "distances_5"."dst" AS "curr",
      ("__11"."opened" | "distances_5"."mask") AS "opened",
      "__11"."total",
      "distances_5"."rate"
    FROM "__10" AS "__11"
    JOIN (
      SELECT
        "valves_11"."rate",
        "distances_4"."dist",
        "distances_4"."dst",
        "valves_11"."mask",
        "distances_4"."src"
      FROM "distances_1" AS "distances_4"
      JOIN (
        SELECT
          "valves_10"."rate",
          "valves_10"."mask",
          "valves_10"."valve"
        FROM "valves_1" AS "valves_10"
        WHERE ("valves_10"."rate" > 0)
      ) AS "valves_11" ON ("distances_4"."dst" = "valves_11"."valve")
    ) AS "distances_5" ON ("__11"."curr" = "distances_5"."src")
    WHERE (("__11"."opened" & "distances_5"."mask") = 0)
  ) AS "__12"
  WHERE ("__12"."t" <= 26)
  GROUP BY
    "__12"."t",
    "__12"."curr",
    "__12"."opened"
),
"totals_1" ("total", "opened") AS (
  SELECT
    max("__13"."total") AS "total",
    "__13"."opened"
  FROM "__10" AS "__13"
  GROUP BY "__13"."opened"
)
SELECT
  "__9"."part1",
  "totals_4"."part2"
FROM (
  SELECT max("__8"."total") AS "part1"
  FROM "__5" AS "__8"
) AS "__9"
CROSS JOIN (
  SELECT max(("totals_2"."total" + "totals_3"."total")) AS "part2"
  FROM "totals_1" AS "totals_2"
  JOIN "totals_1" AS "totals_3" ON (("totals_2"."opened" & "totals_3"."opened") = 0)
) AS "totals_4"
