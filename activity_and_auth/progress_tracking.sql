-- Ultra Progress Tracking
-- cbray@uark.edu

SELECT cm.course_id, 
       CASE
       WHEN cm.progress_tracking_ind = 'Y' THEN 'Enabled'
       WHEN cm.progress_tracking_ind = 'N' THEN 'No (Original)'
       WHEN cm.progress_tracking_ind = 'O' THEN 'No (Ultra)'
        ELSE 'OTHER'
        END AS progress_tracking_ind,
  CASE 
    WHEN cm.course_view_option = 'I' THEN 'Instructor Choice'
    WHEN cm.course_view_option = 'U' THEN 'Ultra'
    WHEN cm.course_view_option = 'C' THEN 'Original'
    ELSE 'OTHER'
    END AS "Course View Option",
  CASE 
    WHEN cm.ultra_status = 'N' THEN 'Undecided'
    WHEN cm.ultra_status = 'C' THEN 'Classic'
    WHEN cm.ultra_status = 'U' THEN 'Ultra'
    WHEN cm.ultra_status = 'P' THEN 'Ultra Preview'
    ELSE 'OTHER'
    END AS "Ultra Status",
        u.user_id, cc.title, cc.tracking_ind, aa.data, aa."timestamp" 
FROM activity_accumulator aa
INNER JOIN users u ON aa.user_pk1 = u.pk1
LEFT JOIN course_main cm ON aa.course_pk1 = cm.pk1
JOIN course_contents cc ON aa.content_pk1 = cc.pk1
-- term courses are in a unique DSK, so we can look for all courses within that DSK
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
WHERE dsc.batch_uid = '1233'
-- timestamp searches
--WHERE aa.timestamp between '01/01/2022 00:00:00' and '03/27/2022 23:59:59'
--specific course
--WHERE cm.course_id = '[course_id]'
and cm.progress_tracking_ind = 'Y'
order by cm.course_id, u.user_id, aa."timestamp" 
