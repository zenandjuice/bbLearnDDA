-- Base query that returns impersonator and impersonated user

select si.created "LoginAs Date", u2.user_id as "Impersonated User", u.user_id as "Impersonated by", si.reason as "Reason", si.session_id 
from sessions_impersonated si
inner join users u on si.impersonator_pk1 = u.pk1 
inner join users u2 on si.impersonated_pk1 = u2.pk1
order by si.created 


--LoginAs Information with Activity Accumulator data

select si.created "LoginAs Date", u2.user_id as "Impersonated User", u.user_id as "Impersonated by", si.reason as "Reason", si.session_id,
       cm.course_id,
       cc.title,
       aa.timestamp,
       aa.data,
       aa.internal_handle,
       aa.content_pk1,
       aa.event_type
from sessions_impersonated si
inner join users u on si.impersonator_pk1 = u.pk1 
inner join users u2 on si.impersonated_pk1 = u2.pk1
inner join activity_accumulator aa on si.session_id = aa.session_id 
LEFT JOIN course_main cm ON aa.course_pk1 = cm.pk1
left JOIN course_contents cc ON aa.content_pk1 = cc.pk1
WHERE aa.timestamp between '02/01/2023 00:00:00' and '02/06/2023 23:59:59'
order by si.created 
