-- which courses have Kaltura media galleries linked in the Course Menu (B2)

SELECT
  cm.course_id,
  ct.label as "Course Menu Item",
  u.user_id as "Instructor Username",
  u.FIRSTNAME as "Instructor First Name",
  u.lastname as "Instructor Last Name",
  u.email as "Instructor Email Address"  --,  count(cc.pk1) as howmany
from course_toc ct
join course_main cm on ct.crsmain_pk1 = cm.pk1
join course_users cu on cm.pk1 = cu.crsmain_pk1 
INNER JOIN users u ON cu.users_pk1 = u.pk1
where cu.role = 'P'
AND ct.internal_handle = 'osv-kaltura-lti-nav-2'
ORDER BY cm.course_id


-- Media Gallery LTI

SELECT
  cm.course_id,
  cc.cnthndlr_handle as "Publisher Tool",
  cc.title, cc.*
-- STRING_AGG(u.email, ';') AS emails,
-- string_agg(distinct u.firstname||' '||u.lastname, ', ') as instructors
  --,  count(cc.pk1) as howmany
from course_contents cc
join course_main cm on cc.crsmain_pk1 = cm.pk1
join course_users cu on cm.pk1 = cu.crsmain_pk1 
INNER JOIN users u ON cu.users_pk1 = u.pk1
WHERE cm.row_status     ='0'
and cu.role = 'P'
AND cc.cnthndlr_handle = 'resource/x-bb-bltiplacement-KalturaMediaGallery-CT'
--AND (cc.cnthndlr_handle = 'resource/x-osv-kaltura/mashup' or cc.cnthndlr_handle = 'resource/x-osv-kaltura')
--GROUP BY cm.course_id, cc.cnthndlr_handle, cc.title 
ORDER BY cm.course_id


--LTI links via web_url
-- extended data contains	<entry key="placementHandle">	KalturaBSE</entry


select distinct(cc.pk1) as "Content pk1",
 cm.course_id, cm.pk1 as "Course PK1",
 STRING_AGG(u.email, ';') AS emails,
 string_agg(distinct u.firstname||' '||u.lastname, ', ') as instructors,
 cc.title as "Link Title",
 ccp.title as "Folder Title",
 cc.cnthndlr_handle as "Tool",
 cc.link_ref,
 cc.web_url
FROM course_main cm
INNER JOIN course_contents cc ON cc.crsmain_pk1 = cm.pk1
left join course_contents ccp on cc.parent_pk1 = ccp.pk1
join course_users cu on cm.pk1 = cu.crsmain_pk1
join users u on cu.users_pk1 = u.pk1 
where cc.cnthndlr_handle = 'resource/x-bb-blti-link'
and cc.extended_data like '%kaltura%'
and cc.web_url like '%kaltura%'
--and cm.course_id = '[course_id]'
AND cu.role = 'P'
--and cc.web_url != 'https://connect.router.integration.prod.mheducation.com/v1/lms/ltiv1p3'
GROUP BY cc.pk1, cm.course_id, cm.pk1, cc.title, ccp.title
order by cm.course_id




-- Kaltura Video Quiz (LTI)

select distinct(cc.pk1) as "Content pk1",
cm.course_id as "Course ID",
 STRING_AGG(u.email, ';') AS "Instructor Emails",
 string_agg(distinct u.firstname||' '||u.lastname, ', ') as "Instructors",
 cc.title as "Link Title",
 ccp.title as "Folder Title",
 cc.available_ind as "Available",
 cc.cnthndlr_handle as "Tool",
 cc.link_ref,
 cc.web_url
FROM course_main cm
INNER JOIN course_contents cc ON cc.crsmain_pk1 = cm.pk1
left join course_contents ccp on cc.parent_pk1 = ccp.pk1
join course_users cu on cm.pk1 = cu.crsmain_pk1
join users u on cu.users_pk1 = u.pk1 
where cc.cnthndlr_handle = 'resource/x-bb-blti-link'
and cc.extended_data like '%KalturaIVQ%'
--and cm.course_id like '%[course_id string]%'
AND cu.role = 'P'
GROUP BY cc.pk1, cm.course_id, cc.title, ccp.title
order by cm.course_id


------- Building Block Counts

-- Kaltura B2 Links (Mashups)

SELECT
   cm.course_id,   cc.cnthndlr_handle as "Publisher Tool",   cc.title
from course_contents cc
join course_main cm on cc.crsmain_pk1 = cm.pk1
join course_users cu on cm.pk1 = cu.crsmain_pk1 
INNER JOIN users u ON cu.users_pk1 = u.pk1
WHERE cm.row_status = '0'
and cu.role = 'P'
--AND cm.available_ind  ='Y'
AND cc.cnthndlr_handle like 'resource/x-osv-kaltura%'
ORDER BY cm.course_id


--- Kaltura B2 references in Itens

