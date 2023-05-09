drop schema if exists csvs cascade;

create schema csvs;

create table
  csvs.master_plan (
    start_time_utc text,
    duration text,
    date text,
    team text,
    spass_type text,
    target text,
    request_name text,
    library_definition text,
    title text,
    description text
  );

copy csvs.master_plan
from
  '/Users/jack/cassini/csvs/master_plan.csv' delimiter ',' header csv;