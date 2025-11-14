/*
Determine a list of entry templates that are actively used to register entities or submit assay results in a given schema.
This is different from the Relevant Templates tab on the schema detail pages since it shows how often
each template is used to register entities or submit assay results (and for a given lookback period).

By contrast, the Relevant Templates tab on the schema detail pages shows all templates that reference
the schema over all time regardless if they are actively used to register entities or submit assay results.
Relevant Templates also show templates that include lookup tables for the schema.

This query is useful when there are changes to a schema and there is a need to change all entry
templates that use the schema. In some environments, the list of relevant templates can be quite
large and it is therefore time consuming to manually open and review each template to see how the
schema is used.

This query does not cover sub-templates or direct table insertions into templates.

Query design summary:
- Relation flow:
  - Registry entities: registry_entity (all registered entities) > registration_origin (an entry) > entry > entry_template
  - Assay results: assay_result (all assay results) > entry > entry_template
- Show results for a single schema or all
- Exclude archived schemas, entities, assay results, or templates
- Exclude entities or results older than Start date or include all if no Start date

Parameters:
    Schema name (type: Text)
    Since date (type: Date)
    
Possible variations:
- Show count of entries instead of count of entities
- A cousin query would be to show template usage regardless of structured table use (entry > entry_template)
*/
with combined as (
    -- Registered entities
    select
        re.schema_id,
        re.created_at,
        ent.entry_template_id
    from
        registry_entity$raw re
        join registration_origin$raw ro on ro.entity_id = re.id
        join entry$raw ent on ent.id = ro.origin_entry_id
    where
        re.archived$ = false
        and ( {{Since date}} is null or re.created_at > {{Since date}} )
    
    union all
    
    -- Assay results
    select
        res.schema_id,
        res.created_at,
        ent.entry_template_id
    from
        result$raw res
        join entry$raw ent on ent.id = res.entry_id
    where
        res.archived$ = false
        and ( {{Since date}} is null or res.created_at > {{Since date}} )
)

select
    sc.schema_type "Schema type",
    sc.name "Schema name",
    et.name "Entry template name",
    count(*) as "Total entities registered or results submitted"
from combined
    join entry_template$raw et on et.id = combined.entry_template_id
    join schema$raw sc on sc.id = combined.schema_id
where
    sc.archived$ = false
    and ( {{Schema name}} is null or sc.name = {{Schema name}} )
    and et.archived$ = false
group by
    sc.schema_type, sc.name, et.name
order by
    "Total entities registered or results submitted" desc
