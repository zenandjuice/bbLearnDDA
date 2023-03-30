-- Pull all categories and goals associated with a goal set in Learn
-- Mike Buchanan, via Slack

with recursive clp_sog_cte(pk1, parent_sog_pk1, layer, display_order, batch_uid, description, lrn_stds_sub_doc_pk1)
as
(
select cs1.pk1, 0::bigint, cs1.layer, cs1.display_order, cs1.batch_uid, cs1.description, cs1.lrn_stds_sub_doc_pk1
from clp_sog cs1 where cs1.parent_sog_pk1 is null -- base case
union all
select cs2.pk1, cs2.parent_sog_pk1, cs2.layer, cs2.display_order, cs2.batch_uid, cs2.description, cs2.lrn_stds_sub_doc_pk1
from clp_sog cs2
join clp_sog_cte csc1 on cs2.parent_sog_pk1 = csc1.pk1 -- recursive case
)
select lsd.name "Goal Set Name", ds.name "Goal Set Type", lssd.name "Category", ls.label "Goal Type", ls.doc_num "Goal ID", csc.batch_uid "Goal UUID", csc.pk1, csc.parent_sog_pk1, csc.layer, csc.display_order, csc.description "Goal Text" -- for detailed ordering validation
from lrn_stds_discipline lsd
join lrn_stds_doc doc on doc.lrn_stds_discipline_pk1 = lsd.pk1
join lrn_stds_doc_set ds on doc.lrn_stds_doc_set_pk1 = ds.pk1
join lrn_stds_provider lsp on ds.lrn_stds_provider_pk1 = lsp.pk1
join lrn_stds_sub_doc lssd on lssd.lrn_stds_doc_pk1 = doc.pk1
left join clp_sog_cte csc on csc.lrn_stds_sub_doc_pk1 = lssd.pk1
join lrn_standard ls on ls.clp_sog_pk1 = csc.pk1
--where lsd.name ilike '%[goal_name]%'
order by csc.pk1, csc.parent_sog_pk1, csc.display_order
