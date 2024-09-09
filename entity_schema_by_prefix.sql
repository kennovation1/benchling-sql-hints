/*
 Lookup information about an entity schema based on a schema prefix parameter.

 This is useful if you you are creating a new entity or using the Configuration Migration tool
 and have a prefix conflict and need to know what the conflicting entity schema is.

 Note that you can have a conflict with a previously used prefix even if the schema is archived.
 This makes this utility even more useful since you may want to rename (e.g., add an "archived suffix")
 the prefix on the archived schema. Note that this query uses $raw and does not filter on archive
 for this reason.

 Parameters:
     Prefix - Type: Text
*/
select
    prefix,
    name,
    system_name,
    entity_type,
    containable_type,
    archived$,
    archive_purpose$
from entity_schema$raw es
where es.prefix ilike {{Prefix}} or {{Prefix}} is null
order by es.prefix