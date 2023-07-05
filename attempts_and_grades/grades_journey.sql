-- DDA Query for Grades Journey
-- Chris Bray (cbray@uark.edu)

-- Grade Journey Extract History
select cm.course_id, t.name as "Term Name", dsc.batch_uid  AS "Course DSK",
    CASE 
    WHEN cm.course_view_option = 'I' THEN 'Instructor Choice'
    WHEN cm.course_view_option = 'U' THEN 'Ultra'
    WHEN cm.course_view_option = 'C' THEN 'Original'
    ELSE cm.course_view_option
    END AS "Course View Option",
  CASE 
    WHEN cm.ultra_status = 'N' THEN 'Undecided'
    WHEN cm.ultra_status = 'C' THEN 'Classic'
    WHEN cm.ultra_status = 'U' THEN 'Ultra'
    WHEN cm.ultra_status = 'P' THEN 'Ultra Preview'
    ELSE cm.ultra_status
    END AS "Ultra Status",
u.user_id as "Instructor User ID", gjhist.message, gjhist.action, gjhist.action_date
from bbc_gj_extract_history	gjhist
join course_main cm on cm.pk1 = gjhist.course_pk1 
join users u on u.pk1 = gjhist.user_pk1 
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
inner join course_term ct on ct.crsmain_pk1 = cm.pk1
inner join term t on t.pk1 = ct.term_pk1 
-- Status Options:  Unscheduled, Extracted, Scheduled
where gjhist.action = 'Extracted'
order by gjhist.action_date desc


--- Course extraction count per term
select t.name as "Term Name", count(cm.course_id)
from bbc_gj_extract_history	gjhist
join course_main cm on cm.pk1 = gjhist.course_pk1 
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
inner join course_term ct on ct.crsmain_pk1 = cm.pk1
inner join term t on t.pk1 = ct.term_pk1 
where gjhist.action = 'Extracted'
group by t.name


--- Unique instructors per term who used Grades Journey
select t.name as "Term Name", count(distinct (u.user_id))
from bbc_gj_extract_history	gjhist
join course_main cm on cm.pk1 = gjhist.course_pk1 
join users u on u.pk1 = gjhist.user_pk1 
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
inner join course_term ct on ct.crsmain_pk1 = cm.pk1
inner join term t on t.pk1 = ct.term_pk1 
where gjhist.action = 'Extracted'
group by t.name


--Combined count - Unique Instructors and courses
select t.name as "Term Name", count(distinct (u.user_id)) as "Instructor Count", count(cm.course_id) as "Course Count"
from bbc_gj_extract_history	gjhist
join course_main cm on cm.pk1 = gjhist.course_pk1 
join users u on u.pk1 = gjhist.user_pk1 
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
inner join course_term ct on ct.crsmain_pk1 = cm.pk1
inner join term t on t.pk1 = ct.term_pk1 
where gjhist.action = 'Extracted'
group by t.name


-- Extracted Grade Columns using bbc_gj_gm_extract_status
select cm.course_id,  t.name as "Term Name", dsc.batch_uid AS "Course DSK", gm.title as "Column Title", u.user_id as "Instructor Username",
       CASE
        WHEN gjgm.status = 'X' THEN 'Extracted'
        WHEN gjgm.status = 'S' THEN 'Approved'
        WHEN gjgm.status = 'U' THEN 'Unapproved'
        ELSE 'OTHER'
        END AS Status,
gjgm.date_added, gjgm.date_modified
from bbc_gj_gm_extract_status gjgm
inner join course_main cm on cm.pk1 = gjgm.course_pk1 
inner join users u on u.pk1 = gjgm.user_pk1 
inner join gradebook_main gm on gm.pk1 = gjgm.gradebook_main_pk1
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
inner join course_term ct on ct.crsmain_pk1 = cm.pk1
inner join term t on t.pk1 = ct.term_pk1 
where gjgm.status = 'X' -- only Extracted columns
order by gjgm.date_added desc



-- Extracted Grade Columns
-- the issue with this is if people extract incorrectly, the results will still be shown.
-- grade return stuff commented out for this reason.
select cm.course_id, t.name as "Term Name", dsc.batch_uid  AS "Course DSK", iu.user_id as "Instructor User ID", gm.title as "Column Title", u.user_id as "Student Username",
       CASE
        WHEN gjgg.status = 'X' THEN 'Extracted'
        WHEN gjgg.status = 'S' THEN 'Approved'
        WHEN gjgg.status = 'U' THEN 'Unapproved'
        ELSE 'OTHER'
        END AS Status,
gjgg.date_added, gjgg.date_modified
-- , a.grade  
from bbc_gj_gg_extract_status gjgg
inner join course_main cm on cm.pk1 = gjgg.course_pk1 
inner join course_users cu on cu.pk1 = gjgg.course_users_pk1 
inner join users u on cu.users_pk1 = u.pk1 -- Students
inner join users iu on iu.pk1 = gjgg.user_pk1  -- Instructors
inner join gradebook_main gm on gm.pk1 = gjgg.gradebook_main_pk1
--inner join gradebook_grade gg on gg.gradebook_main_pk1 = gm.pk1
--inner join attempt a on a.gradebook_grade_pk1 = gg.pk1
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
inner join course_term ct on ct.crsmain_pk1 = cm.pk1
inner join term t on t.pk1 = ct.term_pk1 
where gjgg.status = 'X' -- only Extracted columns
--order by gjgg.date_added DESC


--- what are the statuses ?
-- X = Extracted
-- S = Approved
-- U = Unapproved
select distinct(gjgm.status)
from bbc_gj_gm_extract_status gjgm
