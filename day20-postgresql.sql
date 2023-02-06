WITH RECURSIVE "numbers_1" ("index", "original_index", "value") AS (
  SELECT
    "__1"."index",
    "__1"."index" AS "original_index",
    ("__1"."captures"[1]::bigint) AS "value"
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
    "numbers_6"."value",
    (CASE WHEN ("numbers_6"."index" = "numbers_6"."move_from") THEN "numbers_6"."move_to" WHEN ("numbers_6"."index" BETWEEN ("numbers_6"."move_from" + 1) AND "numbers_6"."move_to") THEN ("numbers_6"."index" - 1) WHEN ("numbers_6"."index" BETWEEN "numbers_6"."move_to" AND ("numbers_6"."move_from" - 1)) THEN ("numbers_6"."index" + 1) ELSE "numbers_6"."index" END) AS "index",
    "numbers_6"."length",
    ("numbers_6"."mix_index" + 1) AS "mix_index",
    "numbers_6"."original_index"
  FROM (
    SELECT
      "numbers_5"."value",
      "numbers_5"."length",
      "numbers_5"."original_index",
      "numbers_5"."mix_index",
      "numbers_5"."index",
      "numbers_5"."move_from",
      (((((("numbers_5"."move_from" + "numbers_5"."move_delta") - 1) % ("numbers_5"."length" - 1)) + ("numbers_5"."length" - 1)) % ("numbers_5"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "numbers_4"."value",
        "numbers_4"."length",
        "numbers_4"."original_index",
        "numbers_4"."mix_index",
        "numbers_4"."index",
        (min("numbers_4"."index") FILTER (WHERE ("numbers_4"."original_index" = "numbers_4"."mix_index")) OVER ()) AS "move_from",
        (min("numbers_4"."value") FILTER (WHERE ("numbers_4"."original_index" = "numbers_4"."mix_index")) OVER ()) AS "move_delta"
      FROM "__2" AS "numbers_4"
      WHERE ("numbers_4"."mix_index" <= "numbers_4"."length")
    ) AS "numbers_5"
  ) AS "numbers_6"
),
"__4" ("value", "index", "length", "original_index", "mix_index") AS (
  SELECT
    ("numbers_9"."value" * 811589153) AS "value",
    "numbers_9"."index",
    "length_3"."length",
    "numbers_9"."original_index",
    1 AS "mix_index"
  FROM "numbers_1" AS "numbers_9"
  CROSS JOIN "length_1" AS "length_3"
  UNION ALL
  SELECT
    "numbers_12"."value",
    (CASE WHEN ("numbers_12"."index" = "numbers_12"."move_from") THEN "numbers_12"."move_to" WHEN ("numbers_12"."index" BETWEEN ("numbers_12"."move_from" + 1) AND "numbers_12"."move_to") THEN ("numbers_12"."index" - 1) WHEN ("numbers_12"."index" BETWEEN "numbers_12"."move_to" AND ("numbers_12"."move_from" - 1)) THEN ("numbers_12"."index" + 1) ELSE "numbers_12"."index" END) AS "index",
    "numbers_12"."length",
    "numbers_12"."original_index",
    ("numbers_12"."mix_index" + 1) AS "mix_index"
  FROM (
    SELECT
      "numbers_11"."value",
      "numbers_11"."length",
      "numbers_11"."original_index",
      "numbers_11"."mix_index",
      "numbers_11"."index",
      "numbers_11"."move_from",
      (((((("numbers_11"."move_from" + "numbers_11"."move_delta") - 1) % ("numbers_11"."length" - 1)) + ("numbers_11"."length" - 1)) % ("numbers_11"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "numbers_10"."value",
        "numbers_10"."length",
        "numbers_10"."original_index",
        "numbers_10"."mix_index",
        "numbers_10"."index",
        (min("numbers_10"."index") FILTER (WHERE ("numbers_10"."original_index" = "numbers_10"."mix_index")) OVER ()) AS "move_from",
        (min("numbers_10"."value") FILTER (WHERE ("numbers_10"."original_index" = "numbers_10"."mix_index")) OVER ()) AS "move_delta"
      FROM "__4" AS "numbers_10"
      WHERE ("numbers_10"."mix_index" <= "numbers_10"."length")
    ) AS "numbers_11"
  ) AS "numbers_12"
),
"__6" ("value", "index", "length", "original_index", "mix_index") AS (
  SELECT
    "__5"."value",
    "__5"."index",
    "__5"."length",
    "__5"."original_index",
    1 AS "mix_index"
  FROM "__4" AS "__5"
  WHERE ("__5"."mix_index" = ("__5"."length" + 1))
  UNION ALL
  SELECT
    "numbers_15"."value",
    (CASE WHEN ("numbers_15"."index" = "numbers_15"."move_from") THEN "numbers_15"."move_to" WHEN ("numbers_15"."index" BETWEEN ("numbers_15"."move_from" + 1) AND "numbers_15"."move_to") THEN ("numbers_15"."index" - 1) WHEN ("numbers_15"."index" BETWEEN "numbers_15"."move_to" AND ("numbers_15"."move_from" - 1)) THEN ("numbers_15"."index" + 1) ELSE "numbers_15"."index" END) AS "index",
    "numbers_15"."length",
    "numbers_15"."original_index",
    ("numbers_15"."mix_index" + 1) AS "mix_index"
  FROM (
    SELECT
      "numbers_14"."value",
      "numbers_14"."length",
      "numbers_14"."original_index",
      "numbers_14"."mix_index",
      "numbers_14"."index",
      "numbers_14"."move_from",
      (((((("numbers_14"."move_from" + "numbers_14"."move_delta") - 1) % ("numbers_14"."length" - 1)) + ("numbers_14"."length" - 1)) % ("numbers_14"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "numbers_13"."value",
        "numbers_13"."length",
        "numbers_13"."original_index",
        "numbers_13"."mix_index",
        "numbers_13"."index",
        (min("numbers_13"."index") FILTER (WHERE ("numbers_13"."original_index" = "numbers_13"."mix_index")) OVER ()) AS "move_from",
        (min("numbers_13"."value") FILTER (WHERE ("numbers_13"."original_index" = "numbers_13"."mix_index")) OVER ()) AS "move_delta"
      FROM "__6" AS "numbers_13"
      WHERE ("numbers_13"."mix_index" <= "numbers_13"."length")
    ) AS "numbers_14"
  ) AS "numbers_15"
),
"__8" ("value", "index", "length", "original_index", "mix_index") AS (
  SELECT
    "__7"."value",
    "__7"."index",
    "__7"."length",
    "__7"."original_index",
    1 AS "mix_index"
  FROM "__6" AS "__7"
  WHERE ("__7"."mix_index" = ("__7"."length" + 1))
  UNION ALL
  SELECT
    "numbers_18"."value",
    (CASE WHEN ("numbers_18"."index" = "numbers_18"."move_from") THEN "numbers_18"."move_to" WHEN ("numbers_18"."index" BETWEEN ("numbers_18"."move_from" + 1) AND "numbers_18"."move_to") THEN ("numbers_18"."index" - 1) WHEN ("numbers_18"."index" BETWEEN "numbers_18"."move_to" AND ("numbers_18"."move_from" - 1)) THEN ("numbers_18"."index" + 1) ELSE "numbers_18"."index" END) AS "index",
    "numbers_18"."length",
    "numbers_18"."original_index",
    ("numbers_18"."mix_index" + 1) AS "mix_index"
  FROM (
    SELECT
      "numbers_17"."value",
      "numbers_17"."length",
      "numbers_17"."original_index",
      "numbers_17"."mix_index",
      "numbers_17"."index",
      "numbers_17"."move_from",
      (((((("numbers_17"."move_from" + "numbers_17"."move_delta") - 1) % ("numbers_17"."length" - 1)) + ("numbers_17"."length" - 1)) % ("numbers_17"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "numbers_16"."value",
        "numbers_16"."length",
        "numbers_16"."original_index",
        "numbers_16"."mix_index",
        "numbers_16"."index",
        (min("numbers_16"."index") FILTER (WHERE ("numbers_16"."original_index" = "numbers_16"."mix_index")) OVER ()) AS "move_from",
        (min("numbers_16"."value") FILTER (WHERE ("numbers_16"."original_index" = "numbers_16"."mix_index")) OVER ()) AS "move_delta"
      FROM "__8" AS "numbers_16"
      WHERE ("numbers_16"."mix_index" <= "numbers_16"."length")
    ) AS "numbers_17"
  ) AS "numbers_18"
),
"__10" ("value", "index", "length", "original_index", "mix_index") AS (
  SELECT
    "__9"."value",
    "__9"."index",
    "__9"."length",
    "__9"."original_index",
    1 AS "mix_index"
  FROM "__8" AS "__9"
  WHERE ("__9"."mix_index" = ("__9"."length" + 1))
  UNION ALL
  SELECT
    "numbers_21"."value",
    (CASE WHEN ("numbers_21"."index" = "numbers_21"."move_from") THEN "numbers_21"."move_to" WHEN ("numbers_21"."index" BETWEEN ("numbers_21"."move_from" + 1) AND "numbers_21"."move_to") THEN ("numbers_21"."index" - 1) WHEN ("numbers_21"."index" BETWEEN "numbers_21"."move_to" AND ("numbers_21"."move_from" - 1)) THEN ("numbers_21"."index" + 1) ELSE "numbers_21"."index" END) AS "index",
    "numbers_21"."length",
    "numbers_21"."original_index",
    ("numbers_21"."mix_index" + 1) AS "mix_index"
  FROM (
    SELECT
      "numbers_20"."value",
      "numbers_20"."length",
      "numbers_20"."original_index",
      "numbers_20"."mix_index",
      "numbers_20"."index",
      "numbers_20"."move_from",
      (((((("numbers_20"."move_from" + "numbers_20"."move_delta") - 1) % ("numbers_20"."length" - 1)) + ("numbers_20"."length" - 1)) % ("numbers_20"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "numbers_19"."value",
        "numbers_19"."length",
        "numbers_19"."original_index",
        "numbers_19"."mix_index",
        "numbers_19"."index",
        (min("numbers_19"."index") FILTER (WHERE ("numbers_19"."original_index" = "numbers_19"."mix_index")) OVER ()) AS "move_from",
        (min("numbers_19"."value") FILTER (WHERE ("numbers_19"."original_index" = "numbers_19"."mix_index")) OVER ()) AS "move_delta"
      FROM "__10" AS "numbers_19"
      WHERE ("numbers_19"."mix_index" <= "numbers_19"."length")
    ) AS "numbers_20"
  ) AS "numbers_21"
),
"__12" ("value", "index", "length", "original_index", "mix_index") AS (
  SELECT
    "__11"."value",
    "__11"."index",
    "__11"."length",
    "__11"."original_index",
    1 AS "mix_index"
  FROM "__10" AS "__11"
  WHERE ("__11"."mix_index" = ("__11"."length" + 1))
  UNION ALL
  SELECT
    "numbers_24"."value",
    (CASE WHEN ("numbers_24"."index" = "numbers_24"."move_from") THEN "numbers_24"."move_to" WHEN ("numbers_24"."index" BETWEEN ("numbers_24"."move_from" + 1) AND "numbers_24"."move_to") THEN ("numbers_24"."index" - 1) WHEN ("numbers_24"."index" BETWEEN "numbers_24"."move_to" AND ("numbers_24"."move_from" - 1)) THEN ("numbers_24"."index" + 1) ELSE "numbers_24"."index" END) AS "index",
    "numbers_24"."length",
    "numbers_24"."original_index",
    ("numbers_24"."mix_index" + 1) AS "mix_index"
  FROM (
    SELECT
      "numbers_23"."value",
      "numbers_23"."length",
      "numbers_23"."original_index",
      "numbers_23"."mix_index",
      "numbers_23"."index",
      "numbers_23"."move_from",
      (((((("numbers_23"."move_from" + "numbers_23"."move_delta") - 1) % ("numbers_23"."length" - 1)) + ("numbers_23"."length" - 1)) % ("numbers_23"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "numbers_22"."value",
        "numbers_22"."length",
        "numbers_22"."original_index",
        "numbers_22"."mix_index",
        "numbers_22"."index",
        (min("numbers_22"."index") FILTER (WHERE ("numbers_22"."original_index" = "numbers_22"."mix_index")) OVER ()) AS "move_from",
        (min("numbers_22"."value") FILTER (WHERE ("numbers_22"."original_index" = "numbers_22"."mix_index")) OVER ()) AS "move_delta"
      FROM "__12" AS "numbers_22"
      WHERE ("numbers_22"."mix_index" <= "numbers_22"."length")
    ) AS "numbers_23"
  ) AS "numbers_24"
),
"__14" ("value", "index", "length", "original_index", "mix_index") AS (
  SELECT
    "__13"."value",
    "__13"."index",
    "__13"."length",
    "__13"."original_index",
    1 AS "mix_index"
  FROM "__12" AS "__13"
  WHERE ("__13"."mix_index" = ("__13"."length" + 1))
  UNION ALL
  SELECT
    "numbers_27"."value",
    (CASE WHEN ("numbers_27"."index" = "numbers_27"."move_from") THEN "numbers_27"."move_to" WHEN ("numbers_27"."index" BETWEEN ("numbers_27"."move_from" + 1) AND "numbers_27"."move_to") THEN ("numbers_27"."index" - 1) WHEN ("numbers_27"."index" BETWEEN "numbers_27"."move_to" AND ("numbers_27"."move_from" - 1)) THEN ("numbers_27"."index" + 1) ELSE "numbers_27"."index" END) AS "index",
    "numbers_27"."length",
    "numbers_27"."original_index",
    ("numbers_27"."mix_index" + 1) AS "mix_index"
  FROM (
    SELECT
      "numbers_26"."value",
      "numbers_26"."length",
      "numbers_26"."original_index",
      "numbers_26"."mix_index",
      "numbers_26"."index",
      "numbers_26"."move_from",
      (((((("numbers_26"."move_from" + "numbers_26"."move_delta") - 1) % ("numbers_26"."length" - 1)) + ("numbers_26"."length" - 1)) % ("numbers_26"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "numbers_25"."value",
        "numbers_25"."length",
        "numbers_25"."original_index",
        "numbers_25"."mix_index",
        "numbers_25"."index",
        (min("numbers_25"."index") FILTER (WHERE ("numbers_25"."original_index" = "numbers_25"."mix_index")) OVER ()) AS "move_from",
        (min("numbers_25"."value") FILTER (WHERE ("numbers_25"."original_index" = "numbers_25"."mix_index")) OVER ()) AS "move_delta"
      FROM "__14" AS "numbers_25"
      WHERE ("numbers_25"."mix_index" <= "numbers_25"."length")
    ) AS "numbers_26"
  ) AS "numbers_27"
),
"__16" ("value", "index", "length", "original_index", "mix_index") AS (
  SELECT
    "__15"."value",
    "__15"."index",
    "__15"."length",
    "__15"."original_index",
    1 AS "mix_index"
  FROM "__14" AS "__15"
  WHERE ("__15"."mix_index" = ("__15"."length" + 1))
  UNION ALL
  SELECT
    "numbers_30"."value",
    (CASE WHEN ("numbers_30"."index" = "numbers_30"."move_from") THEN "numbers_30"."move_to" WHEN ("numbers_30"."index" BETWEEN ("numbers_30"."move_from" + 1) AND "numbers_30"."move_to") THEN ("numbers_30"."index" - 1) WHEN ("numbers_30"."index" BETWEEN "numbers_30"."move_to" AND ("numbers_30"."move_from" - 1)) THEN ("numbers_30"."index" + 1) ELSE "numbers_30"."index" END) AS "index",
    "numbers_30"."length",
    "numbers_30"."original_index",
    ("numbers_30"."mix_index" + 1) AS "mix_index"
  FROM (
    SELECT
      "numbers_29"."value",
      "numbers_29"."length",
      "numbers_29"."original_index",
      "numbers_29"."mix_index",
      "numbers_29"."index",
      "numbers_29"."move_from",
      (((((("numbers_29"."move_from" + "numbers_29"."move_delta") - 1) % ("numbers_29"."length" - 1)) + ("numbers_29"."length" - 1)) % ("numbers_29"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "numbers_28"."value",
        "numbers_28"."length",
        "numbers_28"."original_index",
        "numbers_28"."mix_index",
        "numbers_28"."index",
        (min("numbers_28"."index") FILTER (WHERE ("numbers_28"."original_index" = "numbers_28"."mix_index")) OVER ()) AS "move_from",
        (min("numbers_28"."value") FILTER (WHERE ("numbers_28"."original_index" = "numbers_28"."mix_index")) OVER ()) AS "move_delta"
      FROM "__16" AS "numbers_28"
      WHERE ("numbers_28"."mix_index" <= "numbers_28"."length")
    ) AS "numbers_29"
  ) AS "numbers_30"
),
"__18" ("value", "index", "length", "original_index", "mix_index") AS (
  SELECT
    "__17"."value",
    "__17"."index",
    "__17"."length",
    "__17"."original_index",
    1 AS "mix_index"
  FROM "__16" AS "__17"
  WHERE ("__17"."mix_index" = ("__17"."length" + 1))
  UNION ALL
  SELECT
    "numbers_33"."value",
    (CASE WHEN ("numbers_33"."index" = "numbers_33"."move_from") THEN "numbers_33"."move_to" WHEN ("numbers_33"."index" BETWEEN ("numbers_33"."move_from" + 1) AND "numbers_33"."move_to") THEN ("numbers_33"."index" - 1) WHEN ("numbers_33"."index" BETWEEN "numbers_33"."move_to" AND ("numbers_33"."move_from" - 1)) THEN ("numbers_33"."index" + 1) ELSE "numbers_33"."index" END) AS "index",
    "numbers_33"."length",
    "numbers_33"."original_index",
    ("numbers_33"."mix_index" + 1) AS "mix_index"
  FROM (
    SELECT
      "numbers_32"."value",
      "numbers_32"."length",
      "numbers_32"."original_index",
      "numbers_32"."mix_index",
      "numbers_32"."index",
      "numbers_32"."move_from",
      (((((("numbers_32"."move_from" + "numbers_32"."move_delta") - 1) % ("numbers_32"."length" - 1)) + ("numbers_32"."length" - 1)) % ("numbers_32"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "numbers_31"."value",
        "numbers_31"."length",
        "numbers_31"."original_index",
        "numbers_31"."mix_index",
        "numbers_31"."index",
        (min("numbers_31"."index") FILTER (WHERE ("numbers_31"."original_index" = "numbers_31"."mix_index")) OVER ()) AS "move_from",
        (min("numbers_31"."value") FILTER (WHERE ("numbers_31"."original_index" = "numbers_31"."mix_index")) OVER ()) AS "move_delta"
      FROM "__18" AS "numbers_31"
      WHERE ("numbers_31"."mix_index" <= "numbers_31"."length")
    ) AS "numbers_32"
  ) AS "numbers_33"
),
"__20" ("value", "index", "length", "original_index", "mix_index") AS (
  SELECT
    "__19"."value",
    "__19"."index",
    "__19"."length",
    "__19"."original_index",
    1 AS "mix_index"
  FROM "__18" AS "__19"
  WHERE ("__19"."mix_index" = ("__19"."length" + 1))
  UNION ALL
  SELECT
    "numbers_36"."value",
    (CASE WHEN ("numbers_36"."index" = "numbers_36"."move_from") THEN "numbers_36"."move_to" WHEN ("numbers_36"."index" BETWEEN ("numbers_36"."move_from" + 1) AND "numbers_36"."move_to") THEN ("numbers_36"."index" - 1) WHEN ("numbers_36"."index" BETWEEN "numbers_36"."move_to" AND ("numbers_36"."move_from" - 1)) THEN ("numbers_36"."index" + 1) ELSE "numbers_36"."index" END) AS "index",
    "numbers_36"."length",
    "numbers_36"."original_index",
    ("numbers_36"."mix_index" + 1) AS "mix_index"
  FROM (
    SELECT
      "numbers_35"."value",
      "numbers_35"."length",
      "numbers_35"."original_index",
      "numbers_35"."mix_index",
      "numbers_35"."index",
      "numbers_35"."move_from",
      (((((("numbers_35"."move_from" + "numbers_35"."move_delta") - 1) % ("numbers_35"."length" - 1)) + ("numbers_35"."length" - 1)) % ("numbers_35"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "numbers_34"."value",
        "numbers_34"."length",
        "numbers_34"."original_index",
        "numbers_34"."mix_index",
        "numbers_34"."index",
        (min("numbers_34"."index") FILTER (WHERE ("numbers_34"."original_index" = "numbers_34"."mix_index")) OVER ()) AS "move_from",
        (min("numbers_34"."value") FILTER (WHERE ("numbers_34"."original_index" = "numbers_34"."mix_index")) OVER ()) AS "move_delta"
      FROM "__20" AS "numbers_34"
      WHERE ("numbers_34"."mix_index" <= "numbers_34"."length")
    ) AS "numbers_35"
  ) AS "numbers_36"
),
"__22" ("value", "index", "length", "mix_index", "original_index") AS (
  SELECT
    "__21"."value",
    "__21"."index",
    "__21"."length",
    1 AS "mix_index",
    "__21"."original_index"
  FROM "__20" AS "__21"
  WHERE ("__21"."mix_index" = ("__21"."length" + 1))
  UNION ALL
  SELECT
    "numbers_39"."value",
    (CASE WHEN ("numbers_39"."index" = "numbers_39"."move_from") THEN "numbers_39"."move_to" WHEN ("numbers_39"."index" BETWEEN ("numbers_39"."move_from" + 1) AND "numbers_39"."move_to") THEN ("numbers_39"."index" - 1) WHEN ("numbers_39"."index" BETWEEN "numbers_39"."move_to" AND ("numbers_39"."move_from" - 1)) THEN ("numbers_39"."index" + 1) ELSE "numbers_39"."index" END) AS "index",
    "numbers_39"."length",
    ("numbers_39"."mix_index" + 1) AS "mix_index",
    "numbers_39"."original_index"
  FROM (
    SELECT
      "numbers_38"."value",
      "numbers_38"."length",
      "numbers_38"."original_index",
      "numbers_38"."mix_index",
      "numbers_38"."index",
      "numbers_38"."move_from",
      (((((("numbers_38"."move_from" + "numbers_38"."move_delta") - 1) % ("numbers_38"."length" - 1)) + ("numbers_38"."length" - 1)) % ("numbers_38"."length" - 1)) + 1) AS "move_to"
    FROM (
      SELECT
        "numbers_37"."value",
        "numbers_37"."length",
        "numbers_37"."original_index",
        "numbers_37"."mix_index",
        "numbers_37"."index",
        (min("numbers_37"."index") FILTER (WHERE ("numbers_37"."original_index" = "numbers_37"."mix_index")) OVER ()) AS "move_from",
        (min("numbers_37"."value") FILTER (WHERE ("numbers_37"."original_index" = "numbers_37"."mix_index")) OVER ()) AS "move_delta"
      FROM "__22" AS "numbers_37"
      WHERE ("numbers_37"."mix_index" <= "numbers_37"."length")
    ) AS "numbers_38"
  ) AS "numbers_39"
)
SELECT
  "numbers_8"."part1",
  "numbers_41"."part2"
FROM (
  SELECT (sum("numbers_7"."value") FILTER (WHERE ("numbers_7"."index" IN ((((((("numbers_7"."index0" + 1000) - 1) % "numbers_7"."length") + "numbers_7"."length") % "numbers_7"."length") + 1), (((((("numbers_7"."index0" + 2000) - 1) % "numbers_7"."length") + "numbers_7"."length") % "numbers_7"."length") + 1), (((((("numbers_7"."index0" + 3000) - 1) % "numbers_7"."length") + "numbers_7"."length") % "numbers_7"."length") + 1))))) AS "part1"
  FROM (
    SELECT
      "__3"."value",
      "__3"."index",
      (min("__3"."index") FILTER (WHERE ("__3"."value" = 0)) OVER ()) AS "index0",
      "__3"."length"
    FROM "__2" AS "__3"
    WHERE ("__3"."mix_index" = ("__3"."length" + 1))
  ) AS "numbers_7"
) AS "numbers_8"
CROSS JOIN (
  SELECT (sum("numbers_40"."value") FILTER (WHERE ("numbers_40"."index" IN ((((((("numbers_40"."index0" + 1000) - 1) % "numbers_40"."length") + "numbers_40"."length") % "numbers_40"."length") + 1), (((((("numbers_40"."index0" + 2000) - 1) % "numbers_40"."length") + "numbers_40"."length") % "numbers_40"."length") + 1), (((((("numbers_40"."index0" + 3000) - 1) % "numbers_40"."length") + "numbers_40"."length") % "numbers_40"."length") + 1))))) AS "part2"
  FROM (
    SELECT
      "__23"."value",
      "__23"."index",
      (min("__23"."index") FILTER (WHERE ("__23"."value" = 0)) OVER ()) AS "index0",
      "__23"."length"
    FROM "__22" AS "__23"
    WHERE ("__23"."mix_index" = ("__23"."length" + 1))
  ) AS "numbers_40"
) AS "numbers_41"
