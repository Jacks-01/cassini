drop schema if exists enceladus cascade;

create schema enceladus;

set
    search_path = 'enceladus';

create table teams(
    id serial primary key,
    name text not null
);

create table plans(
    id serial primary key,
    start timestamp not null,
    title text not null,
    team_id int not null references teams(id),
    description text
);

insert into
    teams(name)
select
    distinct team from csvs.master_plan;

insert into
    plans(start, title, team_id, description)
select
    start_time_utc :: timestamp,
    title,
    (
        select
            id
        from
            teams
        where
            name = csvs.master_plan.team
    ),
    description
from
    csvs.master_plan
where
    target = 'Enceladus'
    and title is not null;