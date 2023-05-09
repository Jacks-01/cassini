drop schema if exists enceladus cascade;

create schema enceladus;

set
    search_path = 'enceladus';

create table inms(
    id serial primary key,
    created_at timestamp not null,
    date date not null generated always as (created_at :: date) stored,
    year int not null generated always as (date_part('year', created_at)) stored,
    flyby_id int references flybys(id),
    altitude numeric(9, 2) not null check(altitude > 0),
    source text not null check(source in('osi', 'csn', 'osnb', 'esm')),
    mass numeric(6, 3) not null check(
        mass >= 0.125
        and mass < 256
    ),
    high_sensitivity_count int not null check(high_sensitivity_count >= 0),
    low_sensitivity_count int not null check(low_sensitivity_count >= 0),
    imported_at timestamptz not null default now()
);

update
    inms
set
    flyby_id = flybys.id
from
    flybys
where
    flybys.date = inms.date;
