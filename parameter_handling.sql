/*
In an Insights dashboard, it is common to use a dashboard parameter
as a filter value in a WHERE clause. This is can be done simply by
adding the parameter to there WHERE clause like so:

Assuming our parameter display name is called "Study":
where id = {{Study}}

However, if the parameter value is not set we'll get no rows returned.
Instead, we'd like all rows return in the scenario where a parameter is not set.

The following snippets show various use cases for handling empty parameter
values depending on the parameter type.

Additionally, there's an example for how to filter using multiple values in a filter.
*/


/*
Zero or one parameter value.

Use case: Find the specify study provided in the parameter or show all if
the parameter is not set.

Parameter name: Study
Allow multiple values checkbox: UNCHECKED
*/
select * from registry_name.study
where
	registry_name.study.id = {{Study}}
	or {{Study}} is null

-- Sometimes you may want to allow the user to search based on a partial text match
-- instead of a specific entity. In this case you could use a statement like this:
	registry_name.study.name$ ILIKE '%' || {{Study name}} || '%'
-- Note that the field is now the name$ field instead of the id field.
-- Recall that ILIKE is a case-insenstive match and the % symbol is the wildcard symbol.
-- The double pipes symbol (||) is string concatenation.


/*
Zero, one, or multiple parameter values. 
The WHERE clause will be true if any of the values in the parameter are matched.
Note that the empty list handling is different when "Allow multiple values" is
checked since an array is passed instead of a scaler.

Use case: Provide a list of studies in the parameter and return all rows containing
any of those studies that exist.

Parameter name: Study
Allow multiple values checkbox: CHECKED
*/
select * from registry_name.study
where
	registry_name.study.id = any({{Studies}})
	or {{Studies}} = '{}'
	

/*
This is an example where the parameter is array and the field is also an array.
This is not a common case, by I ran into it once and so have captured it here.

Use case: This came from an analytics request solution I created where a sample
could be provided and a multiple-select field would indicate what types of
analytics should be executed on the analyte.

In this excerpt, the "agg" table was created from a CTE (i.e., sub-squery using "with" clause).
Note the source system that I wrote this for changed, and I was therefore not
able to test that this works (it used to, but I could have broken something during
copy and pasting as this was just stashed away in a file as a notes for future reference).

I don't love the formatting, but wanted to use the space to make the example clear.

Parameter name: Study
Allow multiple values checkbox: CHECKED
*/
select * from registry_name.study
where
	(
		(
			array(
				select unnest({{Analysis types}})
				intersect
				select unnest(agg.analysis_types)
			) <> '{}'
		)
		or ({ { Analysis types } } = '{}')
	)