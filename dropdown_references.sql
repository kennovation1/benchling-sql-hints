/*
Shows information about how dropdowns are referenced.

Note that dropdowns may be used as Insights Dashboard parameters
and this report does not show such references.

To use this in a dashboard, create two blocks that use the same SQL.
Comment and uncomment as required for each block (see comments at bottom of SQL).

Block 1:
  Name: Dropdown counts (does not show unreferenced DDs)
  Description: Shows incoming references for different types of objects (e.g., dropdowns, entity schemas)

Block 2:
  Name: Dropdown references
  Description: Shows which entity schemas (regardless of archived status)
    reference the dropdown specified by the "Dropdown name" parameter.
    If the parameter is blank, shows all dropdowns.

Parameter: Dropdown name (type: Text)
  Executing block 2 will cause the parameter to be created. Leave the data type as Text
*/
with

--Get all dropdown refernences (includes dropdowns that have no references to them)
core as (
    select
        dd.name dd_name,
        dd.archived$ dd_archived,
        sc.name as schema_name,
        sc.archived$ schema_archived
    from dropdown$raw dd
    left join field_definition fd on fd.dropdown_id = dd.id
    join schema$raw sc on sc.id = fd.schema_id
),

-- Count of how many times an unarchived dropdown is referenced by an unarchived schema.
-- This does not represent dropdowns that are unreferenced (0 counts).
dd_counts as (
    select
        dd_name,
        count(*) count
    from core
    where
        dd_archived = false
        and schema_archived = false
    group by dd_name
    order by count desc
    )

-- Dropdown reference counts
-- Comment in for block 1, comment out for block 2
--select * from dd_counts

-- Main query
-- Comment out for block 1, comment in for block 2
select
    *
from core
--where dd_name = 'Project Tag'
where dd_name = {{Dropdown name}} or {{Dropdown name}} is null
order by dd_name, schema_name
