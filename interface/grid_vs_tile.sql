-- Tile/grid vs list in Base Navigation

select u.user_id, ur.registry_key, ur.registry_value 
from users u
left join user_registry ur  on u.pk1 = ur.users_pk1
where ur.registry_key = 'PREF:ultraui.courselist.view.course'
-- only grid
-- and ur.registry_value = 'grid'
-- only list
-- and ur.registry_value = 'list


-- Count of each view based on available users who have logged in.

select ur.registry_value, count (u.user_id) 
from users u
left join user_registry ur  on u.pk1 = ur.users_pk1
where ur.registry_key = 'PREF:ultraui.courselist.view.course'
and u.available_ind = 'Y'
and u.last_login_date is not null
group by ur.registry_value 
