-- Returns Rubrics and comments/feedback
-- Department will be consistent with rubric names
-- Comments and Feedback are available, but those lines are commented out

select
cm.course_id,
u.USER_ID, u.LASTNAME, u.FIRSTNAME,
gm.title AS Grade_Center_Title,
r.title AS Rubric_Title,
-- rl.pk1, rl.rubric_pk1, re.rubric_link_pk1,
-- rl.eval_entity_pk1, re.pk1 as re_pk,
rr.position AS "Criteria Order",
--rr.pk1,
rr.header as "Criteria",
-- Each row (Criteria) is worth a certain overall percentage, based on the total points possible
rr.percentage AS "Criteria Weight %",
-- OK.  So grid.column1.label would be the 2nd column, since the first column is 0. So ELSE becomes the title of Column 0
rcol.header,
-- position can be useful to determine the header names above
-- rcol.position is which assement column was clicked, range is 0-n
-- rcol.position + 1 as "Level of Achievement (Column) Number Selected",
rc.percentage AS "Earned Percentage for this Criteria",
round(cast(rce.selected_percent AS numeric), 4) as "Level (Column) Selected Percentage of Total",
round(rce.selected_percent*gm.possible) AS "Level (Column) Points Earned",
-- Uncomment to get feedback as well. Be careful! Office HTML tags will break the data import into Excel.
rce.feedback AS cell_feedback,
re.comments AS eval_comments,
at.score as "Assignment Earned Score",
gm.possible AS "Total Points Possible",
rce.feedback AS cell_feedback,
re.comments AS eval_comments,
at.INSTRUCTOR_COMMENTS as overall_comments
from rubric_link rl
inner join rubric r on rl.rubric_pk1 = r.pk1
inner join evaluation_entity ee on rl.eval_entity_pk1 = ee.pk1
inner join ATTEMPT at on ee.attempt_pk1 = at.PK1
inner join GRADEBOOK_GRADE gg on at.GRADEBOOK_GRADE_PK1 = gg.PK1
INNER JOIN gradebook_main gm ON gg.gradebook_main_pk1 = gm.pk1
inner join COURSE_USERS cu on gg.COURSE_USERS_PK1 = cu.PK1
join course_main cm on  cu.crsmain_pk1 = cm.pk1
inner join USERS u on cu.USERS_PK1 = u.PK1
inner join rubric_eval re on rl.pk1 = re.rubric_link_pk1
inner join rubric_cell_eval rce on re.pk1 = rce.rubric_eval_pk1
inner join rubric_cell rc on rce.rubric_cell_pk1 = rc.pk1
inner join rubric_column rcol on rc.rubric_column_pk1 = rcol.pk1
inner join rubric_row rr on rce.rubric_row_pk1 = rr.pk1
where ee.attempt_pk1 is not null
-- search for specific course_id strings
AND cm.COURSE_ID LIKE '%[course_id string]%'
AND (r.title LIKE 'EDA_%' or r.title LIKE 'ILPPA%' or r.title LIKE 'TESS%')
order by r.title, cm.course_id,u.user_id,gm.title,rr.position
