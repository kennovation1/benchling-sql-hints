/*
An example that shows one way to create a recursive query to build a hierarchical storage
path from the location table. The location table shows a location and its parent.
This query builds the full path from the root down to the final container (a box in this example).
This is not a universal query, but is a good guide as a starting point to adapt for your specific
needs.

Note that this example can be adapted to similar hierarchical objects such as folder hierarchies.

An example output header and one row:
id, lid, Box name, Location name, Full storage path
box_O7OKYQ54, loc_WKFfpzDG, 9BOX789, Shelf C, Floor 2 -> Room 200 -> FRZR008 -> Shelf C -> 9BOX789

This was created by and originally posted by Matt (@mpduval) on the Benchling Community forum in this thread:
"Inventory search with multiple levels"
https://community.benchling.com/ask-the-community-6/inventory-search-with-multiple-levels-1124

This version has been lightly edited from the original for formatting and presentation of the final output.
Consider using ' / ' instead of ' -> '.
*/

-- Check out https://learnsql.com/blog/how-to-query-hierarchical-data/ for good detail
-- Replace all instances of REGISTRY with your correct company registry prefix
WITH
RECURSIVE locations_with_roots AS (
	--This top part is what to do with the ones that are at the top of the hierarchy
	SELECT 
		locations.id as lid,
		locations.name as lname,
		locations.location_id as lparentid,
		locations.name as lparentname,
		locations.name as storagepath
	FROM REGISTRY.location AS locations
	WHERE locations.location_id IS NULL
    /*
    Ada (@adawzhang) added: I modified WHERE locations.location_id IS NULL to
    WHERE locations.location_id = '{{location_id}}'
    in the base case to capture the location_id of the “top-most” parent (Freezer) that I wanted to search from.
    */

	UNION ALL

	--This section handles all children
	SELECT 
		lp.id,
		lp.name,
		lp.location_id,
		lwr.lparentname,
		--If you want to use a different seperator, swap the value in quotes here
		--If you also wanted to use IDs to split this later, you can. For visual, I like the names
		lwr.storagepath || ' -> ' || lp.name
	FROM REGISTRY.location AS lp, locations_with_roots AS lwr
	WHERE lp.location_id = lwr.lid
),

boxes as (
	select 
		*
	from REGISTRY.box
	inner join locations_with_roots
		on locations_with_roots.lid = box.location_id
)

select 
	id,          --ID of the box
	lid,         --ID of the location of the box is in
    name "Box name",
    lname "Location name",
	storagepath || ' -> ' || name AS "Full storage path"
from boxes
