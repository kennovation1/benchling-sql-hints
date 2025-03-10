# Benchling SQL Hints

## Overview
The purpose of this repo is to collect and catalog SQL snippets
that are helpful when working with SQL on the
[Benchling](www.benchling.com) lab informatics platform
using the Insights dashboard or the Warehouse.

I decided to create this as a repo instead of discrete gists to make it
easier to find snippets and other information to help you be faster
and more effective with querying data from Benchlig.

This is a new repo and I'll be fleshing it out more soon.

PR's or contributions from any other channel are most welcome.

## General reference information and context
- Benchling's Insights module is based on their Warehouse function
- Benchling's Warehouse is built on PostreSQL and hosted by AWS
  - I'll not document the version since that's too hard to keep current
- [Benchling Warehose & Getting started](https://docs.benchling.com/docs/getting-started) guide
- [Boston Benchling User Group](https://www.meetup.com/benchling-user-group-boston/)
  (organized by yours truly, Ken Robbins)
- [Benchling Community forum](https://community.benchling.com/)

## TODO
- Add any appropriate trademark and copyright citations as needed
- Pick some sort of creative commons license
- Scour my notes and code to create new snipped files

## Guide to snippets
- `registry_name` should be replaced by your registry name. 
  If you only have a single organization, then you can omit this.
  If you have more than one organization, it's important to specify
  which registry you are using since omitting it will give you a default and
  possibly the wrong schema (since the same tables may appear in different
  organizations schemas).

  If you are using the Warehouse (the following will not work for Insights) you
  can prefix your query (or include in a "pre SQL" script depending on your tool) with:
  `SET search_path TO registry_name` and then omit the `registry_name` schema prefix
  in your queries. Don't do this if you are developing using the Warehouse with the
  intent to deploy via Insights if there are multiple registries since you will need
  the schema prefix in that case.
  
## Catalog of snippets
- [parameter_handling.sql](./parameter_handling.sql) - Patterns for handling Insights dashboard parameters
- [well_position_display.sql](./well_position_display.sql) - Convert row/col indices to A1-format
- [folder_path_construction.sql](./folder_path_construction.sql) - Construct a folder path
- [simple_pivot.sql](./simple_pivot.sql) - Pivot a single row result
- [entity_schema_by_prefix.sql](./entity_schema_by_prefix.sql) - Lookup information about an entity schema based on a schema prefix parameter
- [dropdown_references.sql](./dropdown_references.sql) - Shows information about how dropdowns are referenced
- [hierarchical_inventory.sql](./hierarchical_inventory.sql) - Create a hierarchical location path for an inventory container (e.g., box)
- [data_dictionary.sql](./data_dictionary.sql) - Create a data dictionary of all fields from all schemas that contribute to the target schema
- [Unit_entity](./Unit_entity/) - Files related to creating and populating a custom Unit entity as a custom data type

## Utilities
The `utilities` folder contains Python scripts.

Currently, there is a single utilities file called `unpack_insights_export.py`.
Benchling Support is able to export all your dashboard SQL (and some, but not all metadata)
into a CSV file. This file is not directly usable on its own and needs to be unpacked
(also, don't try to open in Excel). Once unpacked, this is a powerful resource to allow
you to easily see across your Insights landscape. This is important if you are trying to
assess the Insights impacts from data model changes, trying to pull back your data to
start controlling it in git, etc. The comment block at the start of the script provides
all details.

## Development hints
The section collection random hints that can help while developing Insights
dashboard or Warehouse queries for Benchling.

- **Creating parameters.** Instead of using the UI to click through to add a new parameter,
  you can simply include your parameter in your SQL and it will be automatically added
  when you save (Run Query) your query. To add a parameter in your SQL type the name
  surrounded by double curly brackets such as `{{My Parameter}}`. Once created you
  will need to click on its name in the UI to set the data type and if desired to check
  the box to "Allow multiple values".

- **Show raw output button.** When in edit mode, one of the buttons on the top-rigth of the result
  table is the "Show raw output" button. I mention it here since it's easy to forget this exists
  and it can be useful during debugging. By default, Benchling magically transforms object IDs
  into chips. This is quite handy by can sometimes obscure issues on complex queries. Sometimes
  it's useful to see the types of IDs that are being returned as part of the debugging process.

- **Develop outside of Insignts.** TODO. This section is to be written. In short it can be
  more productive to write queries in another tool and then copy the results back into Insights.
  Add note about name resolution diffs and parameters handling diffs.

- **Use Git!** TODO. This section is to be written. In short, use Git since Insights has no
  versioning (yet) or protection against query loss or corruption. Git provides many other benefits
  as well (see my community post for some text)

- **Save often.** Save often (by executing your Insights query) since there is no autosave.
  There is currently no version control, but in a pinch you can use the audit logs to find the
  SQL for an older version. However, per the above, I strongly recommend you develop outside
  of Insights and use git. If you do that, then the version in Insights can always be easily
  restored since it is not the source of truth.

- **Use a restricted project.** Dashboards live in projects and therefore inherit their permissions.
  Therefore, it's easy for end users to change the SQL or the parameters or the charting options.
  To prevent this, always put shared dashboards in a project that is read-only to prevent
  accidental dashboard corruption. As folder permissions are now just coming online, alternatively
  you could put dashboards in read-only folders if that's enabled in your tenant.

- **De-select before running.** This is a silly details that you'll figure out after you fail
  a couple of times, but it's common to leave some text selected when running your query.
  If you do this, Benchling will attempt to run only the selected SQL. Since a selection is rarely
  a valid full SQL statement, you'll get an error. Sometimes, you might stare perplexed trying to
  debug perfectly valid SQL because what's being run is the selection, not your entire SQL script. 
  