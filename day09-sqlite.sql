WITH RECURSIVE "__1" ("dx", "dy", "motion", "length", "rest") AS (
  SELECT
    (CASE WHEN (substr((CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, 1, (instr(?1, '
') - 1)) ELSE ?1 END), 1, 1) = 'L') THEN -1 WHEN (substr((CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, 1, (instr(?1, '
') - 1)) ELSE ?1 END), 1, 1) = 'R') THEN 1 ELSE 0 END) AS "dx",
    (CASE WHEN (substr((CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, 1, (instr(?1, '
') - 1)) ELSE ?1 END), 1, 1) = 'U') THEN -1 WHEN (substr((CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, 1, (instr(?1, '
') - 1)) ELSE ?1 END), 1, 1) = 'D') THEN 1 ELSE 0 END) AS "dy",
    (0 + 1) AS "motion",
    CAST(substr((CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, 1, (instr(?1, '
') - 1)) ELSE ?1 END), 3) AS INTEGER) AS "length",
    (CASE WHEN (instr(?1, '
') > 0) THEN substr(?1, (instr(?1, '
') + 1)) ELSE '' END) AS "rest"
  WHERE (?1 <> '')
  UNION ALL
  SELECT
    (CASE WHEN (substr((CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", 1, (instr("__2"."rest", '
') - 1)) ELSE "__2"."rest" END), 1, 1) = 'L') THEN -1 WHEN (substr((CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", 1, (instr("__2"."rest", '
') - 1)) ELSE "__2"."rest" END), 1, 1) = 'R') THEN 1 ELSE 0 END) AS "dx",
    (CASE WHEN (substr((CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", 1, (instr("__2"."rest", '
') - 1)) ELSE "__2"."rest" END), 1, 1) = 'U') THEN -1 WHEN (substr((CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", 1, (instr("__2"."rest", '
') - 1)) ELSE "__2"."rest" END), 1, 1) = 'D') THEN 1 ELSE 0 END) AS "dy",
    ("__2"."motion" + 1) AS "motion",
    CAST(substr((CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", 1, (instr("__2"."rest", '
') - 1)) ELSE "__2"."rest" END), 3) AS INTEGER) AS "length",
    (CASE WHEN (instr("__2"."rest", '
') > 0) THEN substr("__2"."rest", (instr("__2"."rest", '
') + 1)) ELSE '' END) AS "rest"
  FROM "__1" AS "__2"
  WHERE ("__2"."rest" <> '')
),
"__4" ("dx", "dy", "motion", "step", "length") AS (
  SELECT
    "__3"."dx",
    "__3"."dy",
    "__3"."motion",
    (0 + 1) AS "step",
    "__3"."length"
  FROM "__1" AS "__3"
  WHERE (0 < "__3"."length")
  UNION ALL
  SELECT
    "__5"."dx",
    "__5"."dy",
    "__5"."motion",
    ("__5"."step" + 1) AS "step",
    "__5"."length"
  FROM "__4" AS "__5"
  WHERE ("__5"."step" < "__5"."length")
),
"heads_1" ("index", "x", "y") AS (
  SELECT
    (count(*) OVER (ORDER BY "__6"."motion", "__6"."step")) AS "index",
    (sum("__6"."dx") OVER (ORDER BY "__6"."motion", "__6"."step")) AS "x",
    (sum("__6"."dy") OVER (ORDER BY "__6"."motion", "__6"."step")) AS "y"
  FROM "__4" AS "__6"
),
"__8" ("x", "y", "index") AS (
  SELECT
    ("__7"."x" + (CASE WHEN ((abs(("heads_2"."x" - "__7"."x")) > 1) OR (abs(("heads_2"."y" - "__7"."y")) > 1)) THEN sign(("heads_2"."x" - "__7"."x")) ELSE 0 END)) AS "x",
    ("__7"."y" + (CASE WHEN ((abs(("heads_2"."x" - "__7"."x")) > 1) OR (abs(("heads_2"."y" - "__7"."y")) > 1)) THEN sign(("heads_2"."y" - "__7"."y")) ELSE 0 END)) AS "y",
    ("__7"."index" + 1) AS "index"
  FROM (
    SELECT
      0 AS "x",
      0 AS "y",
      0 AS "index"
  ) AS "__7"
  JOIN "heads_1" AS "heads_2" ON (("__7"."index" + 1) = "heads_2"."index")
  UNION ALL
  SELECT
    ("__9"."x" + (CASE WHEN ((abs(("heads_3"."x" - "__9"."x")) > 1) OR (abs(("heads_3"."y" - "__9"."y")) > 1)) THEN sign(("heads_3"."x" - "__9"."x")) ELSE 0 END)) AS "x",
    ("__9"."y" + (CASE WHEN ((abs(("heads_3"."x" - "__9"."x")) > 1) OR (abs(("heads_3"."y" - "__9"."y")) > 1)) THEN sign(("heads_3"."y" - "__9"."y")) ELSE 0 END)) AS "y",
    ("__9"."index" + 1) AS "index"
  FROM "__8" AS "__9"
  JOIN "heads_1" AS "heads_3" ON (("__9"."index" + 1) = "heads_3"."index")
),
"__14" ("index", "x", "y") AS (
  SELECT
    ("__13"."index" + 1) AS "index",
    ("__13"."x" + (CASE WHEN ((abs(("heads_4"."x" - "__13"."x")) > 1) OR (abs(("heads_4"."y" - "__13"."y")) > 1)) THEN sign(("heads_4"."x" - "__13"."x")) ELSE 0 END)) AS "x",
    ("__13"."y" + (CASE WHEN ((abs(("heads_4"."x" - "__13"."x")) > 1) OR (abs(("heads_4"."y" - "__13"."y")) > 1)) THEN sign(("heads_4"."y" - "__13"."y")) ELSE 0 END)) AS "y"
  FROM (
    SELECT
      0 AS "index",
      0 AS "x",
      0 AS "y"
  ) AS "__13"
  JOIN "heads_1" AS "heads_4" ON (("__13"."index" + 1) = "heads_4"."index")
  UNION ALL
  SELECT
    ("__15"."index" + 1) AS "index",
    ("__15"."x" + (CASE WHEN ((abs(("heads_5"."x" - "__15"."x")) > 1) OR (abs(("heads_5"."y" - "__15"."y")) > 1)) THEN sign(("heads_5"."x" - "__15"."x")) ELSE 0 END)) AS "x",
    ("__15"."y" + (CASE WHEN ((abs(("heads_5"."x" - "__15"."x")) > 1) OR (abs(("heads_5"."y" - "__15"."y")) > 1)) THEN sign(("heads_5"."y" - "__15"."y")) ELSE 0 END)) AS "y"
  FROM "__14" AS "__15"
  JOIN "heads_1" AS "heads_5" ON (("__15"."index" + 1) = "heads_5"."index")
),
"heads_6" ("index", "x", "y") AS (
  SELECT
    "__16"."index",
    "__16"."x",
    "__16"."y"
  FROM "__14" AS "__16"
),
"__18" ("index", "x", "y") AS (
  SELECT
    ("__17"."index" + 1) AS "index",
    ("__17"."x" + (CASE WHEN ((abs(("heads_7"."x" - "__17"."x")) > 1) OR (abs(("heads_7"."y" - "__17"."y")) > 1)) THEN sign(("heads_7"."x" - "__17"."x")) ELSE 0 END)) AS "x",
    ("__17"."y" + (CASE WHEN ((abs(("heads_7"."x" - "__17"."x")) > 1) OR (abs(("heads_7"."y" - "__17"."y")) > 1)) THEN sign(("heads_7"."y" - "__17"."y")) ELSE 0 END)) AS "y"
  FROM (
    SELECT
      0 AS "index",
      0 AS "x",
      0 AS "y"
  ) AS "__17"
  JOIN "heads_6" AS "heads_7" ON (("__17"."index" + 1) = "heads_7"."index")
  UNION ALL
  SELECT
    ("__19"."index" + 1) AS "index",
    ("__19"."x" + (CASE WHEN ((abs(("heads_8"."x" - "__19"."x")) > 1) OR (abs(("heads_8"."y" - "__19"."y")) > 1)) THEN sign(("heads_8"."x" - "__19"."x")) ELSE 0 END)) AS "x",
    ("__19"."y" + (CASE WHEN ((abs(("heads_8"."x" - "__19"."x")) > 1) OR (abs(("heads_8"."y" - "__19"."y")) > 1)) THEN sign(("heads_8"."y" - "__19"."y")) ELSE 0 END)) AS "y"
  FROM "__18" AS "__19"
  JOIN "heads_6" AS "heads_8" ON (("__19"."index" + 1) = "heads_8"."index")
),
"heads_9" ("index", "x", "y") AS (
  SELECT
    "__20"."index",
    "__20"."x",
    "__20"."y"
  FROM "__18" AS "__20"
),
"__22" ("index", "x", "y") AS (
  SELECT
    ("__21"."index" + 1) AS "index",
    ("__21"."x" + (CASE WHEN ((abs(("heads_10"."x" - "__21"."x")) > 1) OR (abs(("heads_10"."y" - "__21"."y")) > 1)) THEN sign(("heads_10"."x" - "__21"."x")) ELSE 0 END)) AS "x",
    ("__21"."y" + (CASE WHEN ((abs(("heads_10"."x" - "__21"."x")) > 1) OR (abs(("heads_10"."y" - "__21"."y")) > 1)) THEN sign(("heads_10"."y" - "__21"."y")) ELSE 0 END)) AS "y"
  FROM (
    SELECT
      0 AS "index",
      0 AS "x",
      0 AS "y"
  ) AS "__21"
  JOIN "heads_9" AS "heads_10" ON (("__21"."index" + 1) = "heads_10"."index")
  UNION ALL
  SELECT
    ("__23"."index" + 1) AS "index",
    ("__23"."x" + (CASE WHEN ((abs(("heads_11"."x" - "__23"."x")) > 1) OR (abs(("heads_11"."y" - "__23"."y")) > 1)) THEN sign(("heads_11"."x" - "__23"."x")) ELSE 0 END)) AS "x",
    ("__23"."y" + (CASE WHEN ((abs(("heads_11"."x" - "__23"."x")) > 1) OR (abs(("heads_11"."y" - "__23"."y")) > 1)) THEN sign(("heads_11"."y" - "__23"."y")) ELSE 0 END)) AS "y"
  FROM "__22" AS "__23"
  JOIN "heads_9" AS "heads_11" ON (("__23"."index" + 1) = "heads_11"."index")
),
"heads_12" ("index", "x", "y") AS (
  SELECT
    "__24"."index",
    "__24"."x",
    "__24"."y"
  FROM "__22" AS "__24"
),
"__26" ("index", "x", "y") AS (
  SELECT
    ("__25"."index" + 1) AS "index",
    ("__25"."x" + (CASE WHEN ((abs(("heads_13"."x" - "__25"."x")) > 1) OR (abs(("heads_13"."y" - "__25"."y")) > 1)) THEN sign(("heads_13"."x" - "__25"."x")) ELSE 0 END)) AS "x",
    ("__25"."y" + (CASE WHEN ((abs(("heads_13"."x" - "__25"."x")) > 1) OR (abs(("heads_13"."y" - "__25"."y")) > 1)) THEN sign(("heads_13"."y" - "__25"."y")) ELSE 0 END)) AS "y"
  FROM (
    SELECT
      0 AS "index",
      0 AS "x",
      0 AS "y"
  ) AS "__25"
  JOIN "heads_12" AS "heads_13" ON (("__25"."index" + 1) = "heads_13"."index")
  UNION ALL
  SELECT
    ("__27"."index" + 1) AS "index",
    ("__27"."x" + (CASE WHEN ((abs(("heads_14"."x" - "__27"."x")) > 1) OR (abs(("heads_14"."y" - "__27"."y")) > 1)) THEN sign(("heads_14"."x" - "__27"."x")) ELSE 0 END)) AS "x",
    ("__27"."y" + (CASE WHEN ((abs(("heads_14"."x" - "__27"."x")) > 1) OR (abs(("heads_14"."y" - "__27"."y")) > 1)) THEN sign(("heads_14"."y" - "__27"."y")) ELSE 0 END)) AS "y"
  FROM "__26" AS "__27"
  JOIN "heads_12" AS "heads_14" ON (("__27"."index" + 1) = "heads_14"."index")
),
"heads_15" ("index", "x", "y") AS (
  SELECT
    "__28"."index",
    "__28"."x",
    "__28"."y"
  FROM "__26" AS "__28"
),
"__30" ("index", "x", "y") AS (
  SELECT
    ("__29"."index" + 1) AS "index",
    ("__29"."x" + (CASE WHEN ((abs(("heads_16"."x" - "__29"."x")) > 1) OR (abs(("heads_16"."y" - "__29"."y")) > 1)) THEN sign(("heads_16"."x" - "__29"."x")) ELSE 0 END)) AS "x",
    ("__29"."y" + (CASE WHEN ((abs(("heads_16"."x" - "__29"."x")) > 1) OR (abs(("heads_16"."y" - "__29"."y")) > 1)) THEN sign(("heads_16"."y" - "__29"."y")) ELSE 0 END)) AS "y"
  FROM (
    SELECT
      0 AS "index",
      0 AS "x",
      0 AS "y"
  ) AS "__29"
  JOIN "heads_15" AS "heads_16" ON (("__29"."index" + 1) = "heads_16"."index")
  UNION ALL
  SELECT
    ("__31"."index" + 1) AS "index",
    ("__31"."x" + (CASE WHEN ((abs(("heads_17"."x" - "__31"."x")) > 1) OR (abs(("heads_17"."y" - "__31"."y")) > 1)) THEN sign(("heads_17"."x" - "__31"."x")) ELSE 0 END)) AS "x",
    ("__31"."y" + (CASE WHEN ((abs(("heads_17"."x" - "__31"."x")) > 1) OR (abs(("heads_17"."y" - "__31"."y")) > 1)) THEN sign(("heads_17"."y" - "__31"."y")) ELSE 0 END)) AS "y"
  FROM "__30" AS "__31"
  JOIN "heads_15" AS "heads_17" ON (("__31"."index" + 1) = "heads_17"."index")
),
"heads_18" ("index", "x", "y") AS (
  SELECT
    "__32"."index",
    "__32"."x",
    "__32"."y"
  FROM "__30" AS "__32"
),
"__34" ("index", "x", "y") AS (
  SELECT
    ("__33"."index" + 1) AS "index",
    ("__33"."x" + (CASE WHEN ((abs(("heads_19"."x" - "__33"."x")) > 1) OR (abs(("heads_19"."y" - "__33"."y")) > 1)) THEN sign(("heads_19"."x" - "__33"."x")) ELSE 0 END)) AS "x",
    ("__33"."y" + (CASE WHEN ((abs(("heads_19"."x" - "__33"."x")) > 1) OR (abs(("heads_19"."y" - "__33"."y")) > 1)) THEN sign(("heads_19"."y" - "__33"."y")) ELSE 0 END)) AS "y"
  FROM (
    SELECT
      0 AS "index",
      0 AS "x",
      0 AS "y"
  ) AS "__33"
  JOIN "heads_18" AS "heads_19" ON (("__33"."index" + 1) = "heads_19"."index")
  UNION ALL
  SELECT
    ("__35"."index" + 1) AS "index",
    ("__35"."x" + (CASE WHEN ((abs(("heads_20"."x" - "__35"."x")) > 1) OR (abs(("heads_20"."y" - "__35"."y")) > 1)) THEN sign(("heads_20"."x" - "__35"."x")) ELSE 0 END)) AS "x",
    ("__35"."y" + (CASE WHEN ((abs(("heads_20"."x" - "__35"."x")) > 1) OR (abs(("heads_20"."y" - "__35"."y")) > 1)) THEN sign(("heads_20"."y" - "__35"."y")) ELSE 0 END)) AS "y"
  FROM "__34" AS "__35"
  JOIN "heads_18" AS "heads_20" ON (("__35"."index" + 1) = "heads_20"."index")
),
"heads_21" ("index", "x", "y") AS (
  SELECT
    "__36"."index",
    "__36"."x",
    "__36"."y"
  FROM "__34" AS "__36"
),
"__38" ("index", "x", "y") AS (
  SELECT
    ("__37"."index" + 1) AS "index",
    ("__37"."x" + (CASE WHEN ((abs(("heads_22"."x" - "__37"."x")) > 1) OR (abs(("heads_22"."y" - "__37"."y")) > 1)) THEN sign(("heads_22"."x" - "__37"."x")) ELSE 0 END)) AS "x",
    ("__37"."y" + (CASE WHEN ((abs(("heads_22"."x" - "__37"."x")) > 1) OR (abs(("heads_22"."y" - "__37"."y")) > 1)) THEN sign(("heads_22"."y" - "__37"."y")) ELSE 0 END)) AS "y"
  FROM (
    SELECT
      0 AS "index",
      0 AS "x",
      0 AS "y"
  ) AS "__37"
  JOIN "heads_21" AS "heads_22" ON (("__37"."index" + 1) = "heads_22"."index")
  UNION ALL
  SELECT
    ("__39"."index" + 1) AS "index",
    ("__39"."x" + (CASE WHEN ((abs(("heads_23"."x" - "__39"."x")) > 1) OR (abs(("heads_23"."y" - "__39"."y")) > 1)) THEN sign(("heads_23"."x" - "__39"."x")) ELSE 0 END)) AS "x",
    ("__39"."y" + (CASE WHEN ((abs(("heads_23"."x" - "__39"."x")) > 1) OR (abs(("heads_23"."y" - "__39"."y")) > 1)) THEN sign(("heads_23"."y" - "__39"."y")) ELSE 0 END)) AS "y"
  FROM "__38" AS "__39"
  JOIN "heads_21" AS "heads_23" ON (("__39"."index" + 1) = "heads_23"."index")
),
"heads_24" ("index", "x", "y") AS (
  SELECT
    "__40"."index",
    "__40"."x",
    "__40"."y"
  FROM "__38" AS "__40"
),
"__42" ("index", "x", "y") AS (
  SELECT
    ("__41"."index" + 1) AS "index",
    ("__41"."x" + (CASE WHEN ((abs(("heads_25"."x" - "__41"."x")) > 1) OR (abs(("heads_25"."y" - "__41"."y")) > 1)) THEN sign(("heads_25"."x" - "__41"."x")) ELSE 0 END)) AS "x",
    ("__41"."y" + (CASE WHEN ((abs(("heads_25"."x" - "__41"."x")) > 1) OR (abs(("heads_25"."y" - "__41"."y")) > 1)) THEN sign(("heads_25"."y" - "__41"."y")) ELSE 0 END)) AS "y"
  FROM (
    SELECT
      0 AS "index",
      0 AS "x",
      0 AS "y"
  ) AS "__41"
  JOIN "heads_24" AS "heads_25" ON (("__41"."index" + 1) = "heads_25"."index")
  UNION ALL
  SELECT
    ("__43"."index" + 1) AS "index",
    ("__43"."x" + (CASE WHEN ((abs(("heads_26"."x" - "__43"."x")) > 1) OR (abs(("heads_26"."y" - "__43"."y")) > 1)) THEN sign(("heads_26"."x" - "__43"."x")) ELSE 0 END)) AS "x",
    ("__43"."y" + (CASE WHEN ((abs(("heads_26"."x" - "__43"."x")) > 1) OR (abs(("heads_26"."y" - "__43"."y")) > 1)) THEN sign(("heads_26"."y" - "__43"."y")) ELSE 0 END)) AS "y"
  FROM "__42" AS "__43"
  JOIN "heads_24" AS "heads_26" ON (("__43"."index" + 1) = "heads_26"."index")
),
"heads_27" ("index", "x", "y") AS (
  SELECT
    "__44"."index",
    "__44"."x",
    "__44"."y"
  FROM "__42" AS "__44"
),
"__46" ("x", "y", "index") AS (
  SELECT
    ("__45"."x" + (CASE WHEN ((abs(("heads_28"."x" - "__45"."x")) > 1) OR (abs(("heads_28"."y" - "__45"."y")) > 1)) THEN sign(("heads_28"."x" - "__45"."x")) ELSE 0 END)) AS "x",
    ("__45"."y" + (CASE WHEN ((abs(("heads_28"."x" - "__45"."x")) > 1) OR (abs(("heads_28"."y" - "__45"."y")) > 1)) THEN sign(("heads_28"."y" - "__45"."y")) ELSE 0 END)) AS "y",
    ("__45"."index" + 1) AS "index"
  FROM (
    SELECT
      0 AS "x",
      0 AS "y",
      0 AS "index"
  ) AS "__45"
  JOIN "heads_27" AS "heads_28" ON (("__45"."index" + 1) = "heads_28"."index")
  UNION ALL
  SELECT
    ("__47"."x" + (CASE WHEN ((abs(("heads_29"."x" - "__47"."x")) > 1) OR (abs(("heads_29"."y" - "__47"."y")) > 1)) THEN sign(("heads_29"."x" - "__47"."x")) ELSE 0 END)) AS "x",
    ("__47"."y" + (CASE WHEN ((abs(("heads_29"."x" - "__47"."x")) > 1) OR (abs(("heads_29"."y" - "__47"."y")) > 1)) THEN sign(("heads_29"."y" - "__47"."y")) ELSE 0 END)) AS "y",
    ("__47"."index" + 1) AS "index"
  FROM "__46" AS "__47"
  JOIN "heads_27" AS "heads_29" ON (("__47"."index" + 1) = "heads_29"."index")
)
SELECT
  "__12"."part1",
  "__50"."part2"
FROM (
  SELECT count(*) AS "part1"
  FROM (
    SELECT DISTINCT
      "__10"."x",
      "__10"."y"
    FROM "__8" AS "__10"
  ) AS "__11"
) AS "__12"
CROSS JOIN (
  SELECT count(*) AS "part2"
  FROM (
    SELECT DISTINCT
      "__48"."x",
      "__48"."y"
    FROM "__46" AS "__48"
  ) AS "__49"
) AS "__50"