SELECT cm.course_id, u.user_id, cc.title, cc.cnthndlr_handle,
--cc.MAIN_DATA, 
cc.DTCREATED, cc.DTMODIFIED
FROM course_main cm
JOIN course_contents cc ON cm.pk1 = cc.crsmain_pk1
JOIN course_users cu ON cm.pk1 = cu.crsmain_pk1
JOIN users u ON cu.users_pk1 = u.pk1
--INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
-- AND cm.row_status     ='0'
-- AND cm.available_ind  ='Y'
WHERE cc.MAIN_DATA LIKE '%osv-kaltura-BB5fd0331bb7608%'
and cc.cnthndlr_handle != 'resource/x-osv-kaltura/mashup'
AND cu.role = 'P'
ORDER BY   cm.course_id



-- from Stefano Collovati (SaaS soon - UniBocconi, Italy)
-- string in announcements:

SELECT cm.course_id, u.USER_ID , aa.SUBJECT, aa.ANNOUNCEMENT, aa.DTCREATED, aa.DTMODIFIED
FROM course_main cm
JOIN announcements aa ON cm.pk1 = aa.crsmain_pk1
JOIN USERS u ON u.pk1 = aa.USERS_PK1
-- AND cm.row_status     ='0'
-- AND cm.available_ind  ='Y'
WHERE aa.announcement LIKE '%osv-kaltura%'
ORDER BY   cm.course_id


-- Discussions - FIND ALL entries containing a specific string

SELECT u.pk1,
       u.user_id,
       MM.DTCREATED,
       cm.course_id,
       fm.name AS "Forum Name",
       mm.subject AS "Thread Subject",
       mm.LIFECYCLE,
       MM.POSTED_NAME,
       MM.MSG_TEXT
FROM MSG_MAIN MM
INNER JOIN users u ON MM.USERS_PK1 = u.pk1
JOIN forum_main fm on mm.FORUMMAIN_PK1 = fm.pk1
JOIN conference_main confm on confm.pk1 = fm.CONFMAIN_PK1
JOIN course_main cm on cm.pk1 = confm.CRSMAIN_PK1
WHERE MM.MSG_TEXT like '%osv-kaltura%'
ORDER BY DTCREATED


-- Kaltura B2 in Blogs & Journals

SELECT u.user_id as "Username", u.firstname, u.lastname, cm.course_id,
    CASE 
        WHEN cm.service_level = 'F' THEN 'Course'
        WHEN cm.service_level = 'C' THEN 'Org'
        ELSE 'OTHER'
    END AS Type,
b.journal_ind, b.title, be.CREATION_DATE AS "Blog Posted", be.UPDATE_DATE as "Blog Updated", be.TITLE AS "Entry Title", 
be.anonymous_ind,
CASE 
        WHEN be.status = '1' THEN 'Draft'
        WHEN be.status = '2' THEN 'Posted'
        ELSE 'OTHER'
    END AS Status,
f.file_name, f.link_name, be.DESCRIPTION AS "Blog Entry"
--,b.*,be.*
 FROM BLOG_ENTRY be
 INNER JOIN course_users cu ON be.CREATOR_USER_ID = cu.pk1
 INNER JOIN users u ON cu.users_pk1 = u.pk1
  inner join blogs b on be.blog_pk1 = b.pk1
 left join blog_entry_files bfe on BE.pk1 = bfe.blog_entry_pk1
  left join files f on bfe.files_pk1 = f.pk1
 JOIN course_main cm ON cu.crsmain_pk1 = cm.pk1
 where be.description like '%osv-kaltura%'
 
 
 
 -- Assessments with Kaltura B2 mashups
 
 SELECT cm.course_id, gm.title, qrd.pk1,
--qrd.data as "Answer Data",
qad.pk1
--qad.data as "Question Data"
FROM gradebook_main gm
    JOIN course_main cm ON cm.pk1 = gm.crsmain_pk1 
    JOIN gradebook_grade gg ON gm.pk1 = gg.gradebook_main_pk1 
    JOIN course_users cu ON cu.pk1 = gg.course_users_pk1 
    JOIN users u ON u.pk1 = cu.users_pk1 
    JOIN attempt a ON a.pk1 = gg.last_attempt_pk1 
    JOIN qti_result_data qrd ON qrd.parent_pk1 = (SELECT pk1 FROM qti_result_data WHERE parent_pk1 = a.qti_result_data_pk1) 
    JOIN qti_asi_data qad ON qad.pk1 = qrd.qti_asi_data_pk1 
-- questions with kaltura entries    
WHERE qad.data  LIKE '%osv-kaltura%'
-- answers with kaltura entries
--WHERE qrd.data  LIKE '%osv-kaltura%'


-- Assignment submissions using the Kaltura B2 Mashup

SELECT cm.course_id, u.user_id, gm.title, a.attempt_date-- , a.STUDENT_SUBMISSION
FROM attempt a
INNER JOIN gradebook_grade gg ON a.gradebook_grade_pk1 = gg.pk1
INNER JOIN gradebook_main gm ON gg.gradebook_main_pk1 = gm.pk1
INNER JOIN course_main cm ON gm.crsmain_pk1 = cm.pk1
INNER JOIN course_users cu ON gg.course_users_pk1 = cu.pk1
INNER JOIN users u ON cu.users_pk1 = u.pk1
AND a.STUDENT_SUBMISSION IS NOT null
and a.student_submission  LIKE '%osv-kaltura%'
ORDER BY a.attempt_date, gm.title, u.user_id

