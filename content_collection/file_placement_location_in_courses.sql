--- Where are files linked in a course - this is if they're in course contents, not if they're linked via text in the content editor

-- uses main database

select cm.course_id,
--u.batch_uid,
cc.cnthndlr_handle,ccp.title as "Parent Title", cc.title as "Content Item Name", f.file_name, f.link_name, f.storage_type, f.pk1,  pg_size_pretty(f.file_size/1024/1024, 2) AS "File Size (MB)"
 from course_contents cc
 join course_contents_files ccf on cc.pk1 = ccf.course_contents_pk1
 left join course_contents ccp on cc.parent_pk1 = ccp.pk1
 join course_main cm on cc.crsmain_pk1 = cm.pk1
 join files f on ccf.files_pk1 = f.pk1
 --JOIN course_users cu on cm.pk1 = cu.crsmain_pk1
 --JOIN users u on cu.users_pk1 = u.PK1
 where cm.course_id = '[course_id]'
 --and f.link_name like '%.mp4'
 --and cu.role = 'P'
-- and u.batch_uid = 'yuezhao'
 -- order by f.file_size DESC
 order by pk1
