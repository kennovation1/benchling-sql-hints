
/*
Example to show how to convert a well position from the row_index and column_index
format (0-based values) to the human readable A1 type format that scientists expect.

This is a plate example, but can be used for boxes too of course.

*/
select
	chr(ascii('A') + row_index) || (column_index + 1) as nopad,  -- No zero padding for the column
	chr(ascii('A') + row_index) || LPAD((column_index + 1) :: text, 2, '0') as padded -- Zero-pad the column number
from
	registry_name.container
where
	plate_id = 'plt_xxxxxxxx'
order by
	row_index,
	column_index