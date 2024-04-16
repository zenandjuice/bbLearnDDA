-- Base query that returns impersonator and impersonated user 

select si.created "LoginAs Date", u.user_id as "Impersonated User", ir.role_id as "Institutional Role", u2.user_id as "Impersonated by", si.reason as "Reason", si.session_id 
from sessions_impersonated si
	inner join users u on si.impersonated_pk1 = u.pk1
	inner join users u2 on si.impersonator_pk1 = u2.pk1
	inner join institution_roles ir on u.institution_roles_pk1 = ir.pk1
order by si.created

--count of which roles we've impersonated
 
select ir.role_id, count(ir.role_id) 
from sessions_impersonated si
	inner join users u on si.impersonated_pk1 = u.pk1
	inner join users u2 on si.impersonator_pk1 = u2.pk1
	inner join institution_roles ir on u.institution_roles_pk1 = ir.pk1
group by ir.role_id 
order by ir.role_id

--LoginAs Information with Activity Accumulator data

select si.created "LoginAs Date", u.user_id as "Impersonated User", ir.role_id  as "Institutional Role", u2.user_id as "Impersonated by", si.reason as "Reason", si.session_id,
       cm.course_id,
       cc.title,
       aa.timestamp,
       aa.data,
       aa.internal_handle,
       aa.content_pk1,
       aa.event_type
from sessions_impersonated si
	inner join users u on si.impersonated_pk1 = u.pk1
	inner join users u2 on si.impersonator_pk1 = u2.pk1
	inner join institution_roles ir on u.institution_roles_pk1 = ir.pk1
	inner join activity_accumulator aa on si.session_id = aa.session_id 
	LEFT JOIN course_main cm ON aa.course_pk1 = cm.pk1
	left JOIN course_contents cc ON aa.content_pk1 = cc.pk1
WHERE aa.timestamp between '03/01/2024 00:00:00' and '04/30/2024 23:59:59'
--AND u.user_id = '[username]' -- check for specific user
order by si.created 


-- Overall Activity Accumulator query, that includes Impersonated by information when applicable

select
	distinct aa.pk1,
	CASE 
         WHEN si.session_id = aa.session_id then u2.user_id
         WHEN si.session_id != aa.session_id then null
         ELSE COALESCE(aa.session_id::text,'')
 END AS "Impersonated by...",
	u.pk1 as "User PK1",
    u.lastname,
    u.firstname,
    u.user_id,
    cm.course_id, cm.pk1 as "Course PK1",
    aa.timestamp,-- 'YYYY/MM/DD HH:MI:SS' as "Timestamp",
    cc.pk1 as "Content PK1",
    cc.title as "Content Title",
    aa.data,
    aa.internal_handle,
    aa.content_pk1,
    aa.session_id,
    aa.event_type
FROM activity_accumulator aa
	INNER JOIN users u ON aa.user_pk1 = u.pk1
	left join sessions_impersonated si on u.pk1 = si.impersonated_pk1 
	left join users u2 on si.impersonator_pk1 = u2.pk1 
	inner join course_users cu on cu.users_pk1 = u.pk1
	LEFT JOIN course_main cm ON aa.course_pk1 = cm.pk1	-- left join to get non-course activity
	left JOIN course_contents cc ON aa.content_pk1 = cc.pk1	-- left join because some entries like journals don't have a content object associated
WHERE aa.timestamp between '01/01/2024 10:00:00' and '03/10/2024 23:59:59'
AND u.user_id = '[username]'
ORDER BY aa.timestamp 
