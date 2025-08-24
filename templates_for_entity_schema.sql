/*
What templates are actively used to register the defined entity schema.

Ths does not cover sub-templates or direct table insertions.

Parameters:
    Schema name (type: Text)
    Since date (type: Date)
*/

with
-- Get all non-archived registered entities for a provided schema display name
entities_for_schema as (
    select
        re.*
    from registry_entity$raw re
    join entity_schema$raw es on es.id = re.schema_id
    
    where re.archived$ = false
    and es.name = {{Schema name}}
),

-- Get entities and the templates that registered them (excludes those that did not use a template)
entities_with_templates as (
    select
        et.name "template_name",
        efs.id "entity_id"
    from entities_for_schema efs
    join registration_origin$raw ro on ro.entity_id = efs.id
    join entry$raw ent on ent.id = ro.origin_entry_id
    join entry_template$raw et on et.id = ent.entry_template_id
    where et.archived$ = false
    and ( {{Since date}} is null or efs.created_at > {{Since date}} )
)

-- Create final report
select
    template_name,
    count(*) "entity_count"
from entities_with_templates
group by template_name
order by entity_count desc