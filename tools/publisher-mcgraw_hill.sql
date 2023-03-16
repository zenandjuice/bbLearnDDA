Note:

McGraw-Hill content handlers for the leagcy Building Block:

APPLICATION/X-MHHE-ALEKS
APPLICATION/X-MHHE-BOOKSTORE
APPLICATION/X-MHHE-CONNECT
APPLICATION/X-MHHE-CONNECT-ASSIGNMENT
APPLICATION/X-MHHE-CONNECT-ASSIGNMENT-BLOG
APPLICATION/X-MHHE-CONNECT-ASSIGNMENT-DISCUSSION
APPLICATION/X-MHHE-CONNECT-ASSIGNMENT-EXAM
APPLICATION/X-MHHE-CONNECT-ASSIGNMENT-FILEATTACH
APPLICATION/X-MHHE-CONNECT-ASSIGNMENT-GROUP
APPLICATION/X-MHHE-CONNECT-ASSIGNMENT-HOMEWORK
APPLICATION/X-MHHE-CONNECT-ASSIGNMENT-LEARNSMART
APPLICATION/X-MHHE-CONNECT-ASSIGNMENT-MUNDO-INTERACTIVO
APPLICATION/X-MHHE-CONNECT-ASSIGNMENT-PERSONALIZED-LEARNING
APPLICATION/X-MHHE-CONNECT-ASSIGNMENT-PRACTICE
APPLICATION/X-MHHE-CONNECT-ASSIGNMENT-QUIZ
APPLICATION/X-MHHE-CONNECT-ASSIGNMENT-READING
APPLICATION/X-MHHE-CONNECT-ASSIGNMENT-SPEECH
APPLICATION/X-MHHE-CONNECT-ASSIGNMENT-VIDEO
APPLICATION/X-MHHE-CONNECT-ASSIGNMENT-WEB
APPLICATION/X-MHHE-CONNECT-ASSIGNMENT-WRITING
APPLICATION/X-MHHE-CONNECT-ELIBRARY
APPLICATION/X-MHHE-CONNECT-LEARNSMART
APPLICATION/X-MHHE-CONNECT-TEGRITY
APPLICATION/X-MHHE-CREATE
APPLICATION/X-MHHE-CREATE-PROJECT
APPLICATION/X-MHHE-DYNAMIC
APPLICATION/X-MHHE-GENERIC
APPLICATION/X-MHHE-GENERIC-GENERIC
APPLICATION/X-MHHE-SIMNET
resource/mcgraw-hill-assignment
resource/mcgraw-hill-assignment-BLOG
resource/mcgraw-hill-assignment-DISCUSSION
resource/mcgraw-hill-assignment-dynamic
resource/mcgraw-hill-assignment-EXAM
resource/mcgraw-hill-assignment-FILEATTACH
resource/mcgraw-hill-assignment-GROUP
resource/mcgraw-hill-assignment-HOMEWORK
resource/mcgraw-hill-assignment-LEARNSMART
resource/mcgraw-hill-assignment-MUNDO-INTERACTIVO
resource/mcgraw-hill-assignment-PERSONALIZED-LEARNING
resource/mcgraw-hill-assignment-PRACTICE
resource/mcgraw-hill-assignment-QUIZ
resource/mcgraw-hill-assignment-READING
resource/mcgraw-hill-assignment-SPEECH
resource/mcgraw-hill-assignment-VIDEO
resource/mcgraw-hill-assignment-WEB
resource/mcgraw-hill-assignment-WRITING
resource/mcgrawHillContent
resource/mcgraw-hill-elibrary

-- McGraw-Hill B2 links

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
where (cc.cnthndlr_handle LIKE 'APPLICATION/X-MHHE%' or cc.cnthndlr_handle like 'resource/mcgraw%')
AND cu.role = 'P'
AND u.user_id NOT LIKE '%preview%'
GROUP BY cc.pk1, cm.course_id, cc.title, ccp.title
order by cm.course_id


-- leftover b2 grade center columns

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
where cm.course_id like '%'
and gm.ext_atmpt_handler_url  like '/webapps/Bb-McGrawHill%'
and gm.lti_res_id is null
--and gm.score_provider_handle = 'resource/x-bb-assessment'
and gm.score_provider_handle != 'resource/x-bb-blti-link'
--and gm.course_contents_pk1 is NULL
and gm.deleted_ind = 'N'
AND cu.role = 'P'
group by cm.course_id, cm.pk1, gm.pk1, gm.title, gm.display_title, gm.score_provider_handle,  gm.course_contents_pk1, ccp.title, gm.display_title, gm.deleted_ind, gm.date_modified, gm.scorable_ind, gm.possible, gm.visible_ind, gm.visible_in_book_ind, gm.due_date, gm.date_added, gm.user_created_ind, gm.ext_atmpt_handler_url, gm.lti_res_id
ORDER BY CM.COURSE_ID, gm.TITLE




-- just the course ids with B2 content
select distinct(cm.course_id), cm.available_ind 
FROM course_main cm
INNER JOIN course_contents cc ON cc.crsmain_pk1 = cm.pk1
left join course_contents ccp on cc.parent_pk1 = ccp.pk1
where (cc.cnthndlr_handle LIKE 'APPLICATION/X-MHHE%' or cc.cnthndlr_handle like 'resource/mcgraw%')
GROUP BY cm.course_id, cm.available_ind 
order by cm.course_id



-- McGraw-Hill LTI 1.3 Links
-- handle:  mcgrawhillconnectltia
-- but this uses generic resource/x-bb-blti-link and the extended_data contains mheducation references
-- cc.web_url also shows https://connect.router.integration.prod.mheducation.com/v1/lms/ltiv1p3


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
and cc.extended_data like '%mheducation%'
--and cm.course_id = '[course_id]'
AND cu.role = 'P'
-- exclude bbstaff users, list 2022-12-02
--and cc.web_url != 'https://connect.router.integration.prod.mheducation.com/v1/lms/ltiv1p3'
GROUP BY cc.pk1, cm.course_id, cm.pk1, cc.title, ccp.title
order by cm.course_id
