/*
This example shows one way of created a folder path when you don't know the depth of in the hierarchy.
Potentially this could be implemented with a recursive CTE, but it doesn't actually save any lines
of code and is harder for a broad audience to understand.

You can adjust this to account for more deeply nested tree if necessary.
This version shows upto a depth of 7.
*/

select
    e.name "Entry name",
    e.display_id "Experiment ID",
    case
        when f7.name is not null then
            f7.name || ' / ' || f6.name || ' / ' || f5.name || ' / ' || f4.name || ' / ' || f3.name || ' / ' ||  f2.name || ' / ' || f1.name
        when f6.name is not null then
            f6.name || ' / ' || f5.name || ' / ' || f4.name || ' / ' || f3.name || ' / ' ||  f2.name || ' / ' || f1.name
        when f5.name is not null then
            f5.name || ' / ' || f4.name || ' / ' || f3.name || ' / ' ||  f2.name || ' / ' || f1.name
        when f4.name is not null then
            f4.name || ' / ' || f3.name || ' / ' ||  f2.name || ' / ' || f1.name
        when f3.name is not null then
            f3.name || ' / ' ||  f2.name || ' / ' || f1.name
        when f2.name is not null then
            f2.name || ' / ' || f1.name
        when f1.name is not null then
            f1.name
        else
            'No path found'
    end as "Folder path"

from entry e
left join folder$raw f1 on f1.id = e.folder_id
left join folder$raw f2 on f2.id = f1.parent_folder_id
left join folder$raw f3 on f3.id = f2.parent_folder_id
left join folder$raw f4 on f4.id = f3.parent_folder_id
left join folder$raw f5 on f5.id = f4.parent_folder_id
left join folder$raw f6 on f6.id = f5.parent_folder_id
left join folder$raw f7 on f7.id = f6.parent_folder_id
