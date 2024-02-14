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
    (CASE WHEN (NOT "__12"."blocked") THEN "__12"."next_x" ELSE "__12"."x" END) AS "x",
    (CASE WHEN (NOT "__12"."blocked") THEN "__12"."next_y" ELSE "__12"."y" END) AS "y",
    ("__12"."t" + 1) AS "t"
  FROM (
    SELECT
      ((count(*) OVER (PARTITION BY "__11"."next_x", "__11"."next_y")) > 1) AS "blocked",
      "__11"."next_x",
      "__11"."x",
      "__11"."next_y",
      "__11"."y",
      "__11"."t"
    FROM (
      SELECT
        (CASE WHEN (("__10"."t" % 4) = 1) THEN coalesce("__10"."xn", "__10"."xs", "__10"."xw", "__10"."xe", "__10"."x") WHEN (("__10"."t" % 4) = 2) THEN coalesce("__10"."xs", "__10"."xw", "__10"."xe", "__10"."xn", "__10"."x") WHEN (("__10"."t" % 4) = 3) THEN coalesce("__10"."xw", "__10"."xe", "__10"."xn", "__10"."xs", "__10"."x") ELSE coalesce("__10"."xe", "__10"."xn", "__10"."xs", "__10"."xw", "__10"."x") END) AS "next_x",
        "__10"."x",
        (CASE WHEN (("__10"."t" % 4) = 1) THEN coalesce("__10"."yn", "__10"."ys", "__10"."yw", "__10"."ye", "__10"."y") WHEN (("__10"."t" % 4) = 2) THEN coalesce("__10"."ys", "__10"."yw", "__10"."ye", "__10"."yn", "__10"."y") WHEN (("__10"."t" % 4) = 3) THEN coalesce("__10"."yw", "__10"."ye", "__10"."yn", "__10"."ys", "__10"."y") ELSE coalesce("__10"."ye", "__10"."yn", "__10"."ys", "__10"."yw", "__10"."y") END) AS "next_y",
        "__10"."y",
        "__10"."t"
      FROM (
        SELECT
          "__9"."x",
          "__9"."y",
          "__9"."t",
          (CASE WHEN ("__9"."can_move_n" AND (NOT "__9"."alone")) THEN "__9"."x" END) AS "xn",
          (CASE WHEN ("__9"."can_move_s" AND (NOT "__9"."alone")) THEN "__9"."x" END) AS "xs",
          (CASE WHEN ("__9"."can_move_w" AND (NOT "__9"."alone")) THEN ("__9"."x" - 1) END) AS "xw",
          (CASE WHEN ("__9"."can_move_e" AND (NOT "__9"."alone")) THEN ("__9"."x" + 1) END) AS "xe",
          (CASE WHEN ("__9"."can_move_n" AND (NOT "__9"."alone")) THEN ("__9"."y" - 1) END) AS "yn",
          (CASE WHEN ("__9"."can_move_s" AND (NOT "__9"."alone")) THEN ("__9"."y" + 1) END) AS "ys",
          (CASE WHEN ("__9"."can_move_w" AND (NOT "__9"."alone")) THEN "__9"."y" END) AS "yw",
          (CASE WHEN ("__9"."can_move_e" AND (NOT "__9"."alone")) THEN "__9"."y" END) AS "ye"
        FROM (
          SELECT
            "__8"."x",
            "__8"."y",
            "__8"."t",
            ("__8"."free_n" AND "__8"."free_ne" AND "__8"."free_nw") AS "can_move_n",
            ("__8"."free_n" AND "__8"."free_ne" AND "__8"."free_e" AND "__8"."free_se" AND "__8"."free_s" AND "__8"."free_sw" AND "__8"."free_w" AND "__8"."free_nw") AS "alone",
            ("__8"."free_s" AND "__8"."free_se" AND "__8"."free_sw") AS "can_move_s",
            ("__8"."free_w" AND "__8"."free_nw" AND "__8"."free_sw") AS "can_move_w",
            ("__8"."free_e" AND "__8"."free_ne" AND "__8"."free_se") AS "can_move_e"
          FROM (
            SELECT
              "__7"."x",
              "__7"."y",
              "__7"."t",
              "__7"."free_n",
              (coalesce((lead(("__7"."x" - "__7"."y")) OVER (PARTITION BY ("__7"."x" + "__7"."y") ORDER BY ("__7"."x" - "__7"."y"))), ("__7"."x" - "__7"."y")) <> (("__7"."x" - "__7"."y") + 2)) AS "free_ne",
              "__7"."free_e",
              "__7"."free_se",
              "__7"."free_s",
              (coalesce((lag(("__7"."x" - "__7"."y")) OVER (PARTITION BY ("__7"."x" + "__7"."y") ORDER BY ("__7"."x" - "__7"."y"))), ("__7"."x" - "__7"."y")) <> (("__7"."x" - "__7"."y") - 2)) AS "free_sw",
              "__7"."free_w",
              "__7"."free_nw"
            FROM (
              SELECT
                "__6"."x",
                "__6"."y",
                "__6"."t",
                "__6"."free_n",
                "__6"."free_e",
                (coalesce((lead(("__6"."x" + "__6"."y")) OVER (PARTITION BY ("__6"."x" - "__6"."y") ORDER BY ("__6"."x" + "__6"."y"))), ("__6"."x" + "__6"."y")) <> ("__6"."x" + "__6"."y" + 2)) AS "free_se",
                "__6"."free_s",
                "__6"."free_w",
                (coalesce((lag(("__6"."x" + "__6"."y")) OVER (PARTITION BY ("__6"."x" - "__6"."y") ORDER BY ("__6"."x" + "__6"."y"))), ("__6"."x" + "__6"."y")) <> (("__6"."x" + "__6"."y") - 2)) AS "free_nw"
              FROM (
                SELECT
                  "__5"."x",
                  "__5"."y",
                  "__5"."t",
                  "__5"."free_n",
                  (coalesce((lead("__5"."x") OVER (PARTITION BY "__5"."y" ORDER BY "__5"."x")), "__5"."x") <> ("__5"."x" + 1)) AS "free_e",
                  "__5"."free_s",
                  (coalesce((lag("__5"."x") OVER (PARTITION BY "__5"."y" ORDER BY "__5"."x")), "__5"."x") <> ("__5"."x" - 1)) AS "free_w"
                FROM (
                  SELECT
                    "__4"."x",
                    "__4"."y",
                    "__4"."t",
                    (coalesce((lag("__4"."y") OVER (PARTITION BY "__4"."x" ORDER BY "__4"."y")), "__4"."y") <> ("__4"."y" - 1)) AS "free_n",
                    (coalesce((lead("__4"."y") OVER (PARTITION BY "__4"."x" ORDER BY "__4"."y")), "__4"."y") <> ("__4"."y" + 1)) AS "free_s"
                  FROM "__3" AS "__4"
                  WHERE ("__4"."t" <= 10)
                ) AS "__5"
              ) AS "__6"
            ) AS "__7"
          ) AS "__8"
        ) AS "__9"
      ) AS "__10"
    ) AS "__11"
  ) AS "__12"
),
"__15" ("t", "x", "y") AS (
  SELECT
    1 AS "t",
    "elves_3"."x",
    "elves_3"."y"
  FROM "elves_1" AS "elves_3"
  UNION ALL
  SELECT
    "__25"."t",
    "__25"."x",
    "__25"."y"
  FROM (
    SELECT
      ("__24"."t" + 1) AS "t",
      (CASE WHEN (NOT "__24"."blocked") THEN "__24"."next_x" ELSE "__24"."x" END) AS "x",
      (CASE WHEN (NOT "__24"."blocked") THEN "__24"."next_y" ELSE "__24"."y" END) AS "y",
      (bool_or((NOT "__24"."alone")) OVER ()) AS "bool_or"
    FROM (
      SELECT
        "__23"."alone",
        ((count(*) OVER (PARTITION BY "__23"."next_x", "__23"."next_y")) > 1) AS "blocked",
        "__23"."next_x",
        "__23"."x",
        "__23"."next_y",
        "__23"."y",
        "__23"."t"
      FROM (
        SELECT
          "__22"."alone",
          (CASE WHEN (("__22"."t" % 4) = 1) THEN coalesce("__22"."xn", "__22"."xs", "__22"."xw", "__22"."xe", "__22"."x") WHEN (("__22"."t" % 4) = 2) THEN coalesce("__22"."xs", "__22"."xw", "__22"."xe", "__22"."xn", "__22"."x") WHEN (("__22"."t" % 4) = 3) THEN coalesce("__22"."xw", "__22"."xe", "__22"."xn", "__22"."xs", "__22"."x") ELSE coalesce("__22"."xe", "__22"."xn", "__22"."xs", "__22"."xw", "__22"."x") END) AS "next_x",
          "__22"."x",
          (CASE WHEN (("__22"."t" % 4) = 1) THEN coalesce("__22"."yn", "__22"."ys", "__22"."yw", "__22"."ye", "__22"."y") WHEN (("__22"."t" % 4) = 2) THEN coalesce("__22"."ys", "__22"."yw", "__22"."ye", "__22"."yn", "__22"."y") WHEN (("__22"."t" % 4) = 3) THEN coalesce("__22"."yw", "__22"."ye", "__22"."yn", "__22"."ys", "__22"."y") ELSE coalesce("__22"."ye", "__22"."yn", "__22"."ys", "__22"."yw", "__22"."y") END) AS "next_y",
          "__22"."y",
          "__22"."t"
        FROM (
          SELECT
            "__21"."alone",
            "__21"."x",
            "__21"."y",
            "__21"."t",
            (CASE WHEN ("__21"."can_move_n" AND (NOT "__21"."alone")) THEN "__21"."x" END) AS "xn",
            (CASE WHEN ("__21"."can_move_s" AND (NOT "__21"."alone")) THEN "__21"."x" END) AS "xs",
            (CASE WHEN ("__21"."can_move_w" AND (NOT "__21"."alone")) THEN ("__21"."x" - 1) END) AS "xw",
            (CASE WHEN ("__21"."can_move_e" AND (NOT "__21"."alone")) THEN ("__21"."x" + 1) END) AS "xe",
            (CASE WHEN ("__21"."can_move_n" AND (NOT "__21"."alone")) THEN ("__21"."y" - 1) END) AS "yn",
            (CASE WHEN ("__21"."can_move_s" AND (NOT "__21"."alone")) THEN ("__21"."y" + 1) END) AS "ys",
            (CASE WHEN ("__21"."can_move_w" AND (NOT "__21"."alone")) THEN "__21"."y" END) AS "yw",
            (CASE WHEN ("__21"."can_move_e" AND (NOT "__21"."alone")) THEN "__21"."y" END) AS "ye"
          FROM (
            SELECT
              ("__20"."free_n" AND "__20"."free_ne" AND "__20"."free_e" AND "__20"."free_se" AND "__20"."free_s" AND "__20"."free_sw" AND "__20"."free_w" AND "__20"."free_nw") AS "alone",
              "__20"."x",
              "__20"."y",
              "__20"."t",
              ("__20"."free_n" AND "__20"."free_ne" AND "__20"."free_nw") AS "can_move_n",
              ("__20"."free_s" AND "__20"."free_se" AND "__20"."free_sw") AS "can_move_s",
              ("__20"."free_w" AND "__20"."free_nw" AND "__20"."free_sw") AS "can_move_w",
              ("__20"."free_e" AND "__20"."free_ne" AND "__20"."free_se") AS "can_move_e"
            FROM (
              SELECT
                "__19"."x",
                "__19"."y",
                "__19"."t",
                "__19"."free_n",
                (coalesce((lead(("__19"."x" - "__19"."y")) OVER (PARTITION BY ("__19"."x" + "__19"."y") ORDER BY ("__19"."x" - "__19"."y"))), ("__19"."x" - "__19"."y")) <> (("__19"."x" - "__19"."y") + 2)) AS "free_ne",
                "__19"."free_e",
                "__19"."free_se",
                "__19"."free_s",
                (coalesce((lag(("__19"."x" - "__19"."y")) OVER (PARTITION BY ("__19"."x" + "__19"."y") ORDER BY ("__19"."x" - "__19"."y"))), ("__19"."x" - "__19"."y")) <> (("__19"."x" - "__19"."y") - 2)) AS "free_sw",
                "__19"."free_w",
                "__19"."free_nw"
              FROM (
                SELECT
                  "__18"."x",
                  "__18"."y",
                  "__18"."t",
                  "__18"."free_n",
                  "__18"."free_e",
                  (coalesce((lead(("__18"."x" + "__18"."y")) OVER (PARTITION BY ("__18"."x" - "__18"."y") ORDER BY ("__18"."x" + "__18"."y"))), ("__18"."x" + "__18"."y")) <> ("__18"."x" + "__18"."y" + 2)) AS "free_se",
                  "__18"."free_s",
                  "__18"."free_w",
                  (coalesce((lag(("__18"."x" + "__18"."y")) OVER (PARTITION BY ("__18"."x" - "__18"."y") ORDER BY ("__18"."x" + "__18"."y"))), ("__18"."x" + "__18"."y")) <> (("__18"."x" + "__18"."y") - 2)) AS "free_nw"
                FROM (
                  SELECT
                    "__17"."x",
                    "__17"."y",
                    "__17"."t",
                    "__17"."free_n",
                    (coalesce((lead("__17"."x") OVER (PARTITION BY "__17"."y" ORDER BY "__17"."x")), "__17"."x") <> ("__17"."x" + 1)) AS "free_e",
                    "__17"."free_s",
                    (coalesce((lag("__17"."x") OVER (PARTITION BY "__17"."y" ORDER BY "__17"."x")), "__17"."x") <> ("__17"."x" - 1)) AS "free_w"
                  FROM (
                    SELECT
                      "__16"."x",
                      "__16"."y",
                      "__16"."t",
                      (coalesce((lag("__16"."y") OVER (PARTITION BY "__16"."x" ORDER BY "__16"."y")), "__16"."y") <> ("__16"."y" - 1)) AS "free_n",
                      (coalesce((lead("__16"."y") OVER (PARTITION BY "__16"."x" ORDER BY "__16"."y")), "__16"."y") <> ("__16"."y" + 1)) AS "free_s"
                    FROM "__15" AS "__16"
                  ) AS "__17"
                ) AS "__18"
              ) AS "__19"
            ) AS "__20"
          ) AS "__21"
        ) AS "__22"
      ) AS "__23"
    ) AS "__24"
  ) AS "__25"
  WHERE "__25"."bool_or"
)
SELECT
  "__14"."part1",
  "__27"."part2"
FROM (
  SELECT ((((max("__13"."x") - min("__13"."x")) + 1) * ((max("__13"."y") - min("__13"."y")) + 1)) - count(*)) AS "part1"
  FROM "__3" AS "__13"
  WHERE ("__13"."t" = 11)
) AS "__14"
CROSS JOIN (
  SELECT max("__26"."t") AS "part2"
  FROM "__15" AS "__26"
) AS "__27"
