-- based on a Jeff Kelley query
-- this shows video files in the system that do not exist in certain folders, so we focus on course and user folders

/*----------
  jeff.kelley@blackboard.com  27 Feb 2021
  no warranty or support
  use with the _cms_doc database
  lists the paths and files of the largest 1000 files on the system.
  Excluding manual and automatic archives
  -----
*/

SELECT
  fver.blob_id,          -- blob ID is the key value of the unique file on the file system
  furl.file_id,
  furl.file_name,
  pg_size_pretty(ffile.file_size) AS size_mb,
  ffile.last_update_date,
  ffile.mime_type,
  split_part(furl.full_path, '/', 3) as course_id,
  furl.full_path
FROM xyf_urls furl
 INNER JOIN xyf_files ffile ON ffile.file_id = furl.file_id
 INNER JOIN xyf_file_versions fver ON fver.file_id = ffile.file_id
  WHERE ffile.file_type_code = 'F'                            --F for Files and not D for directory
 AND furl.full_path NOT LIKE '/internal/autoArchive/%'     -- no automatic archives (in *_cms_doc)
 AND SPLIT_PART(furl.full_path,'/',5) != 'archive%'         -- no manual archives (in *_cms_doc)
 and furl.full_path not like '/internal/evidence/assignmentEvidenceProvider/%' -- outcomes assessment
 and furl.full_path not like '/internal/portfolio/%' -- portfolios
 AND furl.full_path NOT LIKE '%/attempt/%'     -- student assignment submissions
 AND furl.full_path NOT LIKE '%/db/%'     -- student discussion submissions
 AND furl.full_path NOT LIKE '%/blog/%'     -- student blog submissions
 AND furl.full_path NOT LIKE '%/groups/%'     -- student blog submissions
 and furl.full_path NOT LIKE '%/groups/%'     -- student blog submissions
 and furl.full_path not like '/internal/courses/%/content/%'    -- SCORM mainly
-- and furl.full_path like '/courses/1229-%'
 --and furl.file_name LIKE '%.pptx'
 and ffile.mime_type like 'video%'
ORDER BY ffile.file_size DESC
FETCH FIRST 1000 ROWS only
