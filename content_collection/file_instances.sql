--- all instances of file (based on blob_id)

select fver.blob_id, furl.FILE_ID, furl.file_name, furl.FULL_PATH, pg_size_pretty(ffile.file_size) AS size_mb, ffile.mime_type,   ffile.last_update_date
FROM xyf_urls furl
 JOIN xyf_files ffile on ffile.file_id = furl.file_id
 INNER JOIN xyf_file_versions fver ON fver.file_id = ffile.file_id
 WHERE file_type_code = 'F'
--and fver.blob_id = '10589914'
 AND furl.file_name LIKE '%[string in filename]%'
ORDER BY ffile.file_size desc
