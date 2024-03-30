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
- Add a section here or separate file for other hints such as developing outside of Insights, toggling the raw button, etc.
- Upload my parameter handling snippet

## Guide to snippets
- `registry_name` should be replaced by your registry name. 
  If you only have a single organization, then you can omit this.
  If you have more than one organization, it's important to specify
  which registry you are using since omitting it will give you a default and
  possibly the wrong schema (since the same tables may appear in different
  organizations schemas).
  
## Catalog of snippets
- parameter_handling.sql - Patterns for handling Insights dashboard parameters
- well_position_display.sql - Convert row/col indicies to A1-format