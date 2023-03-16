-- lists enrollment"Extensions" in the system, created by manually editing a user's enrollent and changing the availability date.

select cm.course_id, user_id, 
  cu.role, 
    CASE 
    WHEN cu.ROW_STATUS = 0 THEN 'Enabled'
    WHEN cu.ROW_STATUS = 2 THEN 'Disabled'
    ELSE 'OTHER'
    END AS ROW_STATUS,
    ds.batch_uid as DSK,
    cu.bypass_course_avail_until
from course_users cu
JOIN course_main cm on  cu.crsmain_pk1 = cm.pk1
JOIN users u ON cu.users_pk1 = u.pk1
INNER JOIN DATA_SOURCE ds ON cu.data_src_pk1 = ds.pk1
where cu.bypass_course_avail_until IS NOT NULL
-- and cu.role = 'S'
order by user_id
