-- Pulls cached overall grade for students within a specific course DSK.

SELECT
  cm.course_id,
  u.user_id, u.department, gm.title AS "Grade Center Title", ggc.score, ggc.possible, (ggc.score/ggc.possible)*100 as "Percent", 
    CASE 
        WHEN (ggc.score/ggc.possible)*100 >= 90 THEN 'A'
        WHEN (ggc.score/ggc.possible)*100 between 80 and 90 THEN 'B'
        WHEN (ggc.score/ggc.possible)*100 between 70 and 80 THEN 'C'
        WHEN (ggc.score/ggc.possible)*100 between 60 and 70 THEN 'D'
        WHEN (ggc.score/ggc.possible)*100 < 60 THEN 'F'
        ELSE 'OTHER'
    END AS ESTIMATED_LETTER_GRADE,
    ggc.dtmodified
FROM gradebook_main gm
  JOIN course_main cm on cm.pk1 = gm.crsmain_pk1
  join gradebook_grade_calc ggc on gm.pk1 = ggc.gradebook_main_pk1
  join course_users cu on ggc.course_users_pk1 = cu.pk1
  JOIN users u on u.pk1 = cu.users_pk1
  INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
WHERE dsc.batch_uid = '[COURSE DSK]'
and cu.role = 'S' and cu.row_status = '0'
and u.user_id not like '%_previewuser'
and gm.title = 'Overall Grade'
AND gm.deleted_ind = 'N' -- only non-deleted columns
and ggc.score is not null
-- AND (ggc.score/ggc.possible)*100 < 70   -- D's & F's
--and LOWER(u.department) like LOWER('%ENGR%')
-- only shows unposted grades
--  and grades.pending_manual_grade is not null
--AND gbm.calculated_ind = 'N'    -- we probably only need to return non-calculated columns
-- and gbm.calculated_ind not in ('T', 'W')    -- omit total and weighted columns
ORDER BY u.user_id, cm.course_id
