This directory contains files related to creating and populating a custom Unit entity as a custom data type.

See the documentation in top of [Unit.yaml](./Unit.yaml).

More importantly, see the Medium post that provides the full documentation on this
topic at [TODO](https://medium.com/p/8ce76bfab5e6)

- [Unit.yaml](./Unit.yaml) - Specification for the Unit entity scheme and embeds the SQL to populate it
- [units.sql](./units.sql) - The SQL from the above YAML file, but extracted into a separate SQL file
- [unit_entity_import.dat](./unit_entity_import.dat) - A file that can be directly imported via the Configuration
  Migration tool to create the Unit entity. As time passes, it's probably that Benchling will change the file format
  and this file will no longer work. If that happens, let me know and I can refresh it.
- [example_units.csv](./example_units.csv) - An example of the units exported by the SQL found in Unit.yaml.
  This is just a subset. Use the Unit Dictionary configuration menus to add/remove units before your own export.