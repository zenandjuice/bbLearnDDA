-- Returns Grades and Goal detail when goal is aligned to a grade center column (grades via attempts and manual grade)

select
cm.COURSE_ID,
string_agg(distinct u2.firstname||' '||u2.lastname, ', ') as instructors,
string_agg(distinct u2.email, ', ') as instructors_email,
u.USER_ID as "Student Username",
u.student_id,
   u.department AS "College and Department",
	CASE
	    WHEN u.educ_level = '0'then ' '
	    WHEN u.educ_level = '13' THEN 'Freshman'
	    WHEN u.educ_level = '14' THEN 'Sophomore'
	    WHEN u.educ_level = '15' THEN 'Junior'
	    WHEN u.educ_level = '16' THEN 'Senior'
	    WHEN u.educ_level = '18' THEN 'Graduate School'
	    WHEN u.educ_level = '20' THEN 'Post Graduate School'
	  END AS "Education Level",
cca.BATCH_UID as "Goal ID",
  ls.label as "Goal Type",
  csog.description as "Goal Description",
	gm.title AS "Grade Center Column Name",
    gm.display_title AS "Instructor Column Display Name",
CASE
    	WHEN gm.aggregation_model = '1' THEN 'Last Graded Attempt'
	    WHEN gm.aggregation_model = '2' THEN 'Highest Attempt'
	    WHEN gm.aggregation_model = '3' THEN 'Lowest Attempt'
	    WHEN gm.aggregation_model = '4' THEN 'First Graded Attempt'
	    ELSE 'Average'
    END AS AGGREGATION_MODEL,
    gm.pk1 as "Column Unique Identifer",
    gm.POSSIBLE as "Points Possible",
 gg.manual_grade as "Manual Grade (gg)",
 gg.MANUAL_SCORE as "Manual Score (gg)",
 a.grade as "Grade (attempt)",
 a.SCORE as "Score (Attempt)",
 a.ATTEMPT_DATE,
 a.DATE_MODIFIED,
gm.DUE_DATE
from gradebook_grade gg
INNER JOIN gradebook_main gm ON gg.gradebook_main_pk1 = gm.pk1
LEFT join attempt a on gg.pk1 = a.gradebook_grade_pk1
-- cu & u = student
INNER JOIN course_users cu ON gg.course_users_pk1 = cu.pk1
INNER JOIN course_main cm on cu.crsmain_pk1 = cm.pk1
INNER JOIN users u ON cu.users_pk1 = u.pk1
INNER JOIN CLP_ALIGNABLE_CONTENT cac ON cac.gradebook_main_pk1 = gm.pk1
LEFT JOIN CLP_CONTENT_ALIGNMENT cca ON cca.clp_alignable_content_pk1 = cac.pk1
LEFT JOIN LRN_STDS_CRS_MAIN lscm ON lscm.crs_main_pk1 = cm.pk1
LEFT JOIN CLP_SOG csog ON csog.batch_uid = cca.batch_uid
LEFT JOIN lrn_standard ls ON ls.clp_sog_pk1 = csog.pk1
-- cu2 & u = instructor
JOIN course_users cu2 ON cm.pk1 = cu2.crsmain_pk1
JOIN users u2 ON cu2.users_pk1 = u2.pk1
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
--join gradebook_translator gt on gm.gradebook_translator_pk1 = gt.pk1
--join gradebook_translator gt2 on gm.secondary_translator_pk1 = gt2.pk1
-- specific course
--WHERE cm.COURSE_ID = '[course_id]'
-- specific goal ID
WHERE cca.BATCH_UID LIKE '%'
and cu.role ='S' and cu.row_status = '0'
and cu2.role = 'P' and cu2.row_status = '0'
-- search specific course subjects
and cm.course_id like '%NURS%'
and u.user_id not like '%_previewuser'
-- non-dropped students only
and cu.row_status = '0'
-- omit deleted columns
and gm.deleted_ind = 'N'
group by cm.course_id, u.user_id,u.student_id, u.department, u.educ_level, cca.BATCH_UID,ls.label,csog.description,gm.title,gm.pk1,gm.aggregation_model,a.SCORE,a.GRADE,gm.POSSIBLE,a.ATTEMPT_DATE,a.DATE_MODIFIED,gg.MANUAL_GRADE, gg.MANUAL_SCORE,gm.DUE_DATE
ORDER BY U.USER_ID, cm.COURSE_ID, gm.TITLE
