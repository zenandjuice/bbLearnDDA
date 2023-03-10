-- Returns course information, content collection size, quota
-- Launch in _cms_doc
-- change dblink values for your system
-- Chris Bray 2023-03-10

SELECT
   course.course_id as "Course ID", course.crsmain_pk1 "Course PK1", 
   CASE 
           WHEN course.row_status = 0 THEN 'ENABLED'
           WHEN course.row_status = 2 THEN 'DISABLED'
           ELSE 'OTHER'
   END AS "Row Status",
   course.available_ind,
   -- calculates percentage of quota and comments on level
      round(((nullif(course.size_coursefiles::decimal,0)/ffile.quota::decimal)*100),2) as "Percentage of Quota",
   case
		when   round(((nullif(course.size_coursefiles::decimal,0)/ffile.quota::decimal)*100),2) > '100' then 'Over Quota'
		when   round(((nullif(course.size_coursefiles::decimal,0)/ffile.quota::decimal)*100),2) > '90' and    round(((nullif(course.size_coursefiles::decimal,0)/ffile.quota::decimal)*100),2) < '100' then 'Dangerouos' 
   		when   round(((nullif(course.size_coursefiles::decimal,0)/ffile.quota::decimal)*100),2) > '80' and    round(((nullif(course.size_coursefiles::decimal,0)/ffile.quota::decimal)*100),2) < '90' then 'Warning'
   		else 'Acceptable'
   	end as "Level",
   -- Course Size and Quota
   pg_size_pretty(course.size_coursefiles) as "Content Collection Size",
   pg_size_pretty(ffile.quota) as "Quota",
   furl.full_path,
   ffile.last_update_date
FROM xyf_urls furl
JOIN xyf_files ffile on ffile.file_id = furl.file_id
inner join dblink('dbname=[dbname] user=[username] password=[password]',
	'select course_main.course_id, course_main.pk1, course_main.row_status, course_main.available_ind, course_size.size_coursefiles FROM course_main JOIN course_size ON course_main.pk1 = course_size.crsmain_pk1')
    AS course(course_id varchar(100), crsmain_pk1 int8, row_status int8, available_ind bpchar(1), size_coursefiles int8)
    ON furl.file_name = course.course_id
WHERE file_type_code = 'D'
AND furl.full_path like '/courses/%'
-- i noticed there were some returned values where "A" course_id was in a nested folder.  This will take care of those.
and furl.full_path not like '/courses/%/%'
-- only return courses where a quota is set
--and ffile.quota is not null
-- which courses do not have a quota
--and ffile.quota is null
-- only pull the top-level course folder by matching parts
 and furl.file_name in (
 		select split_part(furl.full_path, '/', 3)
			FROM xyf_urls furl
 			JOIN xyf_files ffile on ffile.file_id = furl.file_id
			 WHERE file_type_code = 'D'
			 AND furl.full_path like '/courses/%')
and course.row_status = '0'
-- enter course_id string to narrow down results
and course.course_id like '%'
order by course.size_coursefiles DESC
