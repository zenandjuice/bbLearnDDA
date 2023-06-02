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


-- LTI 1.3 links

select distinct(cc.pk1) as "Content pk1",
 cm.course_id, cm.pk1 as "Course PK1",
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
and cc.extended_data like '%macmillan%'
and cm.course_id = '[course_id]'
AND cu.role = 'P'
GROUP BY cc.pk1, cm.course_id, cm.pk1, cc.title, ccp.title
order by cm.course_id


-- leftover Partner Cloud / LTI 1.3 grade center columns

SELECT 
	cm.course_id AS "COURSE ID",
	 STRING_AGG(u.user_id, ';') AS "Instructor Username",
 string_agg(distinct u.firstname||' '||u.lastname, ', ') as instructors,
	cm.pk1 as "Course PK1",
	gm.pk1 as "Column PK1",
    gm.title AS "Grade Center Title",
    gm.display_title,
    gm.score_provider_handle  AS "Tool Provider",
    gm.course_contents_pk1,
    ccp.title as "Parent Title",
    gm.display_title  AS "Grade Center Display Name",
    gm.deleted_ind AS "Deleted or not?",
    gm.date_modified,
    gm.scorable_ind  AS "Included in Calculations",
    gm.possible  AS "Points Possible",
    gm.visible_ind  AS "Visible to Students",
    gm.visible_in_book_ind  AS "Visible to Instructors",
    gm.due_date,
    gm.date_added,
    gm.user_created_ind  AS "Manually Created?",
    gm.ext_atmpt_handler_url,
    gm.lti_tag,
    gm.lti_res_id
FROM gradebook_main gm
INNER JOIN course_main cm ON gm.crsmain_pk1 = cm.pk1
left JOIN course_contents ccp ON gm.course_contents_pk1 = ccp.pk1
join course_users cu on cm.pk1 = cu.crsmain_pk1
join users u on cu.users_pk1 = u.pk1 
where cm.course_id = '[course_id]'
and gm.deleted_ind = 'N'
AND cu.role = 'P'
-- LTI 1.3 tool will have "resource/x-bb-blti-link" as Tool score_provider_handle
-- Partner Cloud columns will have "NULL" Tool Provider
-- lti_tag = Macmillan for both types
and gm.lti_tag like '%Macmillan%'
group by cm.course_id, cm.pk1, gm.pk1, gm.title, gm.display_title, gm.score_provider_handle,  gm.course_contents_pk1, ccp.title, gm.display_title, gm.deleted_ind, gm.date_modified, gm.scorable_ind, gm.possible, gm.visible_ind, gm.visible_in_book_ind, gm.due_date, gm.date_added, gm.user_created_ind, gm.ext_atmpt_handler_url, gm.lti_res_id
ORDER BY CM.COURSE_ID, gm.TITLE
