-- Returns grades in course that were either via an official Attempt, or Manually entered grade 

select
  cm.course_id AS "Course",
    CASE 
    WHEN cm.course_view_option = 'I' THEN 'Instructor Choice'
    WHEN cm.course_view_option = 'U' THEN 'Ultra'
    WHEN cm.course_view_option = 'C' THEN 'Original'
    ELSE 'OTHER'
    END AS "Course View Option",
  CASE 
    WHEN cm.ultra_status = 'N' THEN 'Undecided'
    WHEN cm.ultra_status = 'C' THEN 'Classic'
    WHEN cm.ultra_status = 'U' THEN 'Ultra'
    WHEN cm.ultra_status = 'P' THEN 'Ultra Preview'
    ELSE 'OTHER'
    END AS "Ultra Status",
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
INNER JOIN data_source ds ON cm.data_src_pk1 = ds.pk1
LEFT join attempt a on gg.pk1 = a.gradebook_grade_pk1
-- for specific course
WHERE cm.course_id = '[course_id]'
-- for specific users
--and u.user_id in ('[username#1]', '[username#2]', '[username#3]')
-- for specific grade center title
and gm.title = '[title]'
ORDER BY cm.course_id, u.user_id, gm.pk1, gm.title
