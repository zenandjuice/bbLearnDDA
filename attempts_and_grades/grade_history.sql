-- Returns grade history information
-- cbray@uark.edu

select
	cm.course_id as "Course ID",
	gl.username as "Student Username",
	gl.firstname as "Student Firstname",
	gl.lastname as "Student Lastname",
	gm.title as "Gradebook Title",
	gl.grade as "Grade",
	gl.numeric_grade as "Numeric Grade",
    	ar.UUID AS "Submission Receipt", 	ar.num_of_submission_attempt as "Submission Number",
   	gm.grades_released,
	gm.auto_post_grades_ind,
    	--gl.gradebook_main_pk1,
	gl.attempt_creation as "Attempt Date",
	gl.modifier_ipaddress as "IP Address",
	gl.modifier_username as "Modifier Username",
	gl.modifier_firstname as "Modifier Firstname",
	gl.modifier_lastname as "Modifier Lastname",
	gl.modifier_role as "Modifier Course Role",
	gl.event_key,
	gl.date_logged as "Date Logged",
	gl.graded_anonymously_ind "as Graded Anonymous?",
	gl.anonymizing_id,
    	gl.deletion_event_ind as "Deleted Y or N",
	gl.exempt_ind as "Exemption Indicator",
	gl.instructor_comments,
	gl.for_student_comments
from gradebook_log gl
JOIN gradebook_main gm ON gm.pk1 = gl.gradebook_main_pk1
JOIN course_main cm ON cm.pk1 = gm.crsmain_pk1
left join attempt a on a.pk1 = gl.attempt_pk1 
left join attempt_receipt ar on ar.attempt_pk1 = a.pk1
where cm.course_id = '[course_id]
--and gm.title like '%Exam 3'
and gl.username = '[student username]'
-- use modifier_username to see rows modified by a specific user, such as a REST user
-- and gl.modifier_username = '[modifier username]'
-- only for certain date ranges
--and gl.date_logged between '01/25/2023 00:00:00' and '05/02/2023 23:59:59'
ORDER by cm.course_id, username, date_logged
