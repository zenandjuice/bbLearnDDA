-- course roster to quickly swap availability
-- I use this to paste into an SIS feed file, and replace the available_ind or row_status

select cm.course_id, cm.batch_uid,
  u.user_id,
  cu.role,
  cu.available_ind,
  dsu.batch_uid as DSK,
    CASE
    WHEN cu.ROW_STATUS = 0 THEN 'Enabled'
    WHEN cu.ROW_STATUS = 2 THEN 'Disabled'
    ELSE 'OTHER'
    END AS ROW_STATUS
--  users.firstname,
--  users.lastname
from course_users cu
JOIN course_main cm on  cu.crsmain_pk1 = cm.pk1
JOIN users u ON cu.users_pk1 = u.pk1
INNER JOIN DATA_SOURCE dsu ON cu.data_src_pk1 = dsu.pk1
where cm.course_id like '[course_id]%'
--where cm.course_id = '[course_id]'
-- students only
and cu.role = 'S'
-- Enabled Users
--and cu.row_status = '0'
-- Disabled Users
-- and cu.row_status = '2'
-- users in specific enrollment DSK
--and dsu.batch_uid = 'MANUAL'
order by cm.batch_uid
