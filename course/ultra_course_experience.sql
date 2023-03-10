SELECT DISTINCT cm.COURSE_ID, 
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
cm.AVAILABLE_IND,
       CASE
        WHEN cm.ROW_STATUS = 0 THEN 'ENABLED'
        WHEN cm.ROW_STATUS = 2 THEN 'DISABLED'
        ELSE 'OTHER'
       END AS "Row Status",
string_agg(distinct u.user_id , ', ') as "Instructor Username",
string_agg(distinct u.firstname||' '||u.lastname, ', ') as "Instructor Name"
FROM course_main cm
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
FULL OUTER JOIN course_users cu on cm.pk1 = cu.crsmain_pk1
FULL OUTER JOIN users u on cu.users_pk1 = u.PK1
-- my terms each have their own DSK
WHERE dsc.batch_uid = '1233'
and cm.ultra_status IN ('U', 'P')
and cu.role = 'P'
--and cm.course_view_option IN ('U', 'I')
--where cm.course_id like '%1219-THEUA-ACCT-2013-SEC901-5240%'
--where mi.name like '%Ultra%'
--AND cm.ROW_STATUS='0'
group by cm.course_id, cm.course_view_option, cm.ultra_status, cm.available_ind, cm.row_status 
order by cm.COURSE_ID
