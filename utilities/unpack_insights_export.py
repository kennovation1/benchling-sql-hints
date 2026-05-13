'''
Utility script to unpack an Insights Dashboards export from Benchling
into a set of directories with files.

To get the export, submit a Benchling support request as follows:
"Please provide an Insights Dashboard export."

The result should be a csv file with at least the following columns:
Dashboard ID
Dashboard name
Dashboard URL
Block name
Query
Description

Note that you should NOT view this file in Excel since the SQL content
exceeds the limits of the amount of data that can be stored in a single cell.
More importantly, NEVER save in Excel.

This script will create a new directory to avoid any merge issues.
You can use find, grep -R, etc. as needed.
For example: grep -Ri plasmid insights_export_2024-04-23_13_50_22

Merging and diffs with the source version of dashboards is done
outside of this tool.

The structure of the output is as follows:
insights_export_YYYY-mm-dd_HH_MM_SS/
    dashboard_name1/ (special characters are replaced with double underscores)
        README.md
        block_name1.sql (special characters are replaced with double underscores)
        ...
        block_nameN.sql
    ...
    dashboard_nameN/

Each SQL file gets a header added like this:
/*
Dashboard name: full name without any character substitutions
Block name: full name without any character substitutions
Block description: the block description
Extracted from export: e.g., 2024-04-23 21:11 EDT
*/

README.md:
Markdown describing the dashboard (name, placeholders for project, description,
and parameters) and each block in CSV order, aligned with the repo README template.

'''
import csv
import string
import sys
from datetime import datetime, timezone
from pathlib import Path


def clean_file_name(fname: str) -> str:
    '''
    Replace characters that are unfriendly in a file name with a double underscore.

    Truncate if the name is too long.
    '''
    valid_chars = f"-_.() {string.ascii_letters}{string.digits}"
    fname = ''.join(c if c in valid_chars else '__' for c in fname.strip())
    if len(fname) > 250:
        print(f'Directory or file name too long and will be truncated. Original name:\n"{fname}"')
        fname = f'{fname[:240]}-TRUNCATED'
    return fname


def _block_readme_section(block: dict) -> str:
    '''One block entry for README.md (Blocks section).'''
    raw_name = block['Block name']
    sql_name = f'{clean_file_name(raw_name)}.sql'
    return f'''## {raw_name}

- Block name: {raw_name}
- Block description: {block['Description']}
- SQL file name: {sql_name}
- Chart type:
  - *Chart type parameters (for all chart types other than Table)*


'''


def _export_metadata_section(block: dict, extracted: str) -> str:
    return f'''# Export metadata (tenant-specific)

- Dashboard URL: {block['Dashboard URL']}
- Extracted from export: {extracted}
'''


def update_dashboard_readme(dash_dir: Path, block: dict) -> None:
    '''Write or append README.md for this dashboard. First row seeds Dashboard + first block.'''
    readme = dash_dir / Path('README.md')
    extracted = datetime.now(timezone.utc).astimezone().strftime('%Y-%m-%d %H:%M %Z')
    if not readme.exists():
        body = f'''# Dashboard
- Name: {block['Dashboard name']}
- Project:
- Description:
- Parameters: *One row for each parameter*
  - Name: some_name; Type: some_type; Multi-select: {{checked | unchecked}}

# Blocks
Specify blocks in reading order. That is, block1 is top left, block2 is top right, block3 is on left of next row, etc.

{_block_readme_section(block)}*Other notes as may be helpful*

{_export_metadata_section(block, extracted)}
'''
        readme.write_text(body)
    else:
        text = readme.read_text()
        marker = '\n*Other notes as may be helpful*\n\n'
        if marker not in text:
            readme.write_text(text + _block_readme_section(block))
            return
        before, after = text.split(marker, 1)
        readme.write_text(before + _block_readme_section(block) + marker + after)


def process_block(parent_dir: Path, block: dict) -> None:
    '''Save information about a single block in a dashboard and the dashboard itself.'''
    dash_name = clean_file_name(block['Dashboard name'])
    block_name = clean_file_name(block['Block name'])
    dash_dir = parent_dir / Path(dash_name)
    dash_dir.mkdir(exist_ok=True)
    sql_file = dash_dir / Path(f'{block_name}.sql')
    header = f'''/*
Dashboard name: {block['Dashboard name']}
Block name: {block['Block name']}
Block description: {block['Description']}
Extracted from export: {datetime.now(timezone.utc).astimezone().strftime('%Y-%m-%d %H:%M %Z')}
*/

'''
    sql_file.write_text(header + block['Query'])
    update_dashboard_readme(dash_dir, block)


def main() -> None:
    ''' Read export file and process each row.'''
    if len(sys.argv) != 2:
        print(f'usage: python {sys.argv[0]} <insights_dashboard_export_csv_file>')
        sys.exit(1)

    csv.field_size_limit(sys.maxsize)
        
    now = datetime.now()
    debug = False
    if debug:
        parent_dir = Path('insights_export_unittest')
        parent_dir.mkdir(exist_ok=True)
    else:
        parent_dir = Path(f"insights_export_{now.strftime('%Y-%m-%d_%H_%M_%S')}")
        parent_dir.mkdir()

    with open(sys.argv[1], newline='', encoding='utf-8-sig') as fp:
        reader = csv.DictReader(fp)
        for row in reader:
            process_block(parent_dir, row)


########
# MAIN #
########
main()