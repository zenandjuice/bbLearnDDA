-- Partner Cloud Macmillan links

select distinct(cc.pk1) as "Content pk1",
 cm.course_id,
 STRING_AGG(u.email, ';') AS emails,
 string_agg(distinct u.firstname||' '||u.lastname, ', ') as instructors,
 cc.title as "Link Title",
 ccp.title as "Folder Title",
 cc.cnthndlr_handle as "Tool",
 cc.link_ref
FROM course_main cm
INNER JOIN course_contents cc ON cc.crsmain_pk1 = cm.pk1
left join course_contents ccp on cc.parent_pk1 = ccp.pk1
join course_users cu on cm.pk1 = cu.crsmain_pk1
join users u on cu.users_pk1 = u.pk1 
where cc.cnthndlr_handle = 'resource/x-bbgs-partner-cloud'
AND cc.link_ref LIKE 'cloud:MAC%'
AND cu.role = 'P'
and cu.row_status = '0'
GROUP BY cc.pk1, cm.course_id, cc.title, ccp.title
order by cm.course_id 
