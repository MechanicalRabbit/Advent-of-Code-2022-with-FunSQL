WITH RECURSIVE "numbers_1" ("value", "index", "original_index") AS (
  SELECT
    ("__1"."captures"[1]::bigint) AS "value",
    "__1"."index",
    "__1"."index" AS "original_index"
  FROM regexp_matches($1, '[-0-9]+', 'g') WITH ORDINALITY AS "__1" ("captures", "index")
),
"length_1" ("length") AS (
  SELECT count(*) AS "length"
  FROM "numbers_1" AS "numbers_2"
),
"__2" ("value", "index", "length", "mix_index", "original_index") AS (
  SELECT
    "numbers_3"."value",
    "numbers_3"."index",
    "length_2"."length",
    1 AS "mix_index",
    "numbers_3"."original_index"
  FROM "numbers_1" AS "numbers_3"
  CROSS JOIN "length_1" AS "length_2"
  UNION ALL
  SELECT
    "__5"."value",
    (CASE WHEN ("__5"."index" = "__5"."move_from") THEN "__5"."move_to" WHEN ("__5"."index" BETWEEN ("__5"."move_from" + 1) AND "__5"."move_to") THEN ("__5"."index" - 1) WHEN ("__5"."index" BETWEEN "__5"."move_to" AND ("__5"."move_from" - 1)) THEN ("__5"."index" + 1) ELSE "__5"."index" END) AS "index",
    "__5"."length",
    ("__5"."mix_index" + 1) AS "mix_index",
    "__5"."original_index"
  FROM (
    SELECT
      "__4"."value",
      "__4"."length",
      "__4"."original_index",
      "__4"."mix_index",
      "__4"."index",
      "__4"."move_from",
      (((((("__4"."move_from" + "__4"."move_delta") - 1) % ("__4"."length" - 1)) + ("__4"."length" - 1)) % ("__4"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "__3"."value",
        "__3"."length",
        "__3"."original_index",
        "__3"."mix_index",
        "__3"."index",
        (min("__3"."index") FILTER (WHERE ("__3"."original_index" = "__3"."mix_index")) OVER ()) AS "move_from",
        (min("__3"."value") FILTER (WHERE ("__3"."original_index" = "__3"."mix_index")) OVER ()) AS "move_delta"
      FROM "__2" AS "__3"
      WHERE ("__3"."mix_index" <= "__3"."length")
    ) AS "__4"
  ) AS "__5"
),
"__9" ("value", "index", "length", "original_index", "mix_index") AS (
  SELECT
    ("numbers_4"."value" * 811589153) AS "value",
    "numbers_4"."index",
    "length_3"."length",
    "numbers_4"."original_index",
    1 AS "mix_index"
  FROM "numbers_1" AS "numbers_4"
  CROSS JOIN "length_1" AS "length_3"
  UNION ALL
  SELECT
    "__12"."value",
    (CASE WHEN ("__12"."index" = "__12"."move_from") THEN "__12"."move_to" WHEN ("__12"."index" BETWEEN ("__12"."move_from" + 1) AND "__12"."move_to") THEN ("__12"."index" - 1) WHEN ("__12"."index" BETWEEN "__12"."move_to" AND ("__12"."move_from" - 1)) THEN ("__12"."index" + 1) ELSE "__12"."index" END) AS "index",
    "__12"."length",
    "__12"."original_index",
    ("__12"."mix_index" + 1) AS "mix_index"
  FROM (
    SELECT
      "__11"."value",
      "__11"."length",
      "__11"."original_index",
      "__11"."mix_index",
      "__11"."index",
      "__11"."move_from",
      (((((("__11"."move_from" + "__11"."move_delta") - 1) % ("__11"."length" - 1)) + ("__11"."length" - 1)) % ("__11"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "__10"."value",
        "__10"."length",
        "__10"."original_index",
        "__10"."mix_index",
        "__10"."index",
        (min("__10"."index") FILTER (WHERE ("__10"."original_index" = "__10"."mix_index")) OVER ()) AS "move_from",
        (min("__10"."value") FILTER (WHERE ("__10"."original_index" = "__10"."mix_index")) OVER ()) AS "move_delta"
      FROM "__9" AS "__10"
      WHERE ("__10"."mix_index" <= "__10"."length")
    ) AS "__11"
  ) AS "__12"
),
"__14" ("value", "index", "length", "original_index", "mix_index") AS (
  SELECT
    "__13"."value",
    "__13"."index",
    "__13"."length",
    "__13"."original_index",
    1 AS "mix_index"
  FROM "__9" AS "__13"
  WHERE ("__13"."mix_index" = ("__13"."length" + 1))
  UNION ALL
  SELECT
    "__17"."value",
    (CASE WHEN ("__17"."index" = "__17"."move_from") THEN "__17"."move_to" WHEN ("__17"."index" BETWEEN ("__17"."move_from" + 1) AND "__17"."move_to") THEN ("__17"."index" - 1) WHEN ("__17"."index" BETWEEN "__17"."move_to" AND ("__17"."move_from" - 1)) THEN ("__17"."index" + 1) ELSE "__17"."index" END) AS "index",
    "__17"."length",
    "__17"."original_index",
    ("__17"."mix_index" + 1) AS "mix_index"
  FROM (
    SELECT
      "__16"."value",
      "__16"."length",
      "__16"."original_index",
      "__16"."mix_index",
      "__16"."index",
      "__16"."move_from",
      (((((("__16"."move_from" + "__16"."move_delta") - 1) % ("__16"."length" - 1)) + ("__16"."length" - 1)) % ("__16"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "__15"."value",
        "__15"."length",
        "__15"."original_index",
        "__15"."mix_index",
        "__15"."index",
        (min("__15"."index") FILTER (WHERE ("__15"."original_index" = "__15"."mix_index")) OVER ()) AS "move_from",
        (min("__15"."value") FILTER (WHERE ("__15"."original_index" = "__15"."mix_index")) OVER ()) AS "move_delta"
      FROM "__14" AS "__15"
      WHERE ("__15"."mix_index" <= "__15"."length")
    ) AS "__16"
  ) AS "__17"
),
"__19" ("value", "index", "length", "original_index", "mix_index") AS (
  SELECT
    "__18"."value",
    "__18"."index",
    "__18"."length",
    "__18"."original_index",
    1 AS "mix_index"
  FROM "__14" AS "__18"
  WHERE ("__18"."mix_index" = ("__18"."length" + 1))
  UNION ALL
  SELECT
    "__22"."value",
    (CASE WHEN ("__22"."index" = "__22"."move_from") THEN "__22"."move_to" WHEN ("__22"."index" BETWEEN ("__22"."move_from" + 1) AND "__22"."move_to") THEN ("__22"."index" - 1) WHEN ("__22"."index" BETWEEN "__22"."move_to" AND ("__22"."move_from" - 1)) THEN ("__22"."index" + 1) ELSE "__22"."index" END) AS "index",
    "__22"."length",
    "__22"."original_index",
    ("__22"."mix_index" + 1) AS "mix_index"
  FROM (
    SELECT
      "__21"."value",
      "__21"."length",
      "__21"."original_index",
      "__21"."mix_index",
      "__21"."index",
      "__21"."move_from",
      (((((("__21"."move_from" + "__21"."move_delta") - 1) % ("__21"."length" - 1)) + ("__21"."length" - 1)) % ("__21"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "__20"."value",
        "__20"."length",
        "__20"."original_index",
        "__20"."mix_index",
        "__20"."index",
        (min("__20"."index") FILTER (WHERE ("__20"."original_index" = "__20"."mix_index")) OVER ()) AS "move_from",
        (min("__20"."value") FILTER (WHERE ("__20"."original_index" = "__20"."mix_index")) OVER ()) AS "move_delta"
      FROM "__19" AS "__20"
      WHERE ("__20"."mix_index" <= "__20"."length")
    ) AS "__21"
  ) AS "__22"
),
"__24" ("value", "index", "length", "original_index", "mix_index") AS (
  SELECT
    "__23"."value",
    "__23"."index",
    "__23"."length",
    "__23"."original_index",
    1 AS "mix_index"
  FROM "__19" AS "__23"
  WHERE ("__23"."mix_index" = ("__23"."length" + 1))
  UNION ALL
  SELECT
    "__27"."value",
    (CASE WHEN ("__27"."index" = "__27"."move_from") THEN "__27"."move_to" WHEN ("__27"."index" BETWEEN ("__27"."move_from" + 1) AND "__27"."move_to") THEN ("__27"."index" - 1) WHEN ("__27"."index" BETWEEN "__27"."move_to" AND ("__27"."move_from" - 1)) THEN ("__27"."index" + 1) ELSE "__27"."index" END) AS "index",
    "__27"."length",
    "__27"."original_index",
    ("__27"."mix_index" + 1) AS "mix_index"
  FROM (
    SELECT
      "__26"."value",
      "__26"."length",
      "__26"."original_index",
      "__26"."mix_index",
      "__26"."index",
      "__26"."move_from",
      (((((("__26"."move_from" + "__26"."move_delta") - 1) % ("__26"."length" - 1)) + ("__26"."length" - 1)) % ("__26"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "__25"."value",
        "__25"."length",
        "__25"."original_index",
        "__25"."mix_index",
        "__25"."index",
        (min("__25"."index") FILTER (WHERE ("__25"."original_index" = "__25"."mix_index")) OVER ()) AS "move_from",
        (min("__25"."value") FILTER (WHERE ("__25"."original_index" = "__25"."mix_index")) OVER ()) AS "move_delta"
      FROM "__24" AS "__25"
      WHERE ("__25"."mix_index" <= "__25"."length")
    ) AS "__26"
  ) AS "__27"
),
"__29" ("value", "index", "length", "original_index", "mix_index") AS (
  SELECT
    "__28"."value",
    "__28"."index",
    "__28"."length",
    "__28"."original_index",
    1 AS "mix_index"
  FROM "__24" AS "__28"
  WHERE ("__28"."mix_index" = ("__28"."length" + 1))
  UNION ALL
  SELECT
    "__32"."value",
    (CASE WHEN ("__32"."index" = "__32"."move_from") THEN "__32"."move_to" WHEN ("__32"."index" BETWEEN ("__32"."move_from" + 1) AND "__32"."move_to") THEN ("__32"."index" - 1) WHEN ("__32"."index" BETWEEN "__32"."move_to" AND ("__32"."move_from" - 1)) THEN ("__32"."index" + 1) ELSE "__32"."index" END) AS "index",
    "__32"."length",
    "__32"."original_index",
    ("__32"."mix_index" + 1) AS "mix_index"
  FROM (
    SELECT
      "__31"."value",
      "__31"."length",
      "__31"."original_index",
      "__31"."mix_index",
      "__31"."index",
      "__31"."move_from",
      (((((("__31"."move_from" + "__31"."move_delta") - 1) % ("__31"."length" - 1)) + ("__31"."length" - 1)) % ("__31"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "__30"."value",
        "__30"."length",
        "__30"."original_index",
        "__30"."mix_index",
        "__30"."index",
        (min("__30"."index") FILTER (WHERE ("__30"."original_index" = "__30"."mix_index")) OVER ()) AS "move_from",
        (min("__30"."value") FILTER (WHERE ("__30"."original_index" = "__30"."mix_index")) OVER ()) AS "move_delta"
      FROM "__29" AS "__30"
      WHERE ("__30"."mix_index" <= "__30"."length")
    ) AS "__31"
  ) AS "__32"
),
"__34" ("value", "index", "length", "original_index", "mix_index") AS (
  SELECT
    "__33"."value",
    "__33"."index",
    "__33"."length",
    "__33"."original_index",
    1 AS "mix_index"
  FROM "__29" AS "__33"
  WHERE ("__33"."mix_index" = ("__33"."length" + 1))
  UNION ALL
  SELECT
    "__37"."value",
    (CASE WHEN ("__37"."index" = "__37"."move_from") THEN "__37"."move_to" WHEN ("__37"."index" BETWEEN ("__37"."move_from" + 1) AND "__37"."move_to") THEN ("__37"."index" - 1) WHEN ("__37"."index" BETWEEN "__37"."move_to" AND ("__37"."move_from" - 1)) THEN ("__37"."index" + 1) ELSE "__37"."index" END) AS "index",
    "__37"."length",
    "__37"."original_index",
    ("__37"."mix_index" + 1) AS "mix_index"
  FROM (
    SELECT
      "__36"."value",
      "__36"."length",
      "__36"."original_index",
      "__36"."mix_index",
      "__36"."index",
      "__36"."move_from",
      (((((("__36"."move_from" + "__36"."move_delta") - 1) % ("__36"."length" - 1)) + ("__36"."length" - 1)) % ("__36"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "__35"."value",
        "__35"."length",
        "__35"."original_index",
        "__35"."mix_index",
        "__35"."index",
        (min("__35"."index") FILTER (WHERE ("__35"."original_index" = "__35"."mix_index")) OVER ()) AS "move_from",
        (min("__35"."value") FILTER (WHERE ("__35"."original_index" = "__35"."mix_index")) OVER ()) AS "move_delta"
      FROM "__34" AS "__35"
      WHERE ("__35"."mix_index" <= "__35"."length")
    ) AS "__36"
  ) AS "__37"
),
"__39" ("value", "index", "length", "original_index", "mix_index") AS (
  SELECT
    "__38"."value",
    "__38"."index",
    "__38"."length",
    "__38"."original_index",
    1 AS "mix_index"
  FROM "__34" AS "__38"
  WHERE ("__38"."mix_index" = ("__38"."length" + 1))
  UNION ALL
  SELECT
    "__42"."value",
    (CASE WHEN ("__42"."index" = "__42"."move_from") THEN "__42"."move_to" WHEN ("__42"."index" BETWEEN ("__42"."move_from" + 1) AND "__42"."move_to") THEN ("__42"."index" - 1) WHEN ("__42"."index" BETWEEN "__42"."move_to" AND ("__42"."move_from" - 1)) THEN ("__42"."index" + 1) ELSE "__42"."index" END) AS "index",
    "__42"."length",
    "__42"."original_index",
    ("__42"."mix_index" + 1) AS "mix_index"
  FROM (
    SELECT
      "__41"."value",
      "__41"."length",
      "__41"."original_index",
      "__41"."mix_index",
      "__41"."index",
      "__41"."move_from",
      (((((("__41"."move_from" + "__41"."move_delta") - 1) % ("__41"."length" - 1)) + ("__41"."length" - 1)) % ("__41"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "__40"."value",
        "__40"."length",
        "__40"."original_index",
        "__40"."mix_index",
        "__40"."index",
        (min("__40"."index") FILTER (WHERE ("__40"."original_index" = "__40"."mix_index")) OVER ()) AS "move_from",
        (min("__40"."value") FILTER (WHERE ("__40"."original_index" = "__40"."mix_index")) OVER ()) AS "move_delta"
      FROM "__39" AS "__40"
      WHERE ("__40"."mix_index" <= "__40"."length")
    ) AS "__41"
  ) AS "__42"
),
"__44" ("value", "index", "length", "original_index", "mix_index") AS (
  SELECT
    "__43"."value",
    "__43"."index",
    "__43"."length",
    "__43"."original_index",
    1 AS "mix_index"
  FROM "__39" AS "__43"
  WHERE ("__43"."mix_index" = ("__43"."length" + 1))
  UNION ALL
  SELECT
    "__47"."value",
    (CASE WHEN ("__47"."index" = "__47"."move_from") THEN "__47"."move_to" WHEN ("__47"."index" BETWEEN ("__47"."move_from" + 1) AND "__47"."move_to") THEN ("__47"."index" - 1) WHEN ("__47"."index" BETWEEN "__47"."move_to" AND ("__47"."move_from" - 1)) THEN ("__47"."index" + 1) ELSE "__47"."index" END) AS "index",
    "__47"."length",
    "__47"."original_index",
    ("__47"."mix_index" + 1) AS "mix_index"
  FROM (
    SELECT
      "__46"."value",
      "__46"."length",
      "__46"."original_index",
      "__46"."mix_index",
      "__46"."index",
      "__46"."move_from",
      (((((("__46"."move_from" + "__46"."move_delta") - 1) % ("__46"."length" - 1)) + ("__46"."length" - 1)) % ("__46"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "__45"."value",
        "__45"."length",
        "__45"."original_index",
        "__45"."mix_index",
        "__45"."index",
        (min("__45"."index") FILTER (WHERE ("__45"."original_index" = "__45"."mix_index")) OVER ()) AS "move_from",
        (min("__45"."value") FILTER (WHERE ("__45"."original_index" = "__45"."mix_index")) OVER ()) AS "move_delta"
      FROM "__44" AS "__45"
      WHERE ("__45"."mix_index" <= "__45"."length")
    ) AS "__46"
  ) AS "__47"
),
"__49" ("value", "index", "length", "original_index", "mix_index") AS (
  SELECT
    "__48"."value",
    "__48"."index",
    "__48"."length",
    "__48"."original_index",
    1 AS "mix_index"
  FROM "__44" AS "__48"
  WHERE ("__48"."mix_index" = ("__48"."length" + 1))
  UNION ALL
  SELECT
    "__52"."value",
    (CASE WHEN ("__52"."index" = "__52"."move_from") THEN "__52"."move_to" WHEN ("__52"."index" BETWEEN ("__52"."move_from" + 1) AND "__52"."move_to") THEN ("__52"."index" - 1) WHEN ("__52"."index" BETWEEN "__52"."move_to" AND ("__52"."move_from" - 1)) THEN ("__52"."index" + 1) ELSE "__52"."index" END) AS "index",
    "__52"."length",
    "__52"."original_index",
    ("__52"."mix_index" + 1) AS "mix_index"
  FROM (
    SELECT
      "__51"."value",
      "__51"."length",
      "__51"."original_index",
      "__51"."mix_index",
      "__51"."index",
      "__51"."move_from",
      (((((("__51"."move_from" + "__51"."move_delta") - 1) % ("__51"."length" - 1)) + ("__51"."length" - 1)) % ("__51"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "__50"."value",
        "__50"."length",
        "__50"."original_index",
        "__50"."mix_index",
        "__50"."index",
        (min("__50"."index") FILTER (WHERE ("__50"."original_index" = "__50"."mix_index")) OVER ()) AS "move_from",
        (min("__50"."value") FILTER (WHERE ("__50"."original_index" = "__50"."mix_index")) OVER ()) AS "move_delta"
      FROM "__49" AS "__50"
      WHERE ("__50"."mix_index" <= "__50"."length")
    ) AS "__51"
  ) AS "__52"
),
"__54" ("value", "index", "length", "mix_index", "original_index") AS (
  SELECT
    "__53"."value",
    "__53"."index",
    "__53"."length",
    1 AS "mix_index",
    "__53"."original_index"
  FROM "__49" AS "__53"
  WHERE ("__53"."mix_index" = ("__53"."length" + 1))
  UNION ALL
  SELECT
    "__57"."value",
    (CASE WHEN ("__57"."index" = "__57"."move_from") THEN "__57"."move_to" WHEN ("__57"."index" BETWEEN ("__57"."move_from" + 1) AND "__57"."move_to") THEN ("__57"."index" - 1) WHEN ("__57"."index" BETWEEN "__57"."move_to" AND ("__57"."move_from" - 1)) THEN ("__57"."index" + 1) ELSE "__57"."index" END) AS "index",
    "__57"."length",
    ("__57"."mix_index" + 1) AS "mix_index",
    "__57"."original_index"
  FROM (
    SELECT
      "__56"."value",
      "__56"."length",
      "__56"."original_index",
      "__56"."mix_index",
      "__56"."index",
      "__56"."move_from",
      (((((("__56"."move_from" + "__56"."move_delta") - 1) % ("__56"."length" - 1)) + ("__56"."length" - 1)) % ("__56"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "__55"."value",
        "__55"."length",
        "__55"."original_index",
        "__55"."mix_index",
        "__55"."index",
        (min("__55"."index") FILTER (WHERE ("__55"."original_index" = "__55"."mix_index")) OVER ()) AS "move_from",
        (min("__55"."value") FILTER (WHERE ("__55"."original_index" = "__55"."mix_index")) OVER ()) AS "move_delta"
      FROM "__54" AS "__55"
      WHERE ("__55"."mix_index" <= "__55"."length")
    ) AS "__56"
  ) AS "__57"
)
SELECT
  "__8"."part1",
  "__60"."part2"
FROM (
  SELECT (sum("__7"."value") FILTER (WHERE ("__7"."index" IN ((((((("__7"."index0" + 1000) - 1) % "__7"."length") + "__7"."length") % "__7"."length") + 1), (((((("__7"."index0" + 2000) - 1) % "__7"."length") + "__7"."length") % "__7"."length") + 1), (((((("__7"."index0" + 3000) - 1) % "__7"."length") + "__7"."length") % "__7"."length") + 1))))) AS "part1"
  FROM (
    SELECT
      "__6"."value",
      "__6"."index",
      (min("__6"."index") FILTER (WHERE ("__6"."value" = 0)) OVER ()) AS "index0",
      "__6"."length"
    FROM "__2" AS "__6"
    WHERE ("__6"."mix_index" = ("__6"."length" + 1))
  ) AS "__7"
) AS "__8"
CROSS JOIN (
  SELECT (sum("__59"."value") FILTER (WHERE ("__59"."index" IN ((((((("__59"."index0" + 1000) - 1) % "__59"."length") + "__59"."length") % "__59"."length") + 1), (((((("__59"."index0" + 2000) - 1) % "__59"."length") + "__59"."length") % "__59"."length") + 1), (((((("__59"."index0" + 3000) - 1) % "__59"."length") + "__59"."length") % "__59"."length") + 1))))) AS "part2"
  FROM (
    SELECT
      "__58"."value",
      "__58"."index",
      (min("__58"."index") FILTER (WHERE ("__58"."value" = 0)) OVER ()) AS "index0",
      "__58"."length"
    FROM "__54" AS "__58"
    WHERE ("__58"."mix_index" = ("__58"."length" + 1))
  ) AS "__59"
) AS "__60"
