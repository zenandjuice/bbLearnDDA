-- VERIFY course verifications
-- After looking over course access dates and other criteria, I narrow down which courses can be deleted, and run a final verification check using these queries
-- Any suspicious course gets moved to a "VERIFY" DSK first.


--- Phase 1:  Check course file sizes

SELECT
	cm.course_id,
	pg_size_pretty(cs.size_coursefiles) AS "Content Collection",
	pg_size_pretty(cs.size_protectedfiles) AS "Submisssions",
	pg_size_pretty(cs.size_legacyfiles) AS "Legacy Files",
	pg_size_pretty (cs.size_total) AS "Total Size"
FROM course_main cm
JOIN course_size cs ON (cm.pk1 = cs.crsmain_pk1)
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
WHERE dsc.batch_uid = 'VERIFY'
and cm.course_id like '%1229%'
--WHERE dsc.BATCH_UID in ('1998', '1202', '1205', '1208', '1212', '1215', '1218')
--ORDER by cs.size_coursefiles desc
order by cs.size_total DESC


---- Phase 2:  Check for student submissions

SELECT cm.course_id, u.user_id, gm.title, gm.score_provider_handle AS "Item Type", a.attempt_date as "Attempt Date", a.last_graded_date, a.grade
FROM attempt a
INNER JOIN gradebook_grade gg ON a.gradebook_grade_pk1 = gg.pk1
INNER JOIN gradebook_main gm ON gg.gradebook_main_pk1 = gm.pk1
INNER JOIN gradebook_type gt ON gm.gradebook_type_pk1 = gt.pk1
INNER JOIN course_users cu ON gg.course_users_pk1 = cu.pk1
INNER JOIN users u ON cu.users_pk1 = u.pk1
INNER JOIN course_main cm on cu.crsmain_pk1 = cm.pk1
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
WHERE dsc.batch_uid = 'VERIFY'
and cm.course_id like '%1229%'
-- WHERE dsc.BATCH_UID in ('1998', '1202', '1205', '1208', '1212', '1215', '1218')
order by cm.course_id, u.user_id, a.attempt_date


-- courses with grades that were all manually entered
select
  CM.COURSE_ID AS "Course",
  U.USER_ID AS "Username",
  U.FIRSTNAME AS "First Name",
  U.LASTNAME AS "Last Name",
  gm.display_title,
  GM.TITLE AS "Assignment",
  a.grade,
gm.score_provider_handle,
gm.course_contents_pk1
from gradebook_grade gg
INNER JOIN gradebook_main gm ON gg.gradebook_main_pk1 = gm.pk1
inner join attempt a on gg.pk1 = a.gradebook_grade_pk1
INNER JOIN course_users cu ON gg.course_users_pk1 = cu.pk1
INNER JOIN course_main cm on cu.crsmain_pk1 = cm.pk1
INNER JOIN users u ON cu.users_pk1 = u.pk1
INNER JOIN course_main on gm.CRSMAIN_PK1 = course_main.PK1
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
WHERE dsc.batch_uid = 'VERIFY'
and cm.course_id like '%1229%'
ORDER BY CM.COURSE_ID, U.USER_ID, GM.PK1, GM.TITLE


------ Phase 3 - last STUDENT logins

SELECT cm.course_id,
  CASE
    WHEN CM.ROW_STATUS = 0 THEN 'Enabled'
    WHEN CM.ROW_STATUS = 2 THEN 'Disabled'
    ELSE 'OTHER'
    END AS ROW_STATUS,
    cm.AVAILABLE_IND,
    cm.end_date,
max(cu.last_access_date)
FROM course_main cm
LEFT JOIN course_users cu ON cm.pk1 = cu.crsmain_pk1
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
WHERE dsc.batch_uid = 'VERIFY'
and cm.course_id like '%1229%'
-- WHERE dsc.BATCH_UID in ('1998', '1202', '1205', '1208', '1212', '1215', '1218')
-- only check for student last access
and cu.role = 'S'
GROUP BY cm.course_id, CM.ROW_STATUS, cm.AVAILABLE_IND,cm.end_date


---- All student Activity in DSK courses, excludes ALly user and preview users, instructors and designers

SELECT
u.lastname,        u.firstname,        u.user_id,
--distinct(cm.course_id),
cm.course_id,
aa.timestamp,     aa.event_type,        aa.internal_handle,        cc.title,        aa.data,        aa.content_pk1,        aa.session_id
FROM activity_accumulator aa
INNER JOIN users u ON aa.user_pk1 = u.pk1
INNER JOIN course_users cu ON u.pk1 = cu.users_pk1
LEFT JOIN course_main cm ON aa.course_pk1 = cm.pk1
JOIN course_contents cc ON aa.content_pk1 = cc.pk1
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
WHERE dsc.batch_uid = 'VERIFY'
and cm.course_id like '%1229%'
-- WHERE dsc.BATCH_UID in ('1998', '1202', '1205', '1208', '1212', '1215', '1218')
and u.user_id not like 'bbrally'
and cu.role not in ('P', 'D')
and u.user_id not like '%_previewuser'
--WHERE aa.timestamp between '01/23/2022 00:00:00' and '01/30/2022 23:59:59'
--ORDER BY u.user_id, aa.timestamp ASC


----

--posted announcements in courses

SELECT cm.course_id, cm.pk1, u.USER_ID , aa.SUBJECT, aa.ANNOUNCEMENT, aa.DTCREATED, aa.DTMODIFIED
FROM course_main cm
JOIN announcements aa ON cm.pk1 = aa.crsmain_pk1
JOIN USERS u ON u.pk1 = aa.USERS_PK1
-- AND cm.row_status     ='0'
-- AND cm.available_ind  ='Y'
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
WHERE dsc.batch_uid = 'VERIFY'
ORDER BY   cm.course_id


----

-- Items listed in content folders

SELECT
  cm.course_id,
  CASE
     WHEN cc.folder_ind = 'Y' THEN 'Folder'
     ELSE 'Other'
  END as folder,
  ccp.title as "Parent Title",
  cc.content_type,
  cc.position,
  cc.title,
  cc.main_data
FROM course_main cm
INNER JOIN course_contents cc ON cc.crsmain_pk1 = cm.pk1
left join course_contents ccp on cc.parent_pk1 = ccp.pk1
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
WHERE dsc.batch_uid = 'VERIFY'
and cm.course_id like '%1229%'
and ccp.title is not null
ORDER BY cm.course_id, cc.PARENT_PK1 NULLS FIRST, cc.position




-- Find added on items in Course Menu

select cm.course_id,
    ct.label as "Menu Label",
    ct.pk1 as "Menu Item pk1",
    ct.internal_handle
from course_main cm join course_toc ct on ct.crsmain_pk1=cm.pk1
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
WHERE dsc.batch_uid = 'VERIFY'
and cm.course_id like '%1229%'
and ct.label not like 'COURSE_DEFAULT.%'
and ct.label not in ('Announcements', 'Send Email', 'My Grades', 'Help', 'Tools', 'Home Page')
order by cm.course_id, ct.position


-- Are discussions in use?

select cm.course_id, fm."name", fm.dtmodified, mm.subject, mm.posted_name
FROM FORUM_MAIN fm
JOIN msg_main mm on fm.pk1 = mm.forummain_pk1
JOIN conference_main confm on confm.pk1 = fm.CONFMAIN_PK1
JOIN course_main cm on cm.pk1 = confm.CRSMAIN_PK1
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
WHERE dsc.batch_uid = 'VERIFY'
and cm.course_id like '%1229%'
