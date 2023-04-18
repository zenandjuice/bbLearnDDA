SELECT cm.course_id, u.user_id, qad.title as "Question Title", qad3.title as "Test Title", qad.description as "Question",
case 
	when qad.bbmd_assessmenttype = 1 then 'Test'
	when qad.bbmd_assessmenttype = 3 then 'Survey'
	when qad.bbmd_assessmenttype = 4 then 'Pool'
	ELSE 'Other'
	END AS USED_IN,
    CASE
    WHEN qad.BBMD_QUESTIONTYPE = 1 THEN 'Multiple Choice'
    WHEN qad.BBMD_QUESTIONTYPE = 2 THEN 'True/False'
    WHEN qad.BBMD_QUESTIONTYPE = 3 THEN 'Multiple Answer'
    WHEN qad.BBMD_QUESTIONTYPE = 4 THEN 'Ordering'
    WHEN qad.BBMD_QUESTIONTYPE = 5 THEN 'Matching'
    WHEN qad.BBMD_QUESTIONTYPE = 6 THEN 'Fill In the Blank'
    WHEN qad.BBMD_QUESTIONTYPE = 7 THEN 'Essay Question'
    WHEN qad.BBMD_QUESTIONTYPE = 8 THEN 'Numeric'
    WHEN qad.BBMD_QUESTIONTYPE = 9 THEN 'Calculated'
    WHEN qad.BBMD_QUESTIONTYPE = 10 THEN 'FileUpload'
    WHEN qad.BBMD_QUESTIONTYPE = 11 THEN 'HotSpot'
    WHEN qad.BBMD_QUESTIONTYPE = 12 THEN 'FillintheBlankPlus'
    WHEN qad.BBMD_QUESTIONTYPE = 13 THEN 'Jumbled sentence'
    WHEN qad.BBMD_QUESTIONTYPE = 14 THEN 'Quiz Bowl'
    WHEN qad.BBMD_QUESTIONTYPE = 15 THEN 'LikeRT Scale'
    WHEN qad.BBMD_QUESTIONTYPE = 16 THEN 'Short Answer'
    WHEN qad.BBMD_QUESTIONTYPE = 17 THEN 'EitherOr'
    ELSE 'OTHER'
    END AS QUESTION_TYPE
    -- ,encode(qad.data, 'escape')
FROM qti_asi_data qad
join course_main cm ON qad.crsmain_pk1 = cm.pk1
JOIN course_users cu on cm.pk1 = cu.crsmain_pk1
JOIN users u on cu.users_pk1 = u.PK1
join qti_asi_data qad2 on qad.parent_pk1 = qad2.pk1
join qti_asi_data qad3 on qad2.parent_pk1 = qad3.pk1
INNER JOIN data_source ds ON cm.data_src_pk1 = ds.pk1
--- I have a different DSK per term
WHERE ds.batch_uid = '1223'
AND cu.role = 'P'
-- Always will be '3' for questions
AND qad.BBMD_ASI_TYPE = '3'
-- BBMD_ASSESSMENTTYPE: This is the assessment type for this record when bbmd_asi_type=1. 1=Test, 2=Quiz (Not used), 3=Survey, 4=Pool
-- AND bbmd_assessmenttype = 1
-- This is the type of this record when bbmd_asi_type=3. 
-- 1=Multiple Choice, 2=True/False, 3=Multiple Anser, 4=Ordering, 5=Matching, 6=Fill In the Blank, 7=Essay Question, 
-- 8=Numeric, 9=Calculated, 10=FileUpload, 11=HotSpot, 12=FillintheBlankPlus, 13=Jumbled sentence, 14=Quiz Bowl, 15=LikeRT Scale, 16=Short Answer, 17=EitherOr
AND qad.BBMD_QUESTIONTYPE = '18'



-- I was curious about the number of test questions in the system, broken down by question type.
-- by Chris Bray (cbray@uark.edu)

SELECT
  cm.course_id, u.user_id,
  qad.title AS "Question Title",
-- Always will be '3' for questions
-- qad.BBMD_ASI_TYPE,
  qad.description,
