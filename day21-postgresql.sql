WITH RECURSIVE "jobs_1" ("val", "var", "op", "ref2", "ref1") AS (
  SELECT
    ("regexp_matches_1"."captures"[2]::bigint) AS "val",
    "regexp_matches_1"."captures"[1] AS "var",
    "regexp_matches_1"."captures"[4] AS "op",
    "regexp_matches_1"."captures"[5] AS "ref2",
    "regexp_matches_1"."captures"[3] AS "ref1"
  FROM regexp_matches($1, '(\w+): (?:(\d+)|(\w+) (.) (\w+))', 'g') AS "regexp_matches_1" ("captures")
),
"__1" ("val", "var", "op", "ref2", "ref1") AS (
  SELECT
    "jobs_2"."val",
    "jobs_2"."var",
    "jobs_2"."op",
    "jobs_2"."ref2",
    "jobs_2"."ref1"
  FROM "jobs_1" AS "jobs_2"
  UNION ALL
  SELECT
    coalesce("__5"."val", (CASE WHEN ("__5"."op" = '+') THEN ("__5"."ref1_val" + "__5"."ref2_val") WHEN ("__5"."op" = '-') THEN ("__5"."ref1_val" - "__5"."ref2_val") WHEN ("__5"."op" = '*') THEN ("__5"."ref1_val" * "__5"."ref2_val") WHEN ("__5"."op" = '/') THEN ("__5"."ref1_val" / "__5"."ref2_val") END)) AS "val",
    "__5"."var",
    "__5"."op",
    "__5"."ref2",
    "__5"."ref1"
  FROM (
    SELECT
      "__4"."var",
      "__4"."op",
      "__4"."ref2",
      "__4"."ref1",
      "__4"."val",
      "__4"."ref1_val",
      (min("__4"."val") OVER (PARTITION BY (CASE WHEN ("__4"."val" IS NULL) THEN "__4"."ref2" ELSE "__4"."var" END))) AS "ref2_val"
    FROM (
      SELECT
        "__3"."var",
        "__3"."op",
        "__3"."ref2",
        "__3"."ref1",
        "__3"."val",
        (min("__3"."val") OVER (PARTITION BY (CASE WHEN ("__3"."val" IS NULL) THEN "__3"."ref1" ELSE "__3"."var" END))) AS "ref1_val"
      FROM (
        SELECT
          "__2"."var",
          "__2"."op",
          "__2"."ref2",
          "__2"."ref1",
          "__2"."val",
          (min("__2"."val") FILTER (WHERE ("__2"."var" = 'root')) OVER ()) AS "min"
        FROM "__1" AS "__2"
      ) AS "__3"
      WHERE ("__3"."min" IS NULL)
    ) AS "__4"
  ) AS "__5"
),
"__8" ("a", "var", "b", "c", "d", "ref1", "ref2", "op") AS (
  SELECT
    ((CASE WHEN ("jobs_3"."var" = 'humn') THEN 1 WHEN ("jobs_3"."val" IS NOT NULL) THEN 0 END)::bigint) AS "a",
    "jobs_3"."var",
    ((CASE WHEN ("jobs_3"."var" = 'humn') THEN 0 WHEN ("jobs_3"."val" IS NOT NULL) THEN "jobs_3"."val" END)::bigint) AS "b",
    ((CASE WHEN ("jobs_3"."var" = 'humn') THEN 0 WHEN ("jobs_3"."val" IS NOT NULL) THEN 0 END)::bigint) AS "c",
    ((CASE WHEN ("jobs_3"."var" = 'humn') THEN 1 WHEN ("jobs_3"."val" IS NOT NULL) THEN 1 END)::bigint) AS "d",
    "jobs_3"."ref1",
    "jobs_3"."ref2",
    "jobs_3"."op"
  FROM "jobs_1" AS "jobs_3"
  UNION ALL
  SELECT
    ("__14"."a" / "__14"."g") AS "a",
    "__14"."var",
    ("__14"."b" / "__14"."g") AS "b",
    ("__14"."c" / "__14"."g") AS "c",
    ("__14"."d" / "__14"."g") AS "d",
    "__14"."ref1",
    "__14"."ref2",
    "__14"."op"
  FROM (
    SELECT
      "__13"."var",
      "__13"."ref1",
      "__13"."ref2",
      "__13"."op",
      "__13"."a",
      gcd(gcd(gcd("__13"."a", "__13"."b"), "__13"."c"), "__13"."d") AS "g",
      "__13"."b",
      "__13"."c",
      "__13"."d"
    FROM (
      SELECT
        "__12"."var",
        "__12"."ref1",
        "__12"."ref2",
        "__12"."op",
        coalesce("__12"."a", (CASE WHEN ("__12"."op" = '+') THEN (("__12"."a1" * "__12"."d2") + ("__12"."b1" * "__12"."c2") + ("__12"."a2" * "__12"."d1") + ("__12"."b2" * "__12"."c1")) WHEN ("__12"."op" = '-') THEN (((("__12"."a1" * "__12"."d2") + ("__12"."b1" * "__12"."c2")) - ("__12"."a2" * "__12"."d1")) - ("__12"."b2" * "__12"."c1")) WHEN ("__12"."op" = '*') THEN (("__12"."a1" * "__12"."b2") + ("__12"."b1" * "__12"."a2")) WHEN ("__12"."op" = '/') THEN (("__12"."a1" * "__12"."d2") + ("__12"."b1" * "__12"."c2")) END)) AS "a",
        coalesce("__12"."b", (CASE WHEN ("__12"."op" = '+') THEN (("__12"."b1" * "__12"."d2") + ("__12"."b2" * "__12"."d1")) WHEN ("__12"."op" = '-') THEN (("__12"."b1" * "__12"."d2") - ("__12"."b2" * "__12"."d1")) WHEN ("__12"."op" = '*') THEN ("__12"."b1" * "__12"."b2") WHEN ("__12"."op" = '/') THEN ("__12"."b1" * "__12"."d2") END)) AS "b",
        coalesce("__12"."c", (CASE WHEN (("__12"."op" = '+') OR ("__12"."op" = '-') OR ("__12"."op" = '*')) THEN (("__12"."c1" * "__12"."d2") + ("__12"."d1" * "__12"."c2")) WHEN ("__12"."op" = '/') THEN (("__12"."c1" * "__12"."b2") + ("__12"."d1" * "__12"."a2")) END)) AS "c",
        coalesce("__12"."d", (CASE WHEN (("__12"."op" = '+') OR ("__12"."op" = '-') OR ("__12"."op" = '*')) THEN ("__12"."d1" * "__12"."d2") WHEN ("__12"."op" = '/') THEN ("__12"."d1" * "__12"."b2") END)) AS "d"
      FROM (
        SELECT
          "__11"."var",
          "__11"."ref1",
          "__11"."ref2",
          "__11"."op",
          "__11"."a",
          "__11"."a1",
          (min("__11"."d") OVER (PARTITION BY (CASE WHEN ("__11"."a" IS NULL) THEN "__11"."ref2" ELSE "__11"."var" END))) AS "d2",
          "__11"."b1",
          (min("__11"."c") OVER (PARTITION BY (CASE WHEN ("__11"."a" IS NULL) THEN "__11"."ref2" ELSE "__11"."var" END))) AS "c2",
          (min("__11"."a") OVER (PARTITION BY (CASE WHEN ("__11"."a" IS NULL) THEN "__11"."ref2" ELSE "__11"."var" END))) AS "a2",
          "__11"."d1",
          (min("__11"."b") OVER (PARTITION BY (CASE WHEN ("__11"."a" IS NULL) THEN "__11"."ref2" ELSE "__11"."var" END))) AS "b2",
          "__11"."c1",
          "__11"."b",
          "__11"."c",
          "__11"."d"
        FROM (
          SELECT
            "__10"."var",
            "__10"."ref1",
            "__10"."ref2",
            "__10"."op",
            "__10"."a",
            (min("__10"."a") OVER (PARTITION BY (CASE WHEN ("__10"."a" IS NULL) THEN "__10"."ref1" ELSE "__10"."var" END))) AS "a1",
            (min("__10"."b") OVER (PARTITION BY (CASE WHEN ("__10"."a" IS NULL) THEN "__10"."ref1" ELSE "__10"."var" END))) AS "b1",
            (min("__10"."d") OVER (PARTITION BY (CASE WHEN ("__10"."a" IS NULL) THEN "__10"."ref1" ELSE "__10"."var" END))) AS "d1",
            (min("__10"."c") OVER (PARTITION BY (CASE WHEN ("__10"."a" IS NULL) THEN "__10"."ref1" ELSE "__10"."var" END))) AS "c1",
            "__10"."b",
            "__10"."c",
            "__10"."d"
          FROM (
            SELECT
              "__9"."var",
              "__9"."ref1",
              "__9"."ref2",
              "__9"."op",
              "__9"."a",
              "__9"."b",
              "__9"."c",
              "__9"."d",
              (min("__9"."a") FILTER (WHERE ("__9"."var" = 'root')) OVER ()) AS "min"
            FROM "__8" AS "__9"
          ) AS "__10"
          WHERE ("__10"."min" IS NULL)
        ) AS "__11"
      ) AS "__12"
    ) AS "__13"
  ) AS "__14"
)
SELECT
  "__7"."part1",
  "__18"."part2"
