-- Wiley B2, removed
 
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
where cc.cnthndlr_handle LIKE 'resource/x-wileyplus%'
AND cu.role = 'P'
GROUP BY cc.pk1, cm.course_id, cc.title, ccp.title
order by cm.course_id


---

-- Wiley LTI Links
-- but this uses generic resource/x-bb-blti-link and the extended_data contains references to the placement pk1:  <entry key="cimPlacementId">_461_1</entry>
-- cc.web_url also shows https://lti.education.wiley.com/... so let's use that


select distinct(cc.pk1) as "Content pk1",
 cm.course_id,
 STRING_AGG(u.email, ';') AS emails,
 string_agg(distinct u.firstname||' '||u.lastname, ', ') as instructors,
 cc.title as "Link Title",
 ccp.title as "Folder Title",
 cc.cnthndlr_handle as "Tool",
 cc.link_ref,
 cc.web_url
FROM course_main cm
INNER JOIN course_contents cc ON cc.crsmain_pk1 = cm.pk1
left join course_contents ccp on cc.parent_pk1 = ccp.pk1
join course_users cu on cm.pk1 = cu.crsmain_pk1
join users u on cu.users_pk1 = u.pk1 
where cc.cnthndlr_handle = 'resource/x-bb-blti-link'
and cc.web_url  like '%lti.education.wiley.com%'
AND cu.role = 'P'
GROUP BY cc.pk1, cm.course_id, cc.title, ccp.title
order by cm.course_id
