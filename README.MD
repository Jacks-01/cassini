# The Cassini Mission Plan

Im importing the cassini mission plan into Postgres into the `cassini` schema, setting everything as `text` so I can evaqluate the data and query it easily.

## Problems

- There are 2 different dates. One is an unusual UTC timestamp, the other is a more common date format.

- The "date" column contains 8 rows of an invalid date: "29-Feb-14", which is an invalid leap year. This also exists in the CSV and is not the result of the import process. **Ignoring this field**.

## Isolation and Transformation for Flybys

I created the `enceladus/transform.sql` script to pull the Enceladus mission plan data from the `csvs.mater_plan` data. I added the following types and constraints:

- created an `enceladus` schema and a `plans` table
- set `start_time_utc` to a `timestamp` and renamed it `start`
- set `title` to `not null` and only pulled in the plan data with non null titles
