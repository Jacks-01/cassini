drop schema if exists enceladus cascade;

create schema enceladus;

set
    search_path = 'enceladus';

create table teams(id serial primary key, name text not null);

create table plans (
    id serial primary key,
    start timestamp not null,
    title text not null,
    team_id int not null references teams(id),
    description text
);

insert into
    teams(name)
select
    distinct team
from
    csvs.master_plan;

insert into
    plans (start, title, team_id, description)
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

drop schema if exists enceladus cascade;

create schema enceladus;

set
    search_path = 'enceladus';

create table inms(
    id bigserial primary key,
    created_at timestamp not null,
    date date not null generated always as (created_at :: date) stored,
    year int not null generated always as (date_part('year', created_at)) stored,
    flyby_id int references flybys(id),
    altitude numeric(9, 2) not null check(altitude > 0),
    source text not null check(source in('osi', 'csn', 'osnb', 'onst')),
    mass numeric(6, 3) not null check(
        mass >= 0.125
        and mass < 100
    ),
    high_sensitivity_count int not null check(high_sensitivity_count > 0),
    low_sensitivity_count int not null check(low_sensitivity_count > 0),
    imported_at timestampz not null default now ()
);

insert into
    inms(
        created_at,
        altitude,
        source,
        mass,
        high_sensitivity_count,
        low_sensitivity_count
    )
select
    sclk :: timestamp,
    alt_t :: numeric(9, 2),
    source,
    mass_per_charge :: numeric(6, 3),
    c1counts :: int,
    c2counts :: int
from
    csvs.inms
where
    target = 'ENCELADUS';