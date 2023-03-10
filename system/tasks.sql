-- Running Course Copy Tasks

SELECT cm.course_id, QT.PK1 as "TasK PK1", QT.DTCREATED, QT.DTMODIFIED, QT.TITLE, 
CASE
	WHEN qt.task_type='CourseDelete' THEN 'Course Delete Queued Operation'
	WHEN qt.task_type='X' THEN 'Import/Export/Archive/Restore'
	WHEN qt.task_type='RecycleTask' THEN 'Bulk Delete'
	WHEN qt.task_type='introduce_affiliate_handler' THEN 'Conver to Ultra'
	WHEN qt.task_type='convertTOUltraQueuedOperation' THEN 'Convert to Ultra'
	WHEN qt.task_type='N' THEN 'Post Creation'
	WHEN qt.task_type='downloadQueuedOperation' THEN 'plugin.queuetask.type.download'
	WHEN qt.task_type='ChangeAvailableFromList' THEN 'Course/User Bulk Action: Change Availability'
	WHEN qt.task_type='update_grade_center' THEN 'Update Grade Center Data'
	WHEN qt.task_type='update_tool_settings' THEN 'Update Tool Settings'
	WHEN qt.task_type='AutoArchive' THEN 'AutoArchive'
	WHEN qt.task_type='DeleteFromList' THEN 'Course/User Bulk Action: Delete'
	WHEN qt.task_type='C' THEN 'Course Copy'
	WHEN qt.task_type='ultraEnabledQueuedOperation' THEN 'Ultra Enabled Queue Operation'
	ELSE 'OTHER'
	END AS TASK_TYPE,	
 CASE 
    WHEN QT.STATUS = 'A' THEN 'Assigned'
	WHEN QT.STATUS = 'C' THEN 'Completed'
	WHEN QT.STATUS = 'E' THEN 'Complete, with errors'
	WHEN QT.STATUS = 'I' THEN 'Incomplete'
    WHEN QT.STATUS = 'R' THEN 'Running'
    WHEN QT.STATUS = 'W' THEN 'Waiting'
    ELSE 'OTHER'
    END AS STATUS,
    U.user_id
from QUEUED_TASKS QT
JOIN users u ON QT.users_pk1 = u.pk1
join course_main cm on cm.pk1 = qt.course_main_pk1 
WHERE QT.TASK_TYPE = 'C'
AND STATUS NOT LIKE 'C'



-- Ultra Course Related Tasks
SELECT cm.course_id, QT.PK1 as "Task PK1", QT.DTCREATED, QT.DTMODIFIED, QT.TITLE,
CASE
	WHEN qt.task_type='CourseDelete' THEN 'Course Delete Queued Operation'
	WHEN qt.task_type='X' THEN 'Import/Export/Archive/Restore'
	WHEN qt.task_type='RecycleTask' THEN 'Bulk Delete'
	WHEN qt.task_type='introduce_affiliate_handler' THEN 'Conver to Ultra'
	WHEN qt.task_type='convertTOUltraQueuedOperation' THEN 'Convert to Ultra'
	WHEN qt.task_type='N' THEN 'Post Creation'
	WHEN qt.task_type='downloadQueuedOperation' THEN 'plugin.queuetask.type.download'
	WHEN qt.task_type='ChangeAvailableFromList' THEN 'Course/User Bulk Action: Change Availability'
	WHEN qt.task_type='update_grade_center' THEN 'Update Grade Center Data'
	WHEN qt.task_type='update_tool_settings' THEN 'Update Tool Settings'
	WHEN qt.task_type='AutoArchive' THEN 'AutoArchive'
	WHEN qt.task_type='DeleteFromList' THEN 'Course/User Bulk Action: Delete'
	WHEN qt.task_type='C' THEN 'Course Copy'
	WHEN qt.task_type='ultraEnabledQueuedOperation' THEN 'Ultra Enabled Queue Operation'
	ELSE 'OTHER'
	END AS TASK_TYPE,	
 CASE 
    WHEN QT.STATUS = 'A' THEN 'Assigned'
	WHEN QT.STATUS = 'C' THEN 'Completed'
	WHEN QT.STATUS = 'E' THEN 'Complete, with errors'
	WHEN QT.STATUS = 'I' THEN 'Incomplete'
    WHEN QT.STATUS = 'R' THEN 'Running'
    WHEN QT.STATUS = 'W' THEN 'Waiting'
    ELSE 'OTHER'
    END AS STATUS,
    U.user_id, qt.arguments, qt.results
from QUEUED_TASKS QT
JOIN users u ON QT.users_pk1 = u.pk1
left join course_main cm on cm.pk1 = qt.course_main_pk1
WHERE LOWER(QT.TASK_TYPE) like LOWER('%ultra%')
order by dtmodified desc





-- Tasks ran by specific user
SELECT cm.course_id, QT.PK1 as "Task PK1", QT.DTCREATED, QT.DTMODIFIED, QT.TITLE,
CASE
	WHEN qt.task_type='CourseDelete' THEN 'Course Delete Queued Operation'
	WHEN qt.task_type='X' THEN 'Import/Export/Archive/Restore'
	WHEN qt.task_type='RecycleTask' THEN 'Bulk Delete'
	WHEN qt.task_type='introduce_affiliate_handler' THEN 'Conver to Ultra'
	WHEN qt.task_type='convertTOUltraQueuedOperation' THEN 'Convert to Ultra'
	WHEN qt.task_type='N' THEN 'Post Creation'
	WHEN qt.task_type='downloadQueuedOperation' THEN 'plugin.queuetask.type.download'
	WHEN qt.task_type='ChangeAvailableFromList' THEN 'Course/User Bulk Action: Change Availability'
	WHEN qt.task_type='update_grade_center' THEN 'Update Grade Center Data'
	WHEN qt.task_type='update_tool_settings' THEN 'Update Tool Settings'
	WHEN qt.task_type='AutoArchive' THEN 'AutoArchive'
	WHEN qt.task_type='DeleteFromList' THEN 'Course/User Bulk Action: Delete'
	WHEN qt.task_type='C' THEN 'Course Copy'
	WHEN qt.task_type='ultraEnabledQueuedOperation' THEN 'Ultra Enabled Queue Operation'
	ELSE 'OTHER'
	END AS TASK_TYPE,	
 CASE 
    WHEN QT.STATUS = 'A' THEN 'Assigned'
	WHEN QT.STATUS = 'C' THEN 'Completed'
	WHEN QT.STATUS = 'E' THEN 'Complete, with errors'
	WHEN QT.STATUS = 'I' THEN 'Incomplete'
    WHEN QT.STATUS = 'R' THEN 'Running'
    WHEN QT.STATUS = 'W' THEN 'Waiting'
    ELSE 'OTHER'
    END AS STATUS,
    U.user_id, qt.arguments, qt.results
from QUEUED_TASKS QT
JOIN users u ON QT.users_pk1 = u.pk1
left join course_main cm on cm.pk1 = qt.course_main_pk1
where u.user_id = '[user_id]'
order by dtmodified desc

