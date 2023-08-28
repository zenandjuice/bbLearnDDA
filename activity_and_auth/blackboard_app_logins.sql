--- authentication log event types
--
--        0: Login
--        1: Failed Login - Username Not Found
--        2: Failed Login - Wrong Password
--        3: Logout
--        4: Session Expire
--        5: Error
--        6: Info
--        7: Login created
--        8: Legacy Login
--        9: Legacy Logout
--        10: Legacy Session Expire

SELECT
  apl.username,
  ap.name as "Auth Provider Name",
--   apl.event_type,
  apl.log_date,
  apl.ip_address,
  apl.user_agent,
  apl.appserver_id
FROM auth_provider_log apl
INNER JOIN AUTH_PROVIDER ap ON ap.pk1 = apl.auth_provider_pk1
WHERE apl.log_date between '03/01/2023 00:00:00' and '03/13/2023 23:59:59'
and apl.event_type  = '0'
-- mobile apps consolidated into one
AND apl.user_agent ILIKE '%Blackboard%'
ORDER by apl.log_date 
