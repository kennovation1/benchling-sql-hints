/*
Creates a data dictionary for all fields used in the specified entity schema.
Starting with the specified schema, this script works backwards to find all
entities that reference the specified schema and all entities that reference
those and so on.

The output the list of all fields that when denormalized define the entities
in the specified schema. That data dictionary also represents the feature
vector that defines the final entity.

How it works:
Collects field definitions for all fields that contribute to entity schemas.

This cannot account for generic entity references (yet another reason not to use those if possible).
This does not collect any result table information. This could be added in the future.

First gets the unique set of schema names used to create an target schema and
then joins set that to field definitions to get the field details.

 Parameters:
     Name: Schema name
     Type: Text
*/
with recursive

-- Get a list of fields used in all entity schemas
all_entity_schemas as (
    select
        srcsc.name source_schema_name,
        targsc.name target_schema_name,
        fd.type field_type
    from field_definition$raw fd
    left join schema$raw targsc on targsc.id = fd.target_schema_id
    left join schema$raw srcsc on srcsc.id = fd.schema_id
    where
        fd.archived$ = false
        and srcsc.archived$ = false
        and srcsc.schema_type = 'entity'
),

-- Recursively get all schema names from fields that are entity_links starting from the specified schema
find_referenced_schemas as (
    select
        source_schema_name,
        target_schema_name
    from all_entity_schemas
    where source_schema_name = {{Schema name}}  -- INSIGHTS text parameter. A schema name is required.
    and field_type = 'entity_link'
    
    union
    select
        alles.source_schema_name, 
        alles.target_schema_name
    from all_entity_schemas alles
    join find_referenced_schemas frs on alles.source_schema_name = frs.target_schema_name
    where alles.field_type = 'entity_link'
),

-- Get the unique set of schema names
referenced_schemas as (
    select
        refsc.source_schema_name,
        sc.id source_schema_id
    from find_referenced_schemas refsc
    join schema$raw sc on sc.name = refsc.source_schema_name
    group by refsc.source_schema_name, sc.id
),

-- Get the field definitions for the referenced schemas
referenced_fields as (
    select
        refsc.source_schema_name,
        fd.display_name field_display_name,
        fd.system_name field_system_name,
        fd.type field_type,
        fd.is_multi,
        fd.is_required,
        fd.tooltip,
        targsc.name target_schema_name,
        dd.name dropdown_name
    from referenced_schemas refsc
    left join field_definition$raw fd on fd.schema_id = refsc.source_schema_id
    left join schema$raw targsc on targsc.id = fd.target_schema_id
    left join dropdown$raw dd on dd.id = fd.dropdown_id
    where fd.archived$ = false
    order by refsc.source_schema_name, fd.display_name
),

-- Get the count of entities for each schema. Include only registered and not archived entities.
entity_counts as (
    select
        rs.source_schema_name,
        count(*) count
    from referenced_schemas rs
    join registry_entity$raw re on re.schema_id = rs.source_schema_id
    where re.archived$ = false
    group by rs.source_schema_name
)


-- Get the unique set of referenced schema names
-- select * from referenced_schemas

-- Get the count of entities for each schema
select * from entity_counts
order by count desc

-- MAIN QUERY
-- Get the field definitions for the referenced schemas
select * from referenced_fields
