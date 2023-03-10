-- course information for end of term cleanup

select distinct(cm.course_id) AS "Course ID",
    cm.course_name AS "Course Name",
       CASE
        WHEN cm.ROW_STATUS = 0 THEN 'ENABLED'
        WHEN cm.ROW_STATUS = 2 THEN 'DISABLED'
        ELSE 'OTHER'
       END AS "Row Status",
    to_char(cm.START_DATE, 'YYYYMMDD')  AS "Start Date",
    to_char(cm.END_DATE, 'YYYYMMDD') AS "End Date",
       CASE
        WHEN cm.AVAILABLE_IND='Y' THEN 'Yes'
        WHEN cm.AVAILABLE_IND='N' THEN 'No'
        ELSE 'OTHER'
       END AS "Available Ind",
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
       max(cu.last_access_date) AS "Last Access Date",
       /* coursefiles = data stored in course files aka content collection */
	/* pg_size_pretty(cs.size_coursefiles) AS "Content Collection",
	/* protectedfiles =  Files that are used in assignments, tests, and student submissions */
	pg_size_pretty(cs.size_protectedfiles) AS "Submisssions",
	/* legacyfiles = files used prior to Learn 9.1. However, Some course tools that require private file storage may be stored in Legacy Filesystem Files instead of Protected Files. */
	pg_size_pretty(cs.size_legacyfiles) AS "Legacy Files", */
	pg_size_pretty(cs.size_total) AS "Total Course Size"
FROM course_course cc
FULL OUTER JOIN course_main cm on cm.pk1 = cc.CRSMAIN_PARENT_PK1
-- these two lines are FULL OUTER JOINS in order to get courses with no enrollments
FULL OUTER JOIN course_users cu on cm.pk1 = cu.crsmain_pk1
FULL OUTER JOIN users u on cu.users_pk1 = u.PK1
INNER JOIN DATA_SOURCE dsc ON cm.data_src_pk1 = dsc.pk1
JOIN course_size cs ON cm.pk1 = cs.crsmain_pk1
LEFT join course_course cc2 ON cc2.CRSMAIN_PARENT_PK1 = cm.pk1
LEFT join course_main cm2 on cc2.CRSMAIN_PK1=cm2.pk1
WHERE dsc.BATCH_UID in ('1229')
group by cm.course_id, cm.course_name, cm2.course_id, cm.row_status, cm.start_date, cm.end_date, cm.available_ind, cm.course_view_option, cm.ultra_status, cs.size_coursefiles, cs.size_protectedfiles, cs.size_legacyfiles, cs.size_total
order by cm.course_id