FROM (
  SELECT (min("__6"."val") FILTER (WHERE ("__6"."var" = 'root'))) AS "part1"
  FROM "__1" AS "__6"
) AS "__7"
CROSS JOIN (
  SELECT ((- (("__17"."b1" * "__17"."d2") - ("__17"."b2" * "__17"."d1"))) / (((("__17"."a1" * "__17"."d2") + ("__17"."b1" * "__17"."c2")) - ("__17"."a2" * "__17"."d1")) - ("__17"."b2" * "__17"."c1"))) AS "part2"
  FROM (
    SELECT
      (min("__16"."b") FILTER (WHERE ("__16"."var" = "__16"."root_ref1"))) AS "b1",
      (min("__16"."d") FILTER (WHERE ("__16"."var" = "__16"."root_ref2"))) AS "d2",
      (min("__16"."b") FILTER (WHERE ("__16"."var" = "__16"."root_ref2"))) AS "b2",
      (min("__16"."d") FILTER (WHERE ("__16"."var" = "__16"."root_ref1"))) AS "d1",
      (min("__16"."a") FILTER (WHERE ("__16"."var" = "__16"."root_ref1"))) AS "a1",
      (min("__16"."c") FILTER (WHERE ("__16"."var" = "__16"."root_ref2"))) AS "c2",
      (min("__16"."a") FILTER (WHERE ("__16"."var" = "__16"."root_ref2"))) AS "a2",
      (min("__16"."c") FILTER (WHERE ("__16"."var" = "__16"."root_ref1"))) AS "c1"
    FROM (
      SELECT
        "__15"."a",
        "__15"."var",
        (min("__15"."ref1") FILTER (WHERE ("__15"."var" = 'root')) OVER ()) AS "root_ref1",
        "__15"."b",
        "__15"."c",
        "__15"."d",
        (min("__15"."ref2") FILTER (WHERE ("__15"."var" = 'root')) OVER ()) AS "root_ref2"
      FROM "__8" AS "__15"
    ) AS "__16"
  ) AS "__17"
) AS "__18"
