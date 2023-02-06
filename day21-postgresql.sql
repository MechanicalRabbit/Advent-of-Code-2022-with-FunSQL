WITH RECURSIVE "jobs_1" ("var", "ref1", "ref2", "op", "val") AS (
  SELECT
    "regexp_matches_1"."captures"[1] AS "var",
    "regexp_matches_1"."captures"[3] AS "ref1",
    "regexp_matches_1"."captures"[5] AS "ref2",
    "regexp_matches_1"."captures"[4] AS "op",
    ("regexp_matches_1"."captures"[2]::bigint) AS "val"
  FROM regexp_matches($1, '(\w+): (?:(\d+)|(\w+) (.) (\w+))', 'g') AS "regexp_matches_1" ("captures")
),
"__1" ("val", "var", "ref2", "ref1", "op") AS (
  SELECT
    "jobs_2"."val",
    "jobs_2"."var",
    "jobs_2"."ref2",
    "jobs_2"."ref1",
    "jobs_2"."op"
  FROM "jobs_1" AS "jobs_2"
  UNION ALL
  SELECT
    coalesce("jobs_6"."val", (CASE WHEN ("jobs_6"."op" = '+') THEN ("jobs_6"."ref1_val" + "jobs_6"."ref2_val") WHEN ("jobs_6"."op" = '-') THEN ("jobs_6"."ref1_val" - "jobs_6"."ref2_val") WHEN ("jobs_6"."op" = '*') THEN ("jobs_6"."ref1_val" * "jobs_6"."ref2_val") WHEN ("jobs_6"."op" = '/') THEN ("jobs_6"."ref1_val" / "jobs_6"."ref2_val") END)) AS "val",
    "jobs_6"."var",
    "jobs_6"."ref2",
    "jobs_6"."ref1",
    "jobs_6"."op"
  FROM (
    SELECT
      "jobs_5"."var",
      "jobs_5"."ref2",
      "jobs_5"."ref1",
      "jobs_5"."op",
      "jobs_5"."val",
      "jobs_5"."ref1_val",
      (min("jobs_5"."val") OVER (PARTITION BY (CASE WHEN ("jobs_5"."val" IS NULL) THEN "jobs_5"."ref2" ELSE "jobs_5"."var" END))) AS "ref2_val"
    FROM (
      SELECT
        "jobs_4"."var",
        "jobs_4"."ref2",
        "jobs_4"."ref1",
        "jobs_4"."op",
        "jobs_4"."val",
        (min("jobs_4"."val") OVER (PARTITION BY (CASE WHEN ("jobs_4"."val" IS NULL) THEN "jobs_4"."ref1" ELSE "jobs_4"."var" END))) AS "ref1_val"
      FROM (
        SELECT
          "jobs_3"."var",
          "jobs_3"."ref2",
          "jobs_3"."ref1",
          "jobs_3"."op",
          "jobs_3"."val",
          (min("jobs_3"."val") FILTER (WHERE ("jobs_3"."var" = 'root')) OVER ()) AS "min"
        FROM "__1" AS "jobs_3"
      ) AS "jobs_4"
      WHERE ("jobs_4"."min" IS NULL)
    ) AS "jobs_5"
  ) AS "jobs_6"
),
"__3" ("b", "var", "d", "a", "c", "ref1", "ref2", "op") AS (
  SELECT
    ((CASE WHEN ("jobs_8"."var" = 'humn') THEN 0 WHEN ("jobs_8"."val" IS NOT NULL) THEN "jobs_8"."val" END)::bigint) AS "b",
    "jobs_8"."var",
    ((CASE WHEN ("jobs_8"."var" = 'humn') THEN 1 WHEN ("jobs_8"."val" IS NOT NULL) THEN 1 END)::bigint) AS "d",
    ((CASE WHEN ("jobs_8"."var" = 'humn') THEN 1 WHEN ("jobs_8"."val" IS NOT NULL) THEN 0 END)::bigint) AS "a",
    ((CASE WHEN ("jobs_8"."var" = 'humn') THEN 0 WHEN ("jobs_8"."val" IS NOT NULL) THEN 0 END)::bigint) AS "c",
    "jobs_8"."ref1",
    "jobs_8"."ref2",
    "jobs_8"."op"
  FROM "jobs_1" AS "jobs_8"
  UNION ALL
  SELECT
    ("jobs_14"."b" / "jobs_14"."g") AS "b",
    "jobs_14"."var",
    ("jobs_14"."d" / "jobs_14"."g") AS "d",
    ("jobs_14"."a" / "jobs_14"."g") AS "a",
    ("jobs_14"."c" / "jobs_14"."g") AS "c",
    "jobs_14"."ref1",
    "jobs_14"."ref2",
    "jobs_14"."op"
  FROM (
    SELECT
      "jobs_13"."var",
      "jobs_13"."ref1",
      "jobs_13"."ref2",
      "jobs_13"."op",
      "jobs_13"."b",
      gcd(gcd(gcd("jobs_13"."a", "jobs_13"."b"), "jobs_13"."c"), "jobs_13"."d") AS "g",
      "jobs_13"."d",
      "jobs_13"."a",
      "jobs_13"."c"
    FROM (
      SELECT
        "jobs_12"."var",
        "jobs_12"."ref1",
        "jobs_12"."ref2",
        "jobs_12"."op",
        coalesce("jobs_12"."b", (CASE WHEN ("jobs_12"."op" = '+') THEN (("jobs_12"."b1" * "jobs_12"."d2") + ("jobs_12"."b2" * "jobs_12"."d1")) WHEN ("jobs_12"."op" = '-') THEN (("jobs_12"."b1" * "jobs_12"."d2") - ("jobs_12"."b2" * "jobs_12"."d1")) WHEN ("jobs_12"."op" = '*') THEN ("jobs_12"."b1" * "jobs_12"."b2") WHEN ("jobs_12"."op" = '/') THEN ("jobs_12"."b1" * "jobs_12"."d2") END)) AS "b",
        coalesce("jobs_12"."d", (CASE WHEN (("jobs_12"."op" = '+') OR ("jobs_12"."op" = '-') OR ("jobs_12"."op" = '*')) THEN ("jobs_12"."d1" * "jobs_12"."d2") WHEN ("jobs_12"."op" = '/') THEN ("jobs_12"."d1" * "jobs_12"."b2") END)) AS "d",
        coalesce("jobs_12"."a", (CASE WHEN ("jobs_12"."op" = '+') THEN (("jobs_12"."a1" * "jobs_12"."d2") + ("jobs_12"."b1" * "jobs_12"."c2") + ("jobs_12"."a2" * "jobs_12"."d1") + ("jobs_12"."b2" * "jobs_12"."c1")) WHEN ("jobs_12"."op" = '-') THEN (((("jobs_12"."a1" * "jobs_12"."d2") + ("jobs_12"."b1" * "jobs_12"."c2")) - ("jobs_12"."a2" * "jobs_12"."d1")) - ("jobs_12"."b2" * "jobs_12"."c1")) WHEN ("jobs_12"."op" = '*') THEN (("jobs_12"."a1" * "jobs_12"."b2") + ("jobs_12"."b1" * "jobs_12"."a2")) WHEN ("jobs_12"."op" = '/') THEN (("jobs_12"."a1" * "jobs_12"."d2") + ("jobs_12"."b1" * "jobs_12"."c2")) END)) AS "a",
        coalesce("jobs_12"."c", (CASE WHEN (("jobs_12"."op" = '+') OR ("jobs_12"."op" = '-') OR ("jobs_12"."op" = '*')) THEN (("jobs_12"."c1" * "jobs_12"."d2") + ("jobs_12"."d1" * "jobs_12"."c2")) WHEN ("jobs_12"."op" = '/') THEN (("jobs_12"."c1" * "jobs_12"."b2") + ("jobs_12"."d1" * "jobs_12"."a2")) END)) AS "c"
      FROM (
        SELECT
          "jobs_11"."var",
          "jobs_11"."ref1",
          "jobs_11"."ref2",
          "jobs_11"."op",
          "jobs_11"."b",
          "jobs_11"."b1",
          (min("jobs_11"."d") OVER (PARTITION BY (CASE WHEN ("jobs_11"."a" IS NULL) THEN "jobs_11"."ref2" ELSE "jobs_11"."var" END))) AS "d2",
          (min("jobs_11"."b") OVER (PARTITION BY (CASE WHEN ("jobs_11"."a" IS NULL) THEN "jobs_11"."ref2" ELSE "jobs_11"."var" END))) AS "b2",
          "jobs_11"."d1",
          "jobs_11"."d",
          "jobs_11"."a",
          "jobs_11"."a1",
          (min("jobs_11"."c") OVER (PARTITION BY (CASE WHEN ("jobs_11"."a" IS NULL) THEN "jobs_11"."ref2" ELSE "jobs_11"."var" END))) AS "c2",
          (min("jobs_11"."a") OVER (PARTITION BY (CASE WHEN ("jobs_11"."a" IS NULL) THEN "jobs_11"."ref2" ELSE "jobs_11"."var" END))) AS "a2",
          "jobs_11"."c1",
          "jobs_11"."c"
        FROM (
          SELECT
            "jobs_10"."var",
            "jobs_10"."ref1",
            "jobs_10"."ref2",
            "jobs_10"."op",
            "jobs_10"."b",
            (min("jobs_10"."b") OVER (PARTITION BY (CASE WHEN ("jobs_10"."a" IS NULL) THEN "jobs_10"."ref1" ELSE "jobs_10"."var" END))) AS "b1",
            (min("jobs_10"."d") OVER (PARTITION BY (CASE WHEN ("jobs_10"."a" IS NULL) THEN "jobs_10"."ref1" ELSE "jobs_10"."var" END))) AS "d1",
            "jobs_10"."d",
            "jobs_10"."a",
            (min("jobs_10"."a") OVER (PARTITION BY (CASE WHEN ("jobs_10"."a" IS NULL) THEN "jobs_10"."ref1" ELSE "jobs_10"."var" END))) AS "a1",
            (min("jobs_10"."c") OVER (PARTITION BY (CASE WHEN ("jobs_10"."a" IS NULL) THEN "jobs_10"."ref1" ELSE "jobs_10"."var" END))) AS "c1",
            "jobs_10"."c"
          FROM (
            SELECT
              "jobs_9"."var",
              "jobs_9"."ref1",
              "jobs_9"."ref2",
              "jobs_9"."op",
              "jobs_9"."b",
              "jobs_9"."d",
              "jobs_9"."a",
              "jobs_9"."c",
              (min("jobs_9"."a") FILTER (WHERE ("jobs_9"."var" = 'root')) OVER ()) AS "min"
            FROM "__3" AS "jobs_9"
          ) AS "jobs_10"
          WHERE ("jobs_10"."min" IS NULL)
        ) AS "jobs_11"
      ) AS "jobs_12"
    ) AS "jobs_13"
  ) AS "jobs_14"
)
SELECT
  "jobs_7"."part1",
  "jobs_17"."part2"
