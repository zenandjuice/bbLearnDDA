-- Content Collect files with deletion issue

-- IF a course quota is set, AND the course is near quota, AND someone tries to overwrite a file,
-- the overwrite will happen but the original file will remain in the course content collection list, but really be located at the root of the system content collection.
-- The file still counts toward the course quota but cannot be acted upon.  
-- Bb support will need to move the file to the original course location, so that it can be deleted.
-- Case #05012428 - Content Collection File Cannot be deleted

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
 AND furl.full_path not like '/courses/%'
 AND furl.full_path not like '/internal/%'
 AND furl.full_path not like '/orgs/%'
 AND furl.full_path not like '/users/%'
 AND furl.full_path not like '/library/%'
 AND furl.full_path not like '/institution/%'
 ORDER BY ffile.file_size DESC
