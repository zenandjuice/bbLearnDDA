-- Returns grade history information

select
	cm.course_id,
	gm.grades_released,
	gm.auto_post_grades_ind,
	gl.username,
	gl.firstname,
	gl.lastname,
	gl.grade,
    gl.numeric_grade,
    gl.gradebook_main_pk1,
    gm.title,
	gl.attempt_creation,
	gl.modifier_ipaddress,
	gl.modifier_role,
	gl.modifier_username,
	gl.modifier_firstname,
	gl.modifier_lastname,
	gl.event_key,
	gl.date_logged,
	gl.graded_anonymously_ind,
	gl.anonymizing_id,
    gl.deletion_event_ind,
	gl.exempt_ind,
	gl.instructor_comments,
	gl.for_student_comments
from gradebook_log gl
JOIN gradebook_main gm ON gm.pk1 = gl.gradebook_main_pk1
JOIN course_main cm ON cm.pk1 = gm.crsmain_pk1
WHERE cm.course_id = '[course_id]'
--and gm.title like 'Exam 3'
and gl.modifier_username LIKE '[username]'
and gl.date_logged between '04/25/2023 00:00:00' and '05/02/2023 23:59:59'
ORDER by cm.course_id, username, date_logged
