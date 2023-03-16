-- Web Links in Course Menu

SELECT
  cm.course_id, cm.course_name, 
  ct.internal_handle as "Publisher Tool",
  ct.label as "Course Menu Item",
  ct.HREF
FROM course_toc ct
JOIN course_main cm ON ct.crsmain_pk1 = cm.pk1
WHERE cm.row_status     ='0'  -- Enabled Course
--AND cm.available_ind  ='Y'  -- Available Course
AND ct.HREF LIKE '%[url]%'
--and cm.course_id = '[course_id]'
--ORDER BY cm.course_id


-- Web Link Tool in Content Areas

SELECT
  cm.course_id,
  ccp.title as "Folder title",
  cc.pk1,
  cc.title,
  cc.web_url
FROM course_contents cc
INNER JOIN course_main cm ON cc.crsmain_pk1 = cm.pk1
left join course_contents ccp on cc.parent_pk1 = ccp.pk1
WHERE cm.course_id = '[course_id]'
AND cc.cnthndlr_handle='resource/x-bb-externallink'
AND cc.web_url LIKE '%[url]%'
ORDER BY cm.course_id, cc.web_url


-----

-- Web Links added into the Content Editor

SELECT cm.course_id, 
  CASE 
     WHEN cm.ultra_status = 'C' THEN 'Original'
     WHEN cm.ultra_status = 'U' THEN 'Ultra'
     WHEN cm.ultra_status = 'P' THEN 'Preview Mode'
     ELSE 'Other'
  END as Experience, 
u.user_id, cc.title,ccp.title as "Content Area Name",
--cc.MAIN_DATA, 
cc.DTCREATED, cc.DTMODIFIED
FROM course_main cm
JOIN course_contents cc ON cm.pk1 = cc.crsmain_pk1
LEFT JOIN course_contents ccp ON cc.parent_pk1 = ccp.pk1
JOIN course_users cu ON cm.pk1 = cu.crsmain_pk1
INNER JOIN DATA_SOURCE DS ON CM.data_src_pk1 = DS.pk1
JOIN users u ON cu.users_pk1 = u.pk1
WHERE cc.MAIN_DATA LIKE '%[url]%'
AND cm.course_id = '[course_id]'
AND cu.role = 'P'
ORDER BY  cm.course_id
