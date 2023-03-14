-- show URL of files, formatted for kaltura bulk upload csv
-- make "Media" folder public so Kaltura can grab the files
 
SELECT
   furl.file_name as "* title"
   ,'Video from '||split_part(furl.full_path, '/', 3) as "description"
   ,split_part(furl.full_path, '/', 3) as "tags"
  ,'https://learn.uark.edu/bbcswebdav'||furl.full_path as "url"
  ,split_part(ffile.mime_type, '/', 1) as "contentType"
FROM xyf_urls furl
 JOIN xyf_files ffile on ffile.file_id = furl.file_id
 WHERE file_type_code = 'F'
 -- I move all media into a course content collection folder called 'Media'
 AND furl.full_path like '/courses/[course_id]/Media%'
 ORDER BY ffile.file_id
 
 
