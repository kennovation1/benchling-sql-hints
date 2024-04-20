/*
Simple pivot.

Use this pattern if you have a table that returns a single row that you want to pivot.
Often I use this for readability when the result is a single row (e.g., a single sample).

There are lots of ways to pivot data and this very simple version only works for a single row.
A key benefit of this method is that it does not require explicitly listing field names.
This version does not require crosstab (from the tablefunc) extension.

Explanation:
"some_cte" is my table (in this case a CTE) from which I take just the first row.
Your version of "some_cte" should only return a single row or at least ensure that
the row you want to pivot is the first row (using ORDER BY).
The example shows a fictitious case just to give you a way of testing the query.

row_to_json converts the row into a JSON object.
json_each_text converts that JSON object to look like a table with a key column
and a value colume for each key/value pair in the JSON.

Note that it appears that the tablefunc extension that contains crosstab is loaded
in the Benchling Warehouse. However, given the requirement to for this query
to be independent of actual column names, I don't think it helps at all.
*/
WITH some_cte AS (
    SELECT * FROM entry limit 1
)

SELECT key AS "Name", value AS "Value"
FROM json_each_text((
    SELECT row_to_json(t)
    FROM (
        SELECT *
        FROM some_cte
        LIMIT 1
    ) AS t
))