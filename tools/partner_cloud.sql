-- Partner Cloud Migration Tools

select mp.provider_id, mc.course_id,
case
	when mc.state= 'C' then 'Completed'
	when mc.state= 'S' then 'Staged'
	when mc.state= 'N' then 'Not Started'
	when mc.state= 'F' then 'Failed'
	when mc.state= 'P' then 'In Progress'
	else 'Other'
  end as "Migration State",
mc.course_dsk, mc.inst_username, mc.inst_name, mc.state, mc.last_updated_dt 
from bbgs_pc_migrate_courses mc
inner join bbgs_pc_migrate_partner mp on mc.migrate_partner_pk1 = mp.pk1 
order by mc.state, mc.course_id 

-- Migration Partners with Status
select *
from bbgs_pc_migrate_partner mp


-- Partner Cloud link_href
-- cloud:CEN2 = Cengage iLrn
-- cloud:CEN4 = Cengage
-- cloud:LIL1 = LinkedIn Learning
-- cloud:MAC1 - MacMillan
-- cloud:MHE2 = SimNet
-- cloud:PRVL1 = Pearson Revel


-- Cengage Partner Cloud Grades
-- Returns grades in course that were either via an official Attempt, or Manually entered grade 

select
  cm.course_id AS "Course",
  	CASE 
    WHEN cm.course_view_option = 'I' THEN 'Instructor Choice'
    WHEN cm.course_view_option = 'U' THEN 'Ultra'
    WHEN cm.course_view_option = 'C' THEN 'Original'
    ELSE 'OTHER'
    END AS "Course View",
   u.user_id as "Username",
   u.firstname as "First Name", u.lastname as "Last Name",
   u.department AS "College and Department",
  CASE
    WHEN u.educ_level = '0'then ' '
    WHEN u.educ_level = '13' THEN 'Freshman'
    WHEN u.educ_level = '14' THEN 'Sophomore'
    WHEN u.educ_level = '15' THEN 'Junior'
    WHEN u.educ_level = '16' THEN 'Senior'
    WHEN u.educ_level = '18' THEN 'Graduate School'
    WHEN u.educ_level = '20' THEN 'Post Graduate School'
END AS "Education Level",
  gm.title AS "Grade Center Title",
  gm.due_date as "Due Date",
  gm.possible as "Points Possible",
  gg.manual_grade as "Manual Grade", 
  gg.manual_score as "Manual Score", 
  a.score as "Attempt Score", 
  a.grade as "Attempt Grade",
  gg.comments as "Instructor Grading Notes", 
  a.student_comments as "Attempt Student Comments",
  a.instructor_comments as "Attempt Instructor Comments",
  a.instructor_notes as "Attempt Instructor Notes",
  a.attempt_date as "Attempt Date",
  a.date_modified "Attempt Date Modified",
  CASE
    WHEN a.status = 1 THEN 'Not Attempted'
    WHEN a.status = 3 THEN 'In Progress'
    WHEN a.status = 4 THEN 'Suspended'
    WHEN a.status = 6 THEN 'Needs Grading'
    WHEN a.status = 7 THEN 'Completed'
    WHEN a.status = 8 THEN 'In More Progress'
    WHEN a.status = 9 THEN 'Needs More Grading'
    ELSE 'OTHER'
    END AS "Attempt Status",
  CASE 
    WHEN gg.status = '1' THEN 'Graded'
    WHEN gg.status = '2' THEN 'Needs Grading'
    ELSE 'OTHER'
  END AS "Grading Status"
from gradebook_grade gg
INNER JOIN gradebook_main gm ON gg.gradebook_main_pk1 = gm.pk1
INNER JOIN course_users cu ON gg.course_users_pk1 = cu.pk1
INNER JOIN course_main cm on cu.crsmain_pk1 = cm.pk1
INNER JOIN users u ON cu.users_pk1 = u.pk1
INNER JOIN course_main on gm.CRSMAIN_PK1 = course_main.PK1
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
LEFT join attempt a on gg.pk1 = a.gradebook_grade_pk1 
WHERE dsc.batch_uid = '1233'
and gm.score_provider_handle = 'resource/x-bbgs-partner-cloud' and gm.linkrefid like '%CEN4%'
--WHERE cm.course_id = '[course_id]'
--and u.user_id in ('user1', 'user2', 'user3')
--and gm.title = '[column name]'
--ORDER BY cm.course_id, u.user_id, gm.pk1, gm.title
order by a.attempt_date 



--Jeff Kelley's count version

SELECT
  count(1) AS counter,    --counts the number of items
  substring(link_ref,0,11) as link_ref  --extracts the partner cloud integration type
FROM course_contents
WHERE dtcreated > '2023-01-01'
  AND cnthndlr_handle = 'resource/x-bbgs-partner-cloud'  --all partner cloud items
GROUP BY substring(link_ref,0,11)
ORDER BY counter DESC
