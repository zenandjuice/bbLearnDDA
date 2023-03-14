-- Returns the courses and assignment title for SafeAssignments, embedded into the Assignment tool (New Method SafeAssign)
-- basic query found somewhere, and modified to pull GM.TITLE SELECT cm.COURSE_ID, gm.title as "Assignment Name"

FROM COURSE_MAIN cm
JOIN mdb_safeassign_item msi ON (msi.crsmain_pk1 = cm.PK1)
JOIN gradebook_main gm ON gm.pk1 = msi.GRADEBOOK_MAIN_PK1
INNER JOIN DATA_SOURCE dsc ON cm.data_src_pk1 = dsc.pk1 
--WHERE dsc.batch_uid = '1226'
WHERE dsc.batch_uid IN ('1219', '1223', '1226')
ORDER by cm.course_id


-- SafeAssign Assignment Count with Instructor
SELECT cm.COURSE_ID, count(gm.title) as "SA Assignment Count",
u.email as Instructor
FROM COURSE_MAIN cm
JOIN mdb_safeassign_item msi ON (msi.crsmain_pk1 = cm.PK1)
JOIN gradebook_main gm ON gm.pk1 = msi.GRADEBOOK_MAIN_PK1
INNER JOIN course_users cu ON cm.pk1 = cu.crsmain_pk1
INNER JOIN users u ON cu.users_pk1 = u.pk1
INNER JOIN DATA_SOURCE dsc ON cm.data_src_pk1 = dsc.pk1 
WHERE dsc.batch_uid = '1233'
--WHERE dsc.batch_uid IN ('1219', '1223', '1229')
AND cu.role IN ('P')
GROUP by cm.course_id, u.email
order by cm.course_id


--- Grade Center grades for SafeAssign assignments select
  cm.course_id,
  u.user_id,
  gm.title,
  gg.manual_grade,
  att.date_added,
  att.grade,
  att.instructor_comments,
  gg.for_student_comments
from gradebook_grade gg
join gradebook_main gm on gg.gradebook_main_pk1 = gm.pk1
join attempt att on gg.last_graded_attempt_pk1 = att.pk1
join course_users cu on gg.course_users_pk1 = cu.pk1
join users u on cu.users_pk1 = u.pk1
join course_main cm on gm.crsmain_pk1 = cm.pk1
JOIN mdb_safeassign_item msi ON gm.pk1 = msi.gradebook_main_pk1 
-- where gg.for_student_comments is not null
where cm.course_id = 'course_id'
  --and u.user_id not like '%_previewuser'
ORDER BY gm.title
