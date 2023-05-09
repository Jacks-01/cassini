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

The transform stuff worked but it turned out that the dates that are in the master_plan CSV don't seem to align with what's been punlished on the NASA website. The master_plan CSV is from JPL, the flyby dates are from NASA so... I think I'm going to trust NASA.

To that end, I created a `flybys.sql` file with hard coded dates and checked 3 times for accuracy.