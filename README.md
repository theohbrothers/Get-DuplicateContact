# Get-DuplicateContact

A script to locate duplicate or non-duplicate contacts between two `.csv` contact lists.

It is not just restricted to contacts as the project name implies, but really can compare between any two `.csv` lists. In fact you can use `.json` and `.xml`, just change the `ConvertFrom-Csv` to `ConvertFromJson` and `ConvertFrom-Xml` respectively.

## Notes

Why not just use `Compare-Object`?
- Searches using hashtable keys should be faster than `Compare-Object`. When working with many thousands or millions of records, the difference will be significant
- Hashtables build a meta object which can be used to store metadata, e.g. object keys.
- `Compare-Object` is generally unintuitive at least to the author. `.SideIndicator` grouping is difficult to manage and debug.
