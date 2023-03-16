-- this returns a specified user or course and shows the enrollment history
-- based on a query from Corrie Bergeron

select cm.course_id, u.user_id, cu.role, 
    CASE 
        WHEN cu.ROW_STATUS = 0 THEN 'Enabled'
        WHEN cu.ROW_STATUS = 2 THEN 'Disabled'
        ELSE 'OTHER'
    END AS ROW_STATUS,
  cu.available_ind as "Availability",  
  dscu.batch_uid as "Enrollment DSK", 
  cu.enrollment_date as "Enrollment Date", 
  cu.dtmodified as "Date Enrollment Modified", 
  cu.last_access_date as "Last Access Date",  
  cm.start_date as "Course Start Date",
  cm.end_date  as "Course End Date",
  cu.bypass_course_avail_until "Extented Access Until",
  cm.dtcreated as "Date Course Created"
FROM course_users cu
JOIN course_main cm ON cu.crsmain_pk1 = cm.pk1
JOIN users u ON cu.users_pk1 = u.pk1
INNER JOIN DATA_SOURCE dscu ON cu.data_src_pk1 = dscu.pk1
WHERE u.user_id = '[user_id]'
--WHERE cm.course_id = '[course_id]'
--order by cu.enrollment_date DESC
order by cm.course_id 
