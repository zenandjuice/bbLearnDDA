-- Users with phone numbers in their profile
-- Used by the Connect / SMS tools
-- It really should be only MOBILE numbers but it seems that some put their landline/office phones too


SELECT u.USER_ID as "Username",u.LASTNAME,u.FIRSTNAME,u.m_phone,u.EMAIL,u.available_ind,u.last_login_date,u.dtcreated,u.dtmodified,
dsu.batch_uid AS "Data Source Key"
FROM USERS u
INNER JOIN data_source dsu on u.data_src_pk1 = dsu.pk1
--WHERE dsu.batch_uid ='UARK'
where u.m_phone is not null
and u.available_ind = 'Y'
ORDER BY USER_ID
