-- Returns courses that might not have been prepared yet
-- Availability, Instructor Details, Courses copied from, student enrollment count


SELECT
	cm.course_id AS "Blackboard Learn Course ID", cm.course_name,
	cm2.course_id AS "Child Course",
	cm.available_ind as "Availability", 
	   CASE 
        WHEN cm.ROW_STATUS = 0 THEN 'ENABLED'
        WHEN cm.ROW_STATUS = 2 THEN 'DISABLED'
        ELSE 'OTHER'
       END AS "Row Status",
	cm.start_date, cm.end_date,
	STRING_AGG(u.email, ';') AS "Instructor Emails",
	string_agg(distinct u.firstname||' '||u.lastname, ', ') as "Instructor Names",
	cm.copy_from_uuids,
	count(cu2.pk1) as "Student Enrollment Count"
FROM course_main cm
INNER JOIN data_source ds ON cm.data_src_pk1 = ds.pk1
INNER JOIN course_users cu ON cm.pk1 = cu.crsmain_pk1
inner join course_users cu2 on cm.pk1 = cu2.crsmain_pk1 
INNER JOIN users u ON cu.users_pk1 = u.pk1
LEFT join course_course cc2 ON cc2.CRSMAIN_PARENT_PK1 = cm.pk1
LEFT join course_main cm2 on cc2.CRSMAIN_PK1=cm2.pk1
-- each term has a unique DSK
WHERE ds.batch_uid = '1233'
-- online courses have a section range
and cm.course_id like '%SEC9%'
-- only designated 8W2 courses
-- and cm.course_name like '%8W2%'
AND cu.role IN ('P')
and cu.row_status = '0'
and cm.pk1 not in (select course_course.crsmain_pk1 from course_course)
and cu2.role = 'S'
and cu2.row_status = '0'
group by cm.course_id, cm.course_name, cm2.course_id, cm.available_ind, cm.row_status, cm.start_date, cm.end_date, cm.copy_from_uuids
ORDER BY cm.course_id
