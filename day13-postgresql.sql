WITH RECURSIVE "__2" ("packet", "index", "rest", "depth") AS (
  SELECT
    '' AS "packet",
    "__1"."index",
    "__1"."captures"[1] AS "rest",
    0 AS "depth"
  FROM regexp_matches($1, '\S+', 'g') WITH ORDINALITY AS "__1" ("captures", "index")
  UNION ALL
  SELECT
    concat("__5"."packet", (CASE WHEN ("__5"."token" = '[]') THEN concat('/', chr((32 + "__5"."depth"))) WHEN ("__5"."token" = '10') THEN ':' WHEN (("__5"."token" = '[') OR ("__5"."token" = ']')) THEN '' WHEN ("__5"."token" = ',') THEN chr((58 + "__5"."depth")) ELSE "__5"."token" END)) AS "packet",
    "__5"."index",
    "__5"."rest",
    ("__5"."depth" + (CASE WHEN ("__5"."token" = '[') THEN 1 WHEN ("__5"."token" = ']') THEN -1 ELSE 0 END)) AS "depth"
  FROM (
    SELECT
      "__4"."index",
      "__4"."captures"[2] AS "rest",
      "__4"."packet",
      "__4"."captures"[1] AS "token",
      "__4"."depth"
    FROM (
      SELECT
        "__3"."index",
        "__3"."packet",
        "__3"."depth",
        regexp_match("__3"."rest", '(\[\]|10|.)(.*)') AS "captures"
      FROM "__2" AS "__3"
      WHERE ("__3"."rest" <> '')
    ) AS "__4"
  ) AS "__5"
),
"packets_1" ("packet", "index") AS (
  SELECT
    "__6"."packet",
    "__6"."index"
  FROM "__2" AS "__6"
  WHERE ("__6"."rest" = '')
)
SELECT
  "packets_4"."part1",
  "packets_6"."part2"
FROM (
  SELECT (sum(("packets_3"."index" / 2)) FILTER (WHERE "packets_3"."ordered")) AS "part1"
  FROM (
    SELECT
      "packets_2"."index",
      ((lag("packets_2"."packet") OVER (ORDER BY "packets_2"."index")) < ("packets_2"."packet" COLLATE "C")) AS "ordered"
    FROM "packets_1" AS "packets_2"
  ) AS "packets_3"
  WHERE (mod("packets_3"."index", 2) = 0)
) AS "packets_4"
CROSS JOIN (
  SELECT ((1 + (count(*) FILTER (WHERE (("packets_5"."packet" COLLATE "C") < '2')))) * (2 + (count(*) FILTER (WHERE (("packets_5"."packet" COLLATE "C") < '6'))))) AS "part2"
  FROM "packets_1" AS "packets_5"
) AS "packets_6"
