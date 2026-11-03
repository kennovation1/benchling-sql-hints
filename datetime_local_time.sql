/*
Show a Benchling Datetime field in the right time zone.

Benchling stores Datetime fields in the Warehouse in UTC, in a column type that
carries no time zone of its own. So a value of 17:53 means 17:53 UTC, but
nothing in the column says so.

What you need depends on the tool that shows the result:

- Benchling Insights displays Datetimes in the viewer's browser time zone and
  shows the UTC offset. It handles the conversion, so you usually don't need to.
- Other SQL tools vary. Some convert to your local zone; some show the raw UTC
  value with no hint that it is UTC.

Option 1: mark it as UTC and let the tool convert it.
  my_datetime at time zone 'UTC'
returns a value that carries its zone (timestamptz). A tool that understands
this shows it in the viewer's zone. Some tools show it in the database
session's zone instead. On the Warehouse that is UTC, so you'd see +00. Good
when viewers are spread across zones, or when the tool handles zones well.

Option 2: convert to a specific site's local time.
  (my_datetime at time zone 'UTC') at time zone 'America/Denver'
returns plain local clock time for that site, whatever the viewer's zone. Good
when the time means "what the clock on the bench said", e.g. comparing against
a paper record.

The tempting one-step version, my_datetime at time zone 'America/Denver', is
wrong. It treats 17:53 as Denver time and converts it to UTC, which moves the
clock in the wrong direction.

Use a zone name such as 'America/Denver' rather than a fixed offset, so daylight
saving time is handled for you.
*/
select
        my_datetime as stored_utc,
        my_datetime at time zone 'UTC' as utc_marked,                             -- option 1
        (my_datetime at time zone 'UTC') at time zone 'America/Denver' as site_local -- option 2
from
        registry_name.my_result_schema
