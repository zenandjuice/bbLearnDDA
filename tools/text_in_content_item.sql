SELECT cm.course_id, u.user_id, cc.title,
--cc.MAIN_DATA, 
cc.DTCREATED, cc.DTMODIFIED
FROM course_main cm
JOIN course_contents cc ON cm.pk1 = cc.crsmain_pk1
JOIN course_users cu ON cm.pk1 = cu.crsmain_pk1
JOIN users u ON cu.users_pk1 = u.pk1
--INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
-- AND cm.row_status     ='0'
-- AND cm.available_ind  ='Y'
WHERE cc.MAIN_DATA LIKE '%[string]%'
--AND dsc.batch_uid = '1229'
--and cm.course_id = '[course_id]'
AND cu.role = 'P'
ORDER BY   cm.course_id
