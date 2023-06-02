-- content handlers in courses that are NOT LTI
-- omits Blackboard stuff

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
-- no LTI !
where cc.cnthndlr_handle not like 'resource/x-bb-blti%'
-- this should omit Blackboard supplied tools, which could be building blocks
and cc.cnthndlr_handle not like 'resource/x-bb%'
-- ignore scorm
and cc.cnthndlr_handle != 'resource/x-plugin-scormengine'
AND cu.role = 'P'
GROUP BY cc.pk1, cm.course_id, cc.title, ccp.title
order by cm.course_id



--- look at content handlers that aren't Blackboard things
select ch.handle, ch.name
from content_handlers ch
where ch.handle not like 'resource/x-bb-blti%'
-- this should omit Blackboard supplied tools, which could be building blocks
and ch.handle  not like 'resource/x-bb%'
-- ignore scorm
and ch.handle != 'resource/x-plugin-scormengine'



--- grade center columns attached to building blocks

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
    gm.lti_res_id
FROM gradebook_main gm
INNER JOIN course_main cm ON gm.crsmain_pk1 = cm.pk1
left JOIN course_contents ccp ON gm.course_contents_pk1 = ccp.pk1
join course_users cu on cm.pk1 = cu.crsmain_pk1
join users u on cu.users_pk1 = u.pk1 
where gm.score_provider_handle not like 'resource/x-bb-blti%'
-- this should omit Blackboard supplied tools, which could be building blocks
and gm.score_provider_handle not like 'resource/x-bb%'
and gm.score_provider_handle != 'resource/x-plugin-scormengine'
and gm.score_provider_handle is not null
and gm.ext_atmpt_handler_url is not null
and gm.deleted_ind = 'N'
AND cu.role = 'P'
group by cm.course_id, cm.pk1, gm.pk1, gm.title, gm.display_title, gm.score_provider_handle,  gm.course_contents_pk1, ccp.title, gm.display_title, gm.deleted_ind, gm.date_modified, gm.scorable_ind, gm.possible, gm.visible_ind, gm.visible_in_book_ind, gm.due_date, gm.date_added, gm.user_created_ind, gm.ext_atmpt_handler_url, gm.lti_res_id
ORDER BY CM.COURSE_ID, gm.TITLE
