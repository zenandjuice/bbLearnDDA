-- See Grade Center columns in course that are tied to Pearson.
-- Pearson doesn't use a SCORE_PROVIDER_HANDLE, but the descriptions contain "Pearson"

SELECT COUNT(a.pk1) AS "Number of Pearson Grades", description
FROM attempt a
INNER JOIN gradebook_grade gg ON a.gradebook_grade_pk1 = gg.pk1
INNER JOIN gradebook_main gm ON gg.gradebook_main_pk1 = gm.pk1
INNER JOIN course_main cm ON gm.crsmain_pk1 = cm.pk1
INNER JOIN course_users cu ON gg.course_users_pk1 = cu.pk1
INNER JOIN users u ON cu.users_pk1 = u.pk1
WHERE DESCRIPTION LIKE '%pearson%'
AND (cm.COURSE_ID like '1233-THEUA%' or cm.COURSE_ID like 'MASTER-1233%')
GROUP BY gm.score_provider_handle, description



-- Pearson Revel Users [Partner Cloud]

select distinct(cc.pk1) as "Content pk1",
 cm.course_id,
 STRING_AGG(u.email, ';') AS emails,
 string_agg(distinct u.firstname||' '||u.lastname, ', ') as instructors,
 cc.title as "Link Title",
 ccp.title as "Folder Title"
FROM course_main cm
INNER JOIN course_contents cc ON cc.crsmain_pk1 = cm.pk1
left join course_contents ccp on cc.parent_pk1 = ccp.pk1
join course_users cu on cm.pk1 = cu.crsmain_pk1
join users u on cu.users_pk1 = u.pk1 
where cc.link_ref = 'cloud:PRVL1-revel'
--and cc.extended_data LIKE '%<entry key="providerId">PRVL1</entry>%'
AND cu.role = 'P'
and cu.row_status = '0'
GROUP BY cc.pk1, cm.course_id, cc.title, ccp.title
order by cm.course_id



-- Pearson Masting & MyLab [Partner Cloud, via B2]

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
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
WHERE dsc.batch_uid = '1233'
and cc.cnthndlr_handle = 'resource/x-peusa-mlm-link'
AND cu.role = 'P'
and cu.row_status = '0'
--and cm.course_id like '%1229-THEUA%'
GROUP BY cc.pk1, cm.course_id, cc.title, ccp.title
order by cm.course_id


-- Pearson Masting & MyLab [Partner Cloud)

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
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
-- my terms each have a unique DSK
WHERE dsc.batch_uid = '1233'
and cc.link_ref LIKE 'cloud:PRSED1%'
AND cu.role = 'P'
and cu.row_status = '0'
GROUP BY cc.pk1, cm.course_id, cc.title, ccp.title
order by cm.course_id



--- Pearson Direct Integration (USED in MATH, STAT, & FINN)
--- uses WilloLab, but so does CHEM ('CHEM 101' branded) and PSYC ('APA' branded)

select distinct(cc.pk1) as "Content pk1",
 cm.course_id,
 STRING_AGG(u.email, ';') AS emails,
 string_agg(distinct u.firstname||' '||u.lastname, ', ') as instructors,
 cc.title as "Link Title",
 ccp.title as "Folder Title",
 cc.cnthndlr_handle as "Tool"
FROM course_main cm
INNER JOIN course_contents cc ON cc.crsmain_pk1 = cm.pk1
left join course_contents ccp on cc.parent_pk1 = ccp.pk1
join course_users cu on cm.pk1 = cu.crsmain_pk1
join users u on cu.users_pk1 = u.pk1 
WHERE cc.web_url_host = 'app.willolabs.com'
and (cm.course_id like '%MATH%' or cm.course_id like '%STAT%' or cm.course_id like '%FINN%')
-- exclude the CHEM101 & APA placements
--and cm.course_id not like '%-PSYC-%' or cm.course_id not like '%CHEM%'
AND cu.role = 'P'
and cu.row_status = '0'
GROUP BY cc.pk1, cm.course_id, cc.title, ccp.title
order by cm.course_id



-- Pearson / Barnes & Noble Partner Integration

select distinct(cc.pk1) as "Content pk1",
 cm.course_id,
 STRING_AGG(u.email, ';') AS emails,
 string_agg(distinct u.firstname||' '||u.lastname, ', ') as instructors,
 cc.title as "Link Title",
 ccp.title as "Folder Title",
 cc.cnthndlr_handle as "Tool",cc.*
FROM course_main cm
INNER JOIN course_contents cc ON cc.crsmain_pk1 = cm.pk1
left join course_contents ccp on cc.parent_pk1 = ccp.pk1
join course_users cu on cm.pk1 = cu.crsmain_pk1
join users u on cu.users_pk1 = u.pk1 
where cc.web_url_host = 'gateway-cpg.pearson.com'
AND cu.role = 'P'
and cu.row_status = '0'
GROUP BY cc.pk1, cm.course_id, cc.title, ccp.title
order by cm.course_id


-- Pearson LTI 1.3 Links

select distinct(cc.pk1) as "Content pk1",
 cm.course_id,
 STRING_AGG(u.email, ';') AS emails,
 string_agg(distinct u.firstname||' '||u.lastname, ', ') as instructors,
 cc.title as "Link Title",
 ccp.title as "Folder Title",
 cc.cnthndlr_handle as "Tool",cc.*
FROM course_main cm
INNER JOIN course_contents cc ON cc.crsmain_pk1 = cm.pk1
left join course_contents ccp on cc.parent_pk1 = ccp.pk1
join course_users cu on cm.pk1 = cu.crsmain_pk1
join users u on cu.users_pk1 = u.pk1 
-- resource/x-bb-bltiplacement-pearson13   for my Pearson LTI 1.3 tool
-- resource/x-bb-bltiplacement-pearson13CT for my "Pearson Assignment Links" LTI 1.3 tool
where cc.cnthndlr_handle like 'resource/x-bb-bltiplacement-pearson13%'
--where cm.course_id = '[course_id]'
AND cu.role = 'P'
and cu.row_status = '0'
GROUP BY cc.pk1, cm.course_id, cc.title, ccp.title
order by cm.course_id, cc.title
