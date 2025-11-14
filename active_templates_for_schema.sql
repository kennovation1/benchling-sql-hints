/*
Determine a list of entry templates that are actively used to register entities in a given schema.
This is different from the Relevant Templates tab on the schema detail page since it shows how often
each template is used to register entities (and for a given lookback period).

By contrast, the Relevant Templates tab on the schema detail page shows all templates that reference
the schema over all time regardless if they are actively used to register entities.
Relevant Templates also show templates that include lookup tables for the schema.

This query is useful when there are changes to a schemas and there is a need to change all entry
templates that use the schema. In some environments, the list of relevant templates can be quite
large and it is therefore timeconsuming to manually open and review each template to see how the
schema is used.

Ths query does not cover sub-templates or direct table insertions into templates.

Query design summary:
- registry_entity (all registered entities) > registration_origin (an entry) > entry > entry_template
- Show results for a single schema at a time or all
- Exclude archived schemas, entities,  or templates
- Exclude older than Start date or include all if no Start date

Parameters:
    Schema name (type: Text)
    Since date (type: Date)
    
Possible variations:
- Show count of entries instead of count of entities
- Add result$raw or create a separate query for results
*/
select
    sc.name "Entity schema name",
    et.name "Entry template name",
    count(*) as "Total entities registered"
from
    registry_entity$raw re
    join registration_origin$raw ro on ro.entity_id = re.id
    join entry$raw ent on ent.id = ro.origin_entry_id
    join entry_template$raw et on et.id = ent.entry_template_id
    join schema$raw sc on sc.id = re.schema_id
where
    sc.archived$ = false
    and ( {{Schema name}} is null or sc.name = {{Schema name}} )
    and re.archived$ = false
    and ( {{Since date}} is null or re.created_at > {{Since date}} )
    and et.archived$ = false
group by
    et.name, sc.name
order by
    "Total entities registered" desc
