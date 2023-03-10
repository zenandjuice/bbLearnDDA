-- main query that I use for tracking user activity in the system
-- uncomment lines for different search criteria

SELECT u.pk1,
       u.lastname,
       u.firstname,
       u.user_id,
       -- u.uuid as "User UUID",
       cm.course_id,
       -- cm.uuid as "Course UUID",
       aa.timestamp,
       cc.title,
       aa.data,
       aa.internal_handle,
       aa.content_pk1,
       aa.session_id,
       aa.event_type
FROM activity_accumulator aa
INNER JOIN users u ON aa.user_pk1 = u.pk1
LEFT JOIN course_main cm ON aa.course_pk1 = cm.pk1
-- left join because some entries like journals don't have a content object associated
left JOIN course_contents cc ON aa.content_pk1 = cc.pk1
WHERE aa.timestamp between '01/01/2023 00:00:00' and '03/13/2023 23:59:59'
-- username
AND u.user_id = '[username]'
--AND u.user_id IN ('[username#1]', '[username#2]')
-- exclude ally rest user (replace username with your system's REST user)
--and u.user_id not in ('bbrally')
-- Return data from specific course
and cm.course_id = '[course_id]'
--and cm.course_id like '%[course_id string]%'
--OR cm.course_id IS NULL
--AND cm.course_id IN ('[course_id#1]', '[course_id#2]', '[course_id#3]', '[course_id#4]')
--AND cc.title LIKE 'Homework%'
--and aa.data not like '%handler%'
--and aa.data like '%assessment%'
--AND aa.DATA LIKE '%assignment%' 
--and aa.data = 'mobile.submit.assignment'
--and aa.internal_handle like '%journal%'
--and aa.internal_handle like '%assessment%'
--and aa.content_pk1 = '12345678'
-- handles to return the Building Block page
--and aa.internal_handle in ('pa_ext', 'admin_plugin_manage')
--ORDER BY u.user_id, aa.timestamp ASC
ORDER BY aa.timestamp asc
