-- Lists Observers and Observed Students

SELECT
u2.User_id AS "STUDENT USERNAME",
u.user_id AS "OBSERVER USERNAME",
dsou.batch_uid,
    CASE 
    WHEN OU.ROW_STATUS = 0 THEN 'Enabled'
    WHEN OU.ROW_STATUS = 2 THEN 'Disabled'
    ELSE 'OTHER'
    END AS ROW_STATUS
FROM OBSERVER_USER OU
JOIN users u ON OU.OBSERVER_PK1 = u.pk1
JOIN users u2 ON OU.USERS_PK1 = u2.pk1
INNER JOIN DATA_SOURCE dsou ON OU.data_src_pk1 = dsou.pk1
-- specific advisor
WHERE u.user_id = '[observer user_id]'
-- WHERE OU.ROW_STATUS = '2'
ORDER by u2.user_id


-- Observer system role 

select 
  U.USER_ID
  ,SR.SYSTEM_ROLE
from system_roles SR
inner join users U on U.system_role = SR.system_role
WHERE SR.system_role = 'O'


-- Primary Institutional Role for DSK Users
select u.pk1, u.user_id, u.batch_uid, ir.role_id as "Primary Inst Role", u.system_role, u.last_login_date 
from institution_roles ir
JOIN users u ON ir.pk1 = u.institution_roles_pk1
INNER JOIN DATA_SOURCE DS ON u.data_src_pk1 = DS.pk1
--join system_role sr on u.system_role = sr.system_role 
WHERE DS.BATCH_UID='OBSERVER'
ORDER BY u.user_id

-- Secondary role 

select usr.USER_ID, REPLACE(ir1.ROLE_NAME,'.role_name','') "Secondary RoleName"
from USER_ROLES ur, INSTITUTION_ROLES ir1, users usr
where ur.INSTITUTION_ROLES_PK1=ir1.PK1
and ur.USERS_PK1=usr.PK1
and ir1.ROLE_NAME = 'OBSERVER.role_name'
order by usr.user_id
