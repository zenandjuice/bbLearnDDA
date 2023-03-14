-- most of these are probably based on Jeff Kelley queries

SELECT cm.course_id, cm.service_level, cm.dtcreated,
/* coursefiles = data stored in course files aka content collection */  
	pg_size_pretty(cs.size_coursefiles) AS "Content Collection",
/* protectedfiles =  Files that are used in assignments, tests, and student submissions */
	pg_size_pretty(cs.size_protectedfiles) AS "Submisssions",
/* legacyfiles = files used prior to Learn 9.1. However, Some course tools that require private file storage may be stored in Legacy Filesystem Files instead of Protected Files. */
	pg_size_pretty(cs.size_legacyfiles) AS "Legacy Files",
	pg_size_pretty (cs.size_total) AS "Total Size",
	pg_size_pretty (cs.size_total) AS "Total Size (KB)"
FROM course_main cm
JOIN course_size cs ON cm.pk1 = cs.crsmain_pk1
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
-- each term has a unique DSK in my environment
--WHERE dsc.batch_uid = '1233'
WHERE cm.COURSE_ID LIKE '[course_id_pattern]%' 
--ORDER by cs.size_total DESC
--order by cs.size_legacyfiles DESC
ORDER by cs.size_coursefiles DESC
--ORDER by cm.dtcreated, cm.COURSE_ID



------------------------------------------------------------------------------------------------------------------------------

-- Cyndi Castro (UTEP) version to break down media types

SELECT 
	cm.course_id as CourseID,
--	cm.course_name as CourseName,
	u.user_id as UserID,
  u.email as Email,
  u.FIRSTNAME as FirstName,
  u.lastname as Lastname,
	pg_size_pretty(cs.size_total/1024) AS "TotalStorage (GB)",
/* coursefiles = data stored in course files aka content collection */  
	pg_size_pretty(cs.size_coursefiles/1024)  as "ContentCollection (GB)",
/* protectedfiles = Files that are used in assignments, tests, and student submissions */
	pg_size_pretty(cs.size_protectedfiles/1024)  as "StudentSubmissions (GB)",
	pg_size_pretty(cs.size_archivefiles/1024)  as "Archives (GB)",
/* legacyfiles = files used prior to Learn 9.1. However, Some course tools that require private file storage may be stored in Legacy Filesystem Files instead of Protected Files. */
	pg_size_pretty(cs.size_legacyfiles) as "Legacy Files",
	pg_size_pretty(cs.size_Imagefiles)  as "Images",
	pg_size_pretty(cs.size_audiofiles)  as "AudioFiles",
	pg_size_pretty(cs.size_videofiles/1024)  as "VideoFile (GB)",
	pg_size_pretty(cs.size_documentfiles)  as "Documents"
from course_main cm
JOIN course_size cs ON (cm.pk1 = cs.crsmain_pk1)
INNER JOIN course_users cu ON cm.pk1 = cu.crsmain_pk1
INNER JOIN users u ON cu.users_pk1 = u.pk1
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
-- each term has a unique DSK in my environment
WHERE dsc.batch_uid = 'DEV'
AND cu.role IN ('P', 'N', 'D')
ORDER by cs.size_videofiles desc
-- ORDER by cs.size_total desc, cs.size_videofiles DESC
--ORDER by cm.COURSE_ID




-- course sizes collecting instructors
-- File Sizes in MB

SELECT 
	cm.course_id, cm.course_name, cm.dtcreated,
	max(cu.last_access_date) as LAST_ACCESS,
	STRING_AGG(u.email, ';') AS emails,
	string_agg(distinct u.firstname||' '||u.lastname, ', ') as instructors,
/* coursefiles = data stored in course files aka content collection */  
	pg_size_pretty(cs.size_coursefiles) AS "Content Collection",
/* protectedfiles =  Files that are used in assignments, tests, and student submissions */
	pg_size_pretty(cs.size_protectedfiles) AS "Submisssions",
/* legacyfiles = files used prior to Learn 9.1. However, Some course tools that require private file storage may be stored in Legacy Filesystem Files instead of Protected Files. */
	pg_size_pretty(cs.size_legacyfiles) AS "Legacy Files",
	pg_size_pretty (cs.size_total) AS "Total Size",
	dsc.batch_uid AS "SIS Term ID"
FROM course_main cm
JOIN course_size cs ON (cm.pk1 = cs.crsmain_pk1)
INNER JOIN course_users cu ON cm.pk1 = cu.crsmain_pk1
INNER JOIN users u ON cu.users_pk1 = u.pk1
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
WHERE dsc.batch_uid = 'DEV'
--WHERE u.user_id = 'rbrubake'
--AND cm.course_ID like '%STAT%'
-- where	 (cm.COURSE_ID like '1126-THEUA%' or cm.COURSE_ID like 'MASTER-1126%')
--AND cu.row_status = '0'
--AND cu.role = 'P'
AND cu.role IN ('P', 'N', 'D')
--ORDER by cs.size_total DESC
--ORDER by cs.size_coursefiles DESC
GROUP by cm.COURSE_ID, cm.course_name, cm.dtcreated, cs.size_coursefiles, cs.size_protectedfiles, cs.size_legacyfiles, cs.size_total, ds.batch_uid
-- order by cm.dtcreated, CM.COURSE_ID
ORDER by last_access, cs.size_coursefiles DESC
