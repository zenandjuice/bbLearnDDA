
-- Below use _cms_doc

-- Find specific filename in content collection

SELECT
  furl.file_id,furl.file_name
  ,pg_size_pretty(ffile.file_size) as size_Mb
  ,ffile.last_update_date
  ,ffile.mime_type
  ,furl.full_path
FROM xyf_urls furl
 JOIN xyf_files ffile on ffile.file_id = furl.file_id
 WHERE file_type_code = 'F'
 AND furl.full_path like '/internal/courses/[course_id_pattern]%'   --this is the path to manual archive files
 --and furl.file_name LIKE '%mp4'
 --and ffile.created_by = '342344'
 ORDER BY ffile.file_size DESC

 -----

 -- case # 05176907  Copied embedded content added to READ_ONLY folder in course content collection

  SELECT
  furl.file_id
  ,furl.file_name
  ,pg_size_pretty(ffile.file_size) as size_Mb
  ,ffile.last_update_date
  ,ffile.mime_type
  ,furl.full_path
FROM xyf_urls furl
 JOIN xyf_files ffile on ffile.file_id = furl.file_id
 WHERE file_type_code = 'F'
 AND furl.full_path like '/courses/%READ_ONLY/content%'   --this is the path to manual archive files
  ORDER BY ffile.file_size DESC

 -- Find course files

 SELECT
  furl.file_id
  ,furl.file_name
  ,pg_size_pretty(ffile.file_size) as size_Mb
  ,ffile.last_update_date
  ,ffile.mime_type
  ,furl.full_path
FROM xyf_urls furl
 JOIN xyf_files ffile on ffile.file_id = furl.file_id
 WHERE file_type_code = 'F'
 AND furl.full_path like '/courses/[course_id]/Media%'   --this is the path to manual archive files
 ORDER BY ffile.file_size DESC
