insert into inms (
        created_at,
        altitude,
        source,
        mass,
        high_sensitivity_count,
        low_sensitivity_count
    )
select sclk::timestamp,
    alt_t::numeric(9, 2),
    source,
    mass_per_charge::numeric(6, 3),
    c1counts::int,
    c2counts::int
from csvs.inms
where target = 'ENCELADUS';