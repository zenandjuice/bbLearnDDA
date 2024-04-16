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
