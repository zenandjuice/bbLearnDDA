-- returns a student's assignment attempts along with the Submission Receipt UUID, attempt number, file name, and file size 
-- chris bray (cbray@uark.edu)

SELECT cm.course_id, aru.user_id, gm.title, a.grade, a.attempt_date, ar.UUID AS "Submission Receipt", ar.gradebook_title, ar.submission_date, ar.num_of_submission_attempt as "Submission Number",arf.file_name, arf.file_size
FROM attempt a
INNER JOIN gradebook_grade gg ON a.gradebook_grade_pk1 = gg.pk1
INNER JOIN gradebook_main gm ON gg.gradebook_main_pk1 = gm.pk1
INNER JOIN attempt_receipt ar ON a.pk1 = ar.attempt_pk1
LEFT JOIN attempt_receipt_file arf ON ar.pk1 = arf.attempt_receipt_pk1
LEFT JOIN attempt_receipt_user aru ON ar.pk1 = aru.attempt_receipt_pk1
LEFT JOIN course_main cm ON ar.crs_main_pk1 = cm.pk1
WHERE cm.course_id = '[course_id]'
-- uncomment to search for one student
-- AND aru.user_id = '[username]'
ORDER by ATTEMPT_DATE


-- Attempts with no file extensions

SELECT cm.course_id, aru.user_id, gm.title, a.grade, a.attempt_date, ar.UUID AS "Submission Receipt", ar.num_of_submission_attempt as "Submission Number", ar.gradebook_title, ar.submission_date, arf.file_name, arf.file_size
FROM attempt a
INNER JOIN gradebook_grade gg ON a.gradebook_grade_pk1 = gg.pk1
INNER JOIN gradebook_main gm ON gg.gradebook_main_pk1 = gm.pk1
INNER JOIN attempt_receipt ar ON a.pk1 = ar.attempt_pk1
LEFT JOIN attempt_receipt_file arf ON ar.pk1 = arf.attempt_receipt_pk1
LEFT JOIN attempt_receipt_user aru ON ar.pk1 = aru.attempt_receipt_pk1
LEFT JOIN course_main cm ON ar.crs_main_pk1 = cm.pk1
WHERE arf.file_name NOT LIKE '%.%'
-- uncomment to look for in course, otherwise it searches all courses
--AND cm.course_id = '[course_id]'
ORDER by ATTEMPT_DATE
