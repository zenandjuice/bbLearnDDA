-- LinkedIn Learning Tools
--  https://bbooglecom.fatcow.com/Blackboard-Partners/lil_50x50.jpg

-- Partner Cloud tools - deprecated

SELECT
 cm.course_id, 
 STRING_AGG(u.email, ';') AS emails,
 string_agg(distinct u.firstname||' '||u.lastname, ', ') as instructors,
 cc.cnthndlr_handle as "Tool",
 cc.title,
 ccp.title as "Folder Title"
FROM course_main cm
INNER JOIN course_contents cc ON cc.crsmain_pk1 = cm.pk1
left join course_contents ccp on cc.parent_pk1 = ccp.pk1
join course_users cu on cm.pk1 = cu.crsmain_pk1
join users u on cu.users_pk1 = u.pk1 
WHERE cc.extended_data LIKE '%lil_50x50.jpg%'
-- AND cm.COURSE_ID = '[course_id]'
AND cu.role = 'P'
group by cm.course_id, cc.cnthndlr_handle, cc.title, ccp.title 
ORDER BY cm.course_id

--- LTI 1.3 Placements
SELECT
 cm.course_id,
 STRING_AGG(u.email, ';') AS emails,
 string_agg(distinct u.firstname||' '||u.lastname, ', ') as instructors,
 ccp.title AS "Folder Name",
 cc.title,
 cc.web_url
FROM course_contents cc
INNER JOIN course_main cm ON cc.crsmain_pk1 = cm.pk1
left join course_contents ccp on cc.parent_pk1 = ccp.pk1
join course_users cu on cm.pk1 = cu.crsmain_pk1
join users u on cu.users_pk1 = u.PK1
WHERE cc.cnthndlr_handle='resource/x-bb-externallink'
AND cc.web_url LIKE '%linkedin.com/learning%'
AND cu.role = 'P'
group by cm.course_id, cc.cnthndlr_handle, cc.title, ccp.title, cc.web_url 
ORDER BY cm.course_id, cc.web_url


-- Web Links in Course Menu, using direct links
SELECT
  cm.course_id,
 STRING_AGG(u.email, ';') AS emails,
 string_agg(distinct u.firstname||' '||u.lastname, ', ') as instructors,
  ct.internal_handle as "Publisher Tool",
  ct.label as "Course Menu Item",
  ct.HREF
FROM course_toc ct
JOIN course_main cm ON ct.crsmain_pk1 = cm.pk1
join course_users cu on cm.pk1 = cu.crsmain_pk1
join users u on cu.users_pk1 = u.PK1
WHERE cm.row_status     ='0'  -- Enabled Course
--AND cm.available_ind  ='Y'  -- Available Course
AND ct.HREF LIKE '%linkedin.com/learning%'
AND cu.role = 'P'
group by cm.course_id, ct.internal_handle, ct."label", ct.href 
ORDER BY cm.course_id

-----

-- items with LiL links, using direct links

SELECT
  cm.course_id,
   STRING_AGG(u.email, ';') AS emails,
   string_agg(distinct u.firstname||' '||u.lastname, ', ') as instructors,
  -- cc.cnthndlr_handle as "Publisher Tool",
  cc.title
--  cc.MAIN_DATA,
FROM course_contents cc
INNER JOIN course_main cm ON cc.crsmain_pk1 = cm.pk1
join course_users cu on cm.pk1 = cu.crsmain_pk1
join users u on cu.users_pk1 = u.PK1
-- AND cm.row_status     ='0'
-- AND cm.available_ind  ='Y'
-- AND cm.COURSE_ID = '[course_id]'
WHERE cc.MAIN_DATA LIKE '%linkedin.com/learning%'
AND cu.role = 'P'
group by cm.course_id, cc.title 
ORDER BY   cm.course_id
