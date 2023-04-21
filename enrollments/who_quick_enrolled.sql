-- Who probably quick enrolled?
-- Lists users with SYSTEM course user DSK enrollment, Instructors, who are in a System Role that allows for Quick Enroll 

select cm.course_id, user_id, 
  cu.role as "Course Role", 
  u.system_role as "System Role",
  sr.name as "System Role Name",
  sre.entitlement_uid as "Entitlement",
  dscu.batch_uid as "Enrollment DSK",
  dsc.batch_uid as "Course DSK",
    CASE
    WHEN cu.ROW_STATUS = 0 THEN 'Enabled'
    WHEN cu.ROW_STATUS = 2 THEN 'Disabled'
    ELSE 'OTHER'
    END AS "Enrollment ROW_STATUS",  
  cu.AVAILABLE_IND as "Enrollment Availability"
from course_users cu
JOIN course_main cm on  cu.crsmain_pk1 = cm.pk1
JOIN users u ON cu.users_pk1 = u.pk1
join system_roles sr on sr.system_role = u.system_role 
join system_roles_entitlement sre on sr.system_role = sre.system_role 
INNER JOIN DATA_SOURCE dscu ON cu.data_src_pk1 = dscu.pk1
INNER JOIN DATA_SOURCE dsc ON cm.data_src_pk1 = dsc.pk1
-- enrollment DSK
WHERE dscu.batch_uid = 'SYSTEM'
-- course DSK
--AND dsc.batch_uid = 'KEEP'
--AND (cm.COURSE_ID like '1219-THEUA%' or cm.COURSE_ID like 'MERGED-1219%')
-- everyone but students
--and cu.role != 'S'
-- Quick Enroll would be Intructor
and cu.role = 'P'
and sre.entitlement_uid = 'course.quick-enroll.EXECUTE'
--order by DSK
order by cm.course_id
