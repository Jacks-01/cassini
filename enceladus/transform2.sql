drop schema if exists enceladus cascade;
create schema enceladus;

set search_path='enceladus';
create table inms(
    id bigserial primary key,
    created_at timestamp not null,
    date date not null generated always as (created_at::date) stored,
    year int not null generated always as (date_part('year', created_at)) stored,
    flyby_id int references flybys(id),
    altitude numeric(9,2) not null check(altitude > 0),
    source text not null check(source in('osi', 'csn', 'osnb', 'onst')),
    mass numeric(6,3) not null check(mass >=0.125 and mass < 100),
    high_sensitivity_count int not null check(high_sensitivity_count > 0),
    low_sensitivity_count int not null check(low_sensitivity_count > 0),
    imported_at timestampz not null default now ()
);