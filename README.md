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
- **parameter_handling.sql** - Patterns for handling Insights dashboard parameters
- **well_position_display.sql** - Convert row/col indicies to A1-format
- **folder_path_construction.sql** - Construct a folder path
- **simple_pivot.sql** - Pivot a single row result


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

- **Use Git!** TODO. This section is to be written. In short, use Git since Insights has no
  versioning or protection against query loss or corruption.

- **Save often.** TODO. This section is to be written. In short, save often since no autosave.
  Remember that running the query is how it gets saved.

- **Use a restricted project.** TODO. This section is to be written. In short, put dashboards
  in projects that are READ for others so that they don't corrupt your dashboard accidentally.

- **De-select before running.** TODO. This ecdtion is to be written. In short, remeber to de-select
  any selected text in the query before running it.