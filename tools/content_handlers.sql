-- Content Handlers with icons
select ch.pk1, ch.blti_placement_pk1, ch.handle, ch.dtmodified, ch.name, ch.icon_list, *
from content_handlers ch
ORDER by handle
