WITH RECURSIVE "valves_1" ("rate", "mask", "valve", "index") AS (
  SELECT
    "__2"."rate",
    (CASE WHEN ("__2"."rate" > 0) THEN (1 << ((count(*) FILTER (WHERE ("__2"."rate" > 0)) OVER (ORDER BY "__2"."index"))::integer)) END) AS "mask",
    "__2"."valve",
    "__2"."index"
  FROM (
    SELECT
      ("__1"."captures"[2]::integer) AS "rate",
      "__1"."captures"[1] AS "valve",
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
    "__6"."src",
    "__6"."dst",
    least("__6"."dist", ("__6"."src_to_curr" + (min("__6"."dist") FILTER (WHERE ("__6"."src" = "__6"."valve")) OVER (PARTITION BY "__6"."dst")))) AS "dist",
    "__6"."index"
  FROM (
    SELECT
      "__5"."src",
      "__5"."dst",
      "__5"."index",
      "__5"."dist",
      (min("__5"."dist") FILTER (WHERE ("__5"."dst" = "valves_4"."valve")) OVER (PARTITION BY "__5"."src")) AS "src_to_curr",
      "valves_4"."valve"
    FROM (
      SELECT
        "__4"."src",
        "__4"."dst",
        ("__4"."index" + 1) AS "index",
        "__4"."dist"
      FROM "__3" AS "__4"
    ) AS "__5"
    JOIN "valves_1" AS "valves_4" ON ("__5"."index" = "valves_4"."index")
  ) AS "__6"
),
"distances_1" ("dst", "dist", "src") AS (
  SELECT
    "__7"."dst",
    min("__7"."dist") AS "dist",
    "__7"."src"
  FROM "__3" AS "__7"
  GROUP BY
    "__7"."src",
    "__7"."dst"
),
"__8" ("total", "opened", "t", "curr") AS (
  SELECT
    0 AS "total",
    0 AS "opened",
    1 AS "t",
    'AA' AS "curr"
  UNION ALL
  SELECT
    max(("__10"."total" + ("__10"."rate" * ((30 - "__10"."t") + 1)))) AS "total",
    "__10"."opened",
    "__10"."t",
    "__10"."curr"
  FROM (
    SELECT
      ("__9"."t" + "distances_3"."dist" + 1) AS "t",
      "distances_3"."dst" AS "curr",
      ("__9"."opened" | "distances_3"."mask") AS "opened",
      "__9"."total",
      "distances_3"."rate"
    FROM "__8" AS "__9"
    JOIN (
      SELECT
        "valves_6"."rate",
        "distances_2"."dst",
        "valves_6"."mask",
        "distances_2"."dist",
        "distances_2"."src"
      FROM "distances_1" AS "distances_2"
      JOIN (
        SELECT
          "valves_5"."rate",
          "valves_5"."mask",
          "valves_5"."valve"
        FROM "valves_1" AS "valves_5"
        WHERE ("valves_5"."rate" > 0)
      ) AS "valves_6" ON ("distances_2"."dst" = "valves_6"."valve")
    ) AS "distances_3" ON ("__9"."curr" = "distances_3"."src")
    WHERE (("__9"."opened" & "distances_3"."mask") = 0)
  ) AS "__10"
  WHERE ("__10"."t" <= 30)
  GROUP BY
    "__10"."t",
    "__10"."curr",
    "__10"."opened"
),
"__13" ("opened", "total", "t", "curr") AS (
  SELECT
    0 AS "opened",
    0 AS "total",
    1 AS "t",
    'AA' AS "curr"
  UNION ALL
  SELECT
    "__15"."opened",
    max(("__15"."total" + ("__15"."rate" * ((26 - "__15"."t") + 1)))) AS "total",
    "__15"."t",
    "__15"."curr"
  FROM (
    SELECT
      ("__14"."t" + "distances_5"."dist" + 1) AS "t",
      "distances_5"."dst" AS "curr",
      ("__14"."opened" | "distances_5"."mask") AS "opened",
      "__14"."total",
      "distances_5"."rate"
    FROM "__13" AS "__14"
    JOIN (
      SELECT
        "valves_8"."rate",
        "distances_4"."dst",
        "valves_8"."mask",
        "distances_4"."dist",
        "distances_4"."src"
      FROM "distances_1" AS "distances_4"
      JOIN (
        SELECT
          "valves_7"."rate",
          "valves_7"."mask",
          "valves_7"."valve"
        FROM "valves_1" AS "valves_7"
        WHERE ("valves_7"."rate" > 0)
      ) AS "valves_8" ON ("distances_4"."dst" = "valves_8"."valve")
    ) AS "distances_5" ON ("__14"."curr" = "distances_5"."src")
    WHERE (("__14"."opened" & "distances_5"."mask") = 0)
  ) AS "__15"
  WHERE ("__15"."t" <= 26)
  GROUP BY
    "__15"."t",
    "__15"."curr",
    "__15"."opened"
),
"totals_1" ("total", "opened") AS (
  SELECT
    max("__16"."total") AS "total",
    "__16"."opened"
  FROM "__13" AS "__16"
  GROUP BY "__16"."opened"
)
SELECT
  "__12"."part1",
  "totals_4"."part2"
FROM (
  SELECT max("__11"."total") AS "part1"
  FROM "__8" AS "__11"
) AS "__12"
CROSS JOIN (
  SELECT max(("totals_2"."total" + "totals_3"."total")) AS "part2"
  FROM "totals_1" AS "totals_2"
  JOIN "totals_1" AS "totals_3" ON (("totals_2"."opened" & "totals_3"."opened") = 0)
) AS "totals_4"
