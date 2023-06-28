-- List LTI Tool Providers and each placement in the Learn server

select
bdh.domain_name as "Tool/Provider Domain",
bdc."name" as "LTI 1.3 Tool Provider Name",
case
	when bdc.lti_type = '1' then 'LTI 1.1'
	when bdc.lti_type = '3' then 'LTI 1.3'
	else 'Other'
end as "LTI Provider Type",
case 
	when bdc.config_status = 'A'then 'Approved'
	when bdc.config_status = 'E'then 'Excluded'
	when bdc.config_status = 'N'then 'Needing Approval'
	else bdc.config_status
end as "Provider Config Status",
bdc.grade_service_ind as "Grade Service Access",
bdc.membership_service_ind as "Membership Service Access",
case 
	when bdc.send_user_data = 'A'then 'Always'
	when bdc.send_user_data = 'N'then 'Never'
	when bdc.send_user_data = 'S'then 'SSL Only'
	when bdc.send_user_data = 'Y'then 'Yes'
	else bdc.send_user_data
end AS "Send User Data",
bdc.user_role_ind as "Send User Data",
bdc.user_name_ind as "Send User's Name",
bdc.user_email_ind as "Send User's Email",
bdc.batch_uid_ind as "Send Course/User BATCH_UID",
bdc.uuid_ind as "Send Course/User UUID",
case 
	when bdc.allow_edit_ind = 'Y'then 'Yes'
	when bdc.allow_edit_ind is NULL then 'Yes'
	when bdc.allow_edit_ind = 'N'then 'No'
	else bdc.allow_edit_ind
end AS "Tool/Provider Editable?",
bdc.trusted_service_id as "Trusted Source Identifier",
bdc.custom_parameters as "Custom Parameters",
-- bdc.auth_key, bdc.auth_secret,
bdc.client_id as "LTI 1.3 Client ID",
bdc.deployment_id as "LTI 1.3 Deployment ID",
bp.name as "Placement Name",
bp.handle as "Placement handle",
case 
	when bp.type = 'A'then 'Course tool (legacy)'
	when bp.type = 'C'then 'Course content tool'
	when bp.type = 'I'then 'Deep Linking content tool'
	when bp.type = 'S'then 'System Tool'
	when bp.type = 'M'then 'Administrator tool'
	when bp.type = 'U'then 'Ultra extension'
	when bp.type = 'B'then 'Base navigation tool'
	when bp.type = 'R'then 'R'
	when bp.type = 'P'then 'P'
	when bp.type = 'L'then 'Cloud document'
	else bp.type
end AS "Placement Type",
bp.url as "Placement URL",
bp.icon as "Placement Icon",
bp.external_sync as "Placement Icon Sync",
bp.custom_parameters as "Placement Custom Parameters",
bp.allow_grading_ind as "Placement Allow Grading",
bp.available_ind as "Placement Available",
bp.launch_new_window as "Launch in New Window",
bp.allow_students_ind as "Placement usable by students",
bdh.primary_ind as "Primary Domain"
from blti_domain_config bdc
left join blti_domain_host bdh on bdc.pk1 = bdh.blti_domain_config_pk1
inner join blti_placement bp on bdc.pk1 = bp.blti_domain_config_pk1
--where bdh.primary_ind = 'N'
order by bdc.lti_type, bdh.domain_name
