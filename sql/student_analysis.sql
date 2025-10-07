SELECT *
FROM student_exam_scores
LIMIT 5;


PRAGMA table_info(student_exam_scores);

-- Count total rows
SELECT COUNT(*) AS n_rows
FROM student_exam_scores;

SELECT
  ROUND(AVG(exam_score_percent), 2)  AS avg_exam_score,
  ROUND(AVG(passed_70)*100, 1)       AS pass_rate_pct,
  ROUND(MAX(exam_score_percent), 1)  AS max_score,
  ROUND(MIN(exam_score_percent), 1)  AS min_score
FROM student_exam_scores;

WITH b AS (
  SELECT
    CASE
      WHEN hours_studied < 4 THEN '<4'
      WHEN hours_studied < 6 THEN '4–5.9'
      WHEN hours_studied < 8 THEN '6–7.9'
      WHEN hours_studied < 10 THEN '8–9.9'
      ELSE '10+'
    END AS hours_bin,
    passed_70
  FROM student_exam_scores
)
SELECT
  hours_bin,
  COUNT(*) AS n,
  ROUND(AVG(passed_70)*100,1) AS pass_rate_pct
FROM b
GROUP BY hours_bin
ORDER BY CASE hours_bin
  WHEN '<4' THEN 1
  WHEN '4–5.9' THEN 2
  WHEN '6–7.9' THEN 3
  WHEN '8–9.9' THEN 4
  ELSE 5
END;

WITH b AS (
  SELECT
    CASE
      WHEN sleep_hours < 6 THEN '<6'
      WHEN sleep_hours < 8 THEN '6–7.9'
      WHEN sleep_hours < 10 THEN '8–9.9'
      ELSE '10+'
    END AS sleep_bin,
    exam_score_percent
  FROM student_exam_scores
)
SELECT
  sleep_bin,
  COUNT(*) AS n,
  ROUND(AVG(exam_score_percent),1) AS avg_score
FROM b
GROUP BY sleep_bin
ORDER BY CASE sleep_bin
  WHEN '<6' THEN 1
  WHEN '6–7.9' THEN 2
  WHEN '8–9.9' THEN 3
  ELSE 4
END;

WITH b AS (
  SELECT
    CASE
      WHEN attendance_percent < 60 THEN '50–59'
      WHEN attendance_percent < 70 THEN '60–69'
      WHEN attendance_percent < 80 THEN '70–79'
      WHEN attendance_percent < 90 THEN '80–89'
      ELSE '90–100'
    END AS att_band,
    exam_score_percent
  FROM student_exam_scores
)
SELECT
  att_band,
  COUNT(*) AS n,
  ROUND(AVG(exam_score_percent),1) AS avg_score
FROM b
GROUP BY att_band
ORDER BY att_band;

WITH s AS (
  SELECT
    AVG(hours_studied) mx,
    AVG(exam_score_percent) my,
    AVG(hours_studied*exam_score_percent) mxy,
    AVG(hours_studied*hours_studied) mxx,
    AVG(exam_score_percent*exam_score_percent) myy
  FROM student_exam_scores
)
SELECT
  (mxy - mx*my) / (sqrt(mxx - mx*mx) * sqrt(myy - my*my)) AS r_hours_exam
FROM s;

-- Sleep vs exam score
WITH s AS (
  SELECT
    AVG(sleep_hours) mx,
    AVG(exam_score_percent) my,
    AVG(sleep_hours*exam_score_percent) mxy,
    AVG(sleep_hours*sleep_hours) mxx,
    AVG(exam_score_percent*exam_score_percent) myy
  FROM student_exam_scores
)
SELECT
  (mxy - mx*my) / (sqrt(mxx - mx*mx) * sqrt(myy - my*my)) AS r_sleep_exam
FROM s;

-- Attendance vs exam score
WITH s AS (
  SELECT
    AVG(attendance_percent) mx,
    AVG(exam_score_percent) my,
    AVG(attendance_percent*exam_score_percent) mxy,
    AVG(attendance_percent*attendance_percent) mxx,
    AVG(exam_score_percent*exam_score_percent) myy
  FROM student_exam_scores
)
SELECT
  (mxy - mx*my) / (sqrt(mxx - mx*mx) * sqrt(myy - my*my)) AS r_attendance_exam
FROM s;

SELECT student_id, exam_score_percent
FROM student_exam_scores
ORDER BY exam_score_percent DESC
LIMIT 10;

SELECT student_id, exam_score_percent
FROM student_exam_scores
ORDER BY exam_score_percent ASC
LIMIT 10;



