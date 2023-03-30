--- Find Aligned Content in Specific Course

SELECT
cac.pk1,
cm.course_id,
cac.cms_pk1,
cac.rubric_pk1,
cac.rubric_row_pk1,
cac.blogs_pk1,
cac.forum_main_pk1,
cac.qti_asi_data_pk1,
cac.gradebook_main_pk1,
    -- gm.pk1,
gm.title as "Grade Center Column",
cac.msg_main_pk1,
cac.course_contents_pk1,
cac.title,
cac.description,
cac.type
FROM CLP_ALIGNABLE_CONTENT cac
INNER JOIN course_main cm ON cac.crsmain_pk1 = cm.pk1
INNER JOIN gradebook_main gm on gm.crsmain_pk1 = cm.pk1
INNER JOIN data_source dsc ON cm.data_src_pk1 = dsc.pk1
--INNER JOIN gradebook_main gm on gm.pk1 = cac.gradebook_main_pk1
WHERE  cac.gradebook_main_pk1 = gm.pk1
AND cm.COURSE_ID like '%[course_id_string]%'
--AND dsc.batch_uid = '1229'
