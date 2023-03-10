-- Run in ..._stats

SELECT
    cm.COURSE_ID, course_contents.title,
    SUM(CA.ACCESS_MINUTES) AS TOTAL_TIME_IN_MIN,
    SUM(CA.CONTENT_ACCESS_STARTS) AS "Content Accesss Starts",
    MIN(CA.INITIAL_DATETIME_ACCESS) AS EARLIEST_ACCESS_TIME
    FROM ODS_AA_CONTENT_ACTIVITY CA
    LEFT JOIN ODS_AA_SESSION_ACTIVITY SA    ON    CA.LOGIN_PK1 = SA.LOGIN_PK1
    LEFT JOIN  COURSE_MAIN CM    ON    CA.COURSE_PK1 = CM.PK1
    LEFT JOIN  USERS U    ON    CA.USER_PK1 = U.PK1
    inner join (   
	  select *
  	from dblink('dbname=[dbname] user=[dbuser] password=[password]', 'select pk1, title from course_contents')
  	as course_contents(pk1 int, title text)
	) as course_contents ON ca.content_pk1 = course_contents.pk1
WHERE CM.COURSE_ID='[course_id]'
    GROUP BY CM.COURSE_ID, course_contents.title
    ORDER BY CM.course_id, course_contents.title
    