FROM (
  SELECT (min("__2"."val") FILTER (WHERE ("__2"."var" = 'root'))) AS "part1"
  FROM "__1" AS "__2"
) AS "jobs_7"
CROSS JOIN (
  SELECT ((- (("jobs_16"."b1" * "jobs_16"."d2") - ("jobs_16"."b2" * "jobs_16"."d1"))) / (((("jobs_16"."a1" * "jobs_16"."d2") + ("jobs_16"."b1" * "jobs_16"."c2")) - ("jobs_16"."a2" * "jobs_16"."d1")) - ("jobs_16"."b2" * "jobs_16"."c1"))) AS "part2"
  FROM (
    SELECT
      (min("jobs_15"."b") FILTER (WHERE ("jobs_15"."var" = "jobs_15"."root_ref1"))) AS "b1",
      (min("jobs_15"."d") FILTER (WHERE ("jobs_15"."var" = "jobs_15"."root_ref2"))) AS "d2",
      (min("jobs_15"."b") FILTER (WHERE ("jobs_15"."var" = "jobs_15"."root_ref2"))) AS "b2",
      (min("jobs_15"."d") FILTER (WHERE ("jobs_15"."var" = "jobs_15"."root_ref1"))) AS "d1",
      (min("jobs_15"."a") FILTER (WHERE ("jobs_15"."var" = "jobs_15"."root_ref1"))) AS "a1",
      (min("jobs_15"."c") FILTER (WHERE ("jobs_15"."var" = "jobs_15"."root_ref2"))) AS "c2",
      (min("jobs_15"."a") FILTER (WHERE ("jobs_15"."var" = "jobs_15"."root_ref2"))) AS "a2",
      (min("jobs_15"."c") FILTER (WHERE ("jobs_15"."var" = "jobs_15"."root_ref1"))) AS "c1"
    FROM (
      SELECT
        "__4"."b",
        "__4"."var",
        (min("__4"."ref1") FILTER (WHERE ("__4"."var" = 'root')) OVER ()) AS "root_ref1",
        "__4"."d",
        (min("__4"."ref2") FILTER (WHERE ("__4"."var" = 'root')) OVER ()) AS "root_ref2",
        "__4"."a",
        "__4"."c"
      FROM "__3" AS "__4"
    ) AS "jobs_15"
  ) AS "jobs_16"
) AS "jobs_17"
