-- Returns which assessments are using Force Completion
-- array line from Jeff Kelley to add test name.

SELECT
  cm.course_id,
  qad.title, qad.bbmd_date_added, qad.bbmd_date_modified,
  qad.description, 
  --- test for changes for 3900.28 Force Completion change that also forces auto-submit (Article No.: 000075694)
  ca.time_limit, ca.soft_time_limit, ca.timer_completion,  
  ARRAY_TO_STRING(XPATH('//assessment/@title', CAST(convert_from(qad.data, 'UTF-8') AS XML)),'') as test_title
from course_main cm
JOIN qti_asi_data qad ON (cm.pk1 = qad.crsmain_pk1)
JOIN COURSE_ASSESSMENT CA ON (CA.QTI_ASI_DATA_PK1 = qad.pk1)
INNER JOIN data_source ds ON cm.data_src_pk1 = ds.pk1
WHERE
  -- Assessment
  bbmd_asi_type = 1
  -- Tests
AND bbmd_assessmenttype = 1
---- Many blank lines were returned in some courses, lets get rid of those
AND qad.title IS NOT NULL
AND CA.force_completion_ind = 'Y'
--AND ds.batch_uid = '1223'
ORDER BY
  cm.course_id,
  qad.position,
  qad.title
