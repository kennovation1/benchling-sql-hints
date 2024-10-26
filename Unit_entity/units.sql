SELECT
    unit.name AS "New registry ID",
    CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM bnch$unit$raw AS subunit 
            WHERE LOWER(subunit.symbol) = LOWER(unit.symbol) 
                AND subunit.symbol <> unit.symbol
        ) 
        AND unit.symbol ~ '^[A-Z]' THEN 
            unit.symbol || '.'  -- Add a trailing period if it starts with a capital letter
        ELSE 
            unit.symbol
    END AS "New entity name",
    unit.name AS "Entity name",
    unit.name AS "Name",
    unit.symbol AS "Symbol",
    STRING_AGG(als.value, ', ') AS "Additional alias",
    unit.conversion_factor AS "Conversion factor",
    utype.name AS "Type",
    baseunit.name AS "Base unit"
FROM bnch$unit$raw unit
JOIN bnch$unit_type$raw utype ON utype.id = unit.unit_type_id
JOIN bnch$unit$raw baseunit ON baseunit.id = utype.base_unit_id
LEFT JOIN LATERAL jsonb_array_elements_text(unit.aliases) AS als ON true
WHERE unit.archived$ = false
GROUP BY
    unit.name,
    unit.symbol,
    unit.conversion_factor,
    utype.name,
    baseunit.name;