--  qad.BBMD_QUESTIONTYPE,
    CASE
    WHEN qad.BBMD_QUESTIONTYPE = 1 THEN 'Multiple Choice'
    WHEN qad.BBMD_QUESTIONTYPE = 2 THEN 'True/False'
    WHEN qad.BBMD_QUESTIONTYPE = 3 THEN 'Multiple Answer'
    WHEN qad.BBMD_QUESTIONTYPE = 4 THEN 'Ordering'
    WHEN qad.BBMD_QUESTIONTYPE = 5 THEN 'Matching'
    WHEN qad.BBMD_QUESTIONTYPE = 6 THEN 'Fill In the Blank'
    WHEN qad.BBMD_QUESTIONTYPE = 7 THEN 'Essay Question'
    WHEN qad.BBMD_QUESTIONTYPE = 8 THEN 'Numeric'
    WHEN qad.BBMD_QUESTIONTYPE = 9 THEN 'Calculated'
    WHEN qad.BBMD_QUESTIONTYPE = 10 THEN 'FileUpload'
    WHEN qad.BBMD_QUESTIONTYPE = 11 THEN 'HotSpot'
    WHEN qad.BBMD_QUESTIONTYPE = 12 THEN 'FillintheBlankPlus'
    WHEN qad.BBMD_QUESTIONTYPE = 13 THEN 'Jumbled sentence'
    WHEN qad.BBMD_QUESTIONTYPE = 14 THEN 'Quiz Bowl'
    WHEN qad.BBMD_QUESTIONTYPE = 15 THEN 'LikeRT Scale'
    WHEN qad.BBMD_QUESTIONTYPE = 16 THEN 'Short Answer'
    WHEN qad.BBMD_QUESTIONTYPE = 17 THEN 'EitherOr'
    ELSE 'OTHER'
    END AS QUESTION_TYPE,
  qad.BBMD_DATE_ADDED
-- Don't really care about the questions/answers at the moment
--  qad.data
FROM course_main cm
JOIN qti_asi_data qad ON cm.pk1 = qad.crsmain_pk1
JOIN course_users cu on cm.pk1 = cu.crsmain_pk1
JOIN users u on cu.users_pk1 = u.PK1
INNER JOIN data_source ds ON cm.data_src_pk1 = ds.pk1
--- I have a different DSK per term
WHERE ds.batch_uid = '1223'
-- This is the qti asi type for this record. 1=Assessment, 2=Section, 3=Item
AND qad.BBMD_ASI_TYPE = '3'
-- BBMD_ASSESSMENTTYPE: This is the assessment type for this record when bbmd_asi_type=1. 1=Test, 2=Quiz (Not used), 3=Survey, 4=Pool
-- AND bbmd_assessmenttype = 1
-- This is the type of this record when bbmd_asi_type=3. 
-- 1=Multiple Choice, 2=True/False, 3=Multiple Anser, 4=Ordering, 5=Matching, 6=Fill In the Blank, 7=Essay Question, 
-- 8=Numeric, 9=Calculated, 10=FileUpload, 11=HotSpot, 12=FillintheBlankPlus, 13=Jumbled sentence, 14=Quiz Bowl, 15=LikeRT Scale, 16=Short Answer, 17=EitherOr
AND qad.BBMD_QUESTIONTYPE = '9'
AND cu.role = 'P'
ORDER BY cm.course_id, u.user_id, qad.title


------------------------------------------------------------------------------------------------------------------------------

-- Count of distinct question types in a semester
-- 1=Multiple Choice, 2=True/False, 3=Multiple Anser, 4=Ordering, 5=Matching, 6=Fill In the Blank, 7=Essay Question, 
-- 8=Numeric, 9=Calculated, 10=FileUpload, 11=HotSpot, 12=FillintheBlankPlus, 13=Jumbled sentence, 14=Quiz Bowl, 15=LikeRT Scale, 16=Short Answer, 17=EitherOr
-- by Chris Bray (cbray@uark.edu)

SELECT DISTINCT(qad.BBMD_QUESTIONTYPE), count (qad.BBMD_QUESTIONTYPE)
FROM course_main cm
JOIN qti_asi_data qad ON cm.pk1 = qad.crsmain_pk1
INNER JOIN data_source ds ON cm.data_src_pk1 = ds.pk1
--- I have a different DSK per term
WHERE ds.batch_uid = '1223'
AND qad.BBMD_ASI_TYPE = '3'
GROUP BY qad.BBMD_QUESTIONTYPE
ORDER by qad.BBMD_QUESTIONTYPE
