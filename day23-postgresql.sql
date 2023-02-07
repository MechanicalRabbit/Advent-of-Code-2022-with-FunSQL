WITH RECURSIVE "elves_1" ("x", "y") AS (
  SELECT
    "__2"."x",
    "__1"."y"
  FROM string_to_table($1, '
') WITH ORDINALITY AS "__1" ("line", "y")
  CROSS JOIN string_to_table("__1"."line", NULL) WITH ORDINALITY AS "__2" ("char", "x")
  WHERE ("__2"."char" = '#')
),
"__3" ("x", "y", "t") AS (
  SELECT
    "elves_2"."x",
    "elves_2"."y",
    1 AS "t"
  FROM "elves_1" AS "elves_2"
  UNION ALL
  SELECT
    (CASE WHEN (NOT "elves_11"."blocked") THEN "elves_11"."next_x" ELSE "elves_11"."x" END) AS "x",
    (CASE WHEN (NOT "elves_11"."blocked") THEN "elves_11"."next_y" ELSE "elves_11"."y" END) AS "y",
    ("elves_11"."t" + 1) AS "t"
  FROM (
    SELECT
      ((count(*) OVER (PARTITION BY "elves_10"."next_x", "elves_10"."next_y")) > 1) AS "blocked",
      "elves_10"."next_x",
      "elves_10"."x",
      "elves_10"."next_y",
      "elves_10"."y",
      "elves_10"."t"
    FROM (
      SELECT
        (CASE WHEN (("elves_9"."t" % 4) = 1) THEN coalesce("elves_9"."xn", "elves_9"."xs", "elves_9"."xw", "elves_9"."xe", "elves_9"."x") WHEN (("elves_9"."t" % 4) = 2) THEN coalesce("elves_9"."xs", "elves_9"."xw", "elves_9"."xe", "elves_9"."xn", "elves_9"."x") WHEN (("elves_9"."t" % 4) = 3) THEN coalesce("elves_9"."xw", "elves_9"."xe", "elves_9"."xn", "elves_9"."xs", "elves_9"."x") ELSE coalesce("elves_9"."xe", "elves_9"."xn", "elves_9"."xs", "elves_9"."xw", "elves_9"."x") END) AS "next_x",
        "elves_9"."x",
        (CASE WHEN (("elves_9"."t" % 4) = 1) THEN coalesce("elves_9"."yn", "elves_9"."ys", "elves_9"."yw", "elves_9"."ye", "elves_9"."y") WHEN (("elves_9"."t" % 4) = 2) THEN coalesce("elves_9"."ys", "elves_9"."yw", "elves_9"."ye", "elves_9"."yn", "elves_9"."y") WHEN (("elves_9"."t" % 4) = 3) THEN coalesce("elves_9"."yw", "elves_9"."ye", "elves_9"."yn", "elves_9"."ys", "elves_9"."y") ELSE coalesce("elves_9"."ye", "elves_9"."yn", "elves_9"."ys", "elves_9"."yw", "elves_9"."y") END) AS "next_y",
        "elves_9"."y",
        "elves_9"."t"
      FROM (
        SELECT
          "elves_8"."x",
          "elves_8"."y",
          "elves_8"."t",
          (CASE WHEN ("elves_8"."can_move_n" AND (NOT "elves_8"."alone")) THEN "elves_8"."x" END) AS "xn",
          (CASE WHEN ("elves_8"."can_move_s" AND (NOT "elves_8"."alone")) THEN "elves_8"."x" END) AS "xs",
          (CASE WHEN ("elves_8"."can_move_w" AND (NOT "elves_8"."alone")) THEN ("elves_8"."x" - 1) END) AS "xw",
          (CASE WHEN ("elves_8"."can_move_e" AND (NOT "elves_8"."alone")) THEN ("elves_8"."x" + 1) END) AS "xe",
          (CASE WHEN ("elves_8"."can_move_n" AND (NOT "elves_8"."alone")) THEN ("elves_8"."y" - 1) END) AS "yn",
          (CASE WHEN ("elves_8"."can_move_s" AND (NOT "elves_8"."alone")) THEN ("elves_8"."y" + 1) END) AS "ys",
          (CASE WHEN ("elves_8"."can_move_w" AND (NOT "elves_8"."alone")) THEN "elves_8"."y" END) AS "yw",
          (CASE WHEN ("elves_8"."can_move_e" AND (NOT "elves_8"."alone")) THEN "elves_8"."y" END) AS "ye"
        FROM (
          SELECT
            "elves_7"."x",
            "elves_7"."y",
            "elves_7"."t",
            ("elves_7"."free_n" AND "elves_7"."free_ne" AND "elves_7"."free_nw") AS "can_move_n",
            ("elves_7"."free_n" AND "elves_7"."free_ne" AND "elves_7"."free_e" AND "elves_7"."free_se" AND "elves_7"."free_s" AND "elves_7"."free_sw" AND "elves_7"."free_w" AND "elves_7"."free_nw") AS "alone",
            ("elves_7"."free_s" AND "elves_7"."free_se" AND "elves_7"."free_sw") AS "can_move_s",
            ("elves_7"."free_w" AND "elves_7"."free_nw" AND "elves_7"."free_sw") AS "can_move_w",
            ("elves_7"."free_e" AND "elves_7"."free_ne" AND "elves_7"."free_se") AS "can_move_e"
          FROM (
            SELECT
              "elves_6"."x",
              "elves_6"."y",
              "elves_6"."t",
              "elves_6"."free_n",
              (coalesce((lead(("elves_6"."x" - "elves_6"."y")) OVER (PARTITION BY ("elves_6"."x" + "elves_6"."y") ORDER BY ("elves_6"."x" - "elves_6"."y"))), ("elves_6"."x" - "elves_6"."y")) <> (("elves_6"."x" - "elves_6"."y") + 2)) AS "free_ne",
              "elves_6"."free_nw",
              "elves_6"."free_e",
              "elves_6"."free_se",
              "elves_6"."free_s",
              (coalesce((lag(("elves_6"."x" - "elves_6"."y")) OVER (PARTITION BY ("elves_6"."x" + "elves_6"."y") ORDER BY ("elves_6"."x" - "elves_6"."y"))), ("elves_6"."x" - "elves_6"."y")) <> (("elves_6"."x" - "elves_6"."y") - 2)) AS "free_sw",
              "elves_6"."free_w"
            FROM (
              SELECT
                "elves_5"."x",
                "elves_5"."y",
                "elves_5"."t",
                "elves_5"."free_n",
                (coalesce((lag(("elves_5"."x" + "elves_5"."y")) OVER (PARTITION BY ("elves_5"."x" - "elves_5"."y") ORDER BY ("elves_5"."x" + "elves_5"."y"))), ("elves_5"."x" + "elves_5"."y")) <> (("elves_5"."x" + "elves_5"."y") - 2)) AS "free_nw",
                "elves_5"."free_e",
                (coalesce((lead(("elves_5"."x" + "elves_5"."y")) OVER (PARTITION BY ("elves_5"."x" - "elves_5"."y") ORDER BY ("elves_5"."x" + "elves_5"."y"))), ("elves_5"."x" + "elves_5"."y")) <> ("elves_5"."x" + "elves_5"."y" + 2)) AS "free_se",
                "elves_5"."free_s",
                "elves_5"."free_w"
              FROM (
                SELECT
                  "elves_4"."x",
                  "elves_4"."y",
                  "elves_4"."t",
                  "elves_4"."free_n",
                  (coalesce((lead("elves_4"."x") OVER (PARTITION BY "elves_4"."y" ORDER BY "elves_4"."x")), "elves_4"."x") <> ("elves_4"."x" + 1)) AS "free_e",
                  "elves_4"."free_s",
                  (coalesce((lag("elves_4"."x") OVER (PARTITION BY "elves_4"."y" ORDER BY "elves_4"."x")), "elves_4"."x") <> ("elves_4"."x" - 1)) AS "free_w"
                FROM (
                  SELECT
                    "elves_3"."x",
                    "elves_3"."y",
                    "elves_3"."t",
                    (coalesce((lag("elves_3"."y") OVER (PARTITION BY "elves_3"."x" ORDER BY "elves_3"."y")), "elves_3"."y") <> ("elves_3"."y" - 1)) AS "free_n",
                    (coalesce((lead("elves_3"."y") OVER (PARTITION BY "elves_3"."x" ORDER BY "elves_3"."y")), "elves_3"."y") <> ("elves_3"."y" + 1)) AS "free_s"
                  FROM "__3" AS "elves_3"
                  WHERE ("elves_3"."t" <= 10)
                ) AS "elves_4"
              ) AS "elves_5"
            ) AS "elves_6"
          ) AS "elves_7"
        ) AS "elves_8"
      ) AS "elves_9"
    ) AS "elves_10"
  ) AS "elves_11"
),
"__5" ("t", "x", "y") AS (
  SELECT
    1 AS "t",
    "elves_13"."x",
    "elves_13"."y"
  FROM "elves_1" AS "elves_13"
  UNION ALL
  SELECT
    "elves_23"."t",
    "elves_23"."x",
    "elves_23"."y"
  FROM (
    SELECT
      ("elves_22"."t" + 1) AS "t",
      (CASE WHEN (NOT "elves_22"."blocked") THEN "elves_22"."next_x" ELSE "elves_22"."x" END) AS "x",
      (CASE WHEN (NOT "elves_22"."blocked") THEN "elves_22"."next_y" ELSE "elves_22"."y" END) AS "y",
      (bool_or((NOT "elves_22"."alone")) OVER ()) AS "bool_or"
    FROM (
      SELECT
        "elves_21"."alone",
        "elves_21"."t",
        ((count(*) OVER (PARTITION BY "elves_21"."next_x", "elves_21"."next_y")) > 1) AS "blocked",
        "elves_21"."next_x",
        "elves_21"."x",
        "elves_21"."next_y",
        "elves_21"."y"
      FROM (
        SELECT
          "elves_20"."alone",
          "elves_20"."t",
          (CASE WHEN (("elves_20"."t" % 4) = 1) THEN coalesce("elves_20"."xn", "elves_20"."xs", "elves_20"."xw", "elves_20"."xe", "elves_20"."x") WHEN (("elves_20"."t" % 4) = 2) THEN coalesce("elves_20"."xs", "elves_20"."xw", "elves_20"."xe", "elves_20"."xn", "elves_20"."x") WHEN (("elves_20"."t" % 4) = 3) THEN coalesce("elves_20"."xw", "elves_20"."xe", "elves_20"."xn", "elves_20"."xs", "elves_20"."x") ELSE coalesce("elves_20"."xe", "elves_20"."xn", "elves_20"."xs", "elves_20"."xw", "elves_20"."x") END) AS "next_x",
          "elves_20"."x",
          (CASE WHEN (("elves_20"."t" % 4) = 1) THEN coalesce("elves_20"."yn", "elves_20"."ys", "elves_20"."yw", "elves_20"."ye", "elves_20"."y") WHEN (("elves_20"."t" % 4) = 2) THEN coalesce("elves_20"."ys", "elves_20"."yw", "elves_20"."ye", "elves_20"."yn", "elves_20"."y") WHEN (("elves_20"."t" % 4) = 3) THEN coalesce("elves_20"."yw", "elves_20"."ye", "elves_20"."yn", "elves_20"."ys", "elves_20"."y") ELSE coalesce("elves_20"."ye", "elves_20"."yn", "elves_20"."ys", "elves_20"."yw", "elves_20"."y") END) AS "next_y",
          "elves_20"."y"
        FROM (
          SELECT
            "elves_19"."alone",
            "elves_19"."t",
            "elves_19"."x",
            "elves_19"."y",
            (CASE WHEN ("elves_19"."can_move_n" AND (NOT "elves_19"."alone")) THEN "elves_19"."x" END) AS "xn",
            (CASE WHEN ("elves_19"."can_move_s" AND (NOT "elves_19"."alone")) THEN "elves_19"."x" END) AS "xs",
            (CASE WHEN ("elves_19"."can_move_w" AND (NOT "elves_19"."alone")) THEN ("elves_19"."x" - 1) END) AS "xw",
            (CASE WHEN ("elves_19"."can_move_e" AND (NOT "elves_19"."alone")) THEN ("elves_19"."x" + 1) END) AS "xe",
            (CASE WHEN ("elves_19"."can_move_n" AND (NOT "elves_19"."alone")) THEN ("elves_19"."y" - 1) END) AS "yn",
            (CASE WHEN ("elves_19"."can_move_s" AND (NOT "elves_19"."alone")) THEN ("elves_19"."y" + 1) END) AS "ys",
            (CASE WHEN ("elves_19"."can_move_w" AND (NOT "elves_19"."alone")) THEN "elves_19"."y" END) AS "yw",
            (CASE WHEN ("elves_19"."can_move_e" AND (NOT "elves_19"."alone")) THEN "elves_19"."y" END) AS "ye"
          FROM (
            SELECT
              ("elves_18"."free_n" AND "elves_18"."free_ne" AND "elves_18"."free_e" AND "elves_18"."free_se" AND "elves_18"."free_s" AND "elves_18"."free_sw" AND "elves_18"."free_w" AND "elves_18"."free_nw") AS "alone",
              "elves_18"."t",
              "elves_18"."x",
              "elves_18"."y",
              ("elves_18"."free_n" AND "elves_18"."free_ne" AND "elves_18"."free_nw") AS "can_move_n",
              ("elves_18"."free_s" AND "elves_18"."free_se" AND "elves_18"."free_sw") AS "can_move_s",
              ("elves_18"."free_w" AND "elves_18"."free_nw" AND "elves_18"."free_sw") AS "can_move_w",
              ("elves_18"."free_e" AND "elves_18"."free_ne" AND "elves_18"."free_se") AS "can_move_e"
            FROM (
              SELECT
                "elves_17"."t",
                "elves_17"."x",
                "elves_17"."y",
                "elves_17"."free_n",
                (coalesce((lead(("elves_17"."x" - "elves_17"."y")) OVER (PARTITION BY ("elves_17"."x" + "elves_17"."y") ORDER BY ("elves_17"."x" - "elves_17"."y"))), ("elves_17"."x" - "elves_17"."y")) <> (("elves_17"."x" - "elves_17"."y") + 2)) AS "free_ne",
                "elves_17"."free_e",
                "elves_17"."free_se",
                "elves_17"."free_s",
                (coalesce((lag(("elves_17"."x" - "elves_17"."y")) OVER (PARTITION BY ("elves_17"."x" + "elves_17"."y") ORDER BY ("elves_17"."x" - "elves_17"."y"))), ("elves_17"."x" - "elves_17"."y")) <> (("elves_17"."x" - "elves_17"."y") - 2)) AS "free_sw",
                "elves_17"."free_w",
                "elves_17"."free_nw"
              FROM (
                SELECT
                  "elves_16"."t",
                  "elves_16"."x",
                  "elves_16"."y",
                  "elves_16"."free_n",
                  "elves_16"."free_e",
                  (coalesce((lead(("elves_16"."x" + "elves_16"."y")) OVER (PARTITION BY ("elves_16"."x" - "elves_16"."y") ORDER BY ("elves_16"."x" + "elves_16"."y"))), ("elves_16"."x" + "elves_16"."y")) <> ("elves_16"."x" + "elves_16"."y" + 2)) AS "free_se",
                  "elves_16"."free_s",
                  "elves_16"."free_w",
                  (coalesce((lag(("elves_16"."x" + "elves_16"."y")) OVER (PARTITION BY ("elves_16"."x" - "elves_16"."y") ORDER BY ("elves_16"."x" + "elves_16"."y"))), ("elves_16"."x" + "elves_16"."y")) <> (("elves_16"."x" + "elves_16"."y") - 2)) AS "free_nw"
                FROM (
                  SELECT
                    "elves_15"."t",
                    "elves_15"."x",
                    "elves_15"."y",
                    "elves_15"."free_n",
                    (coalesce((lead("elves_15"."x") OVER (PARTITION BY "elves_15"."y" ORDER BY "elves_15"."x")), "elves_15"."x") <> ("elves_15"."x" + 1)) AS "free_e",
                    "elves_15"."free_s",
                    (coalesce((lag("elves_15"."x") OVER (PARTITION BY "elves_15"."y" ORDER BY "elves_15"."x")), "elves_15"."x") <> ("elves_15"."x" - 1)) AS "free_w"
                  FROM (
                    SELECT
                      "elves_14"."t",
                      "elves_14"."x",
                      "elves_14"."y",
                      (coalesce((lag("elves_14"."y") OVER (PARTITION BY "elves_14"."x" ORDER BY "elves_14"."y")), "elves_14"."y") <> ("elves_14"."y" - 1)) AS "free_n",
                      (coalesce((lead("elves_14"."y") OVER (PARTITION BY "elves_14"."x" ORDER BY "elves_14"."y")), "elves_14"."y") <> ("elves_14"."y" + 1)) AS "free_s"
                    FROM "__5" AS "elves_14"
                  ) AS "elves_15"
                ) AS "elves_16"
              ) AS "elves_17"
            ) AS "elves_18"
          ) AS "elves_19"
        ) AS "elves_20"
      ) AS "elves_21"
    ) AS "elves_22"
  ) AS "elves_23"
  WHERE "elves_23"."bool_or"
)
SELECT
  "elves_12"."part1",
  "elves_24"."part2"
FROM (
  SELECT ((((max("__4"."x") - min("__4"."x")) + 1) * ((max("__4"."y") - min("__4"."y")) + 1)) - count(*)) AS "part1"
  FROM "__3" AS "__4"
  WHERE ("__4"."t" = 11)
) AS "elves_12"
CROSS JOIN (
  SELECT max("__6"."t") AS "part2"
  FROM "__5" AS "__6"
) AS "elves_24"
