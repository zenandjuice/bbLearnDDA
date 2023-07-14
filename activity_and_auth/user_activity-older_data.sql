-- Uses _stats schema to get Course activity older than the 180 days stored in the main schema activity_accumulator table
-- alter schema to be _stats

SELECT u.user_id AS Username, u.uuid as "User UUID", u.pk1 as "User PK1", cm.pk1 as "Course PK1", cm.course_id, aa.timestamp, aa.event_type, aa.internal_handle, aa.data, aa.session_id
	FROM activity_accumulator aa
	JOIN course_main cm ON aa.course_pk1 = cm.pk1
	JOIN users u ON aa.user_pk1 = u.pk1
WHERE cm.course_id = '[course_id]'
AND aa.timestamp between '03/01/2018 00:00:00' and '03/13/2023 23:59:59'
--AND u.user_id = '[username]'
ORDER by timestamp DESC
