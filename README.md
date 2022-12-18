# Comparison of 2021 Census Travel To Work & 2019 Indices of Multiple Deprivation

## Source data

[Census Travel To Work](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/bulletins/traveltoworkenglandandwales/census2021)

[Indices Of Multiple Deprivation](https://www.gov.uk/government/statistics/english-indices-of-deprivation-2019)

Attribution:  Office for National Statistics licensed under the Open Government Licence v.3.0

## Process

Data were loaded in a Postgres database using the following database schema for travel to work data.

```
create table public.ttw_mode_lsoa_2021
(
    id          integer not null primary key,
    lsoa        varchar,
    metric_code varchar,
    metric_name varchar,
    value       integer
);
```

Travel to work mode 12 / Not in employment or aged 15 years and under was excluded before mode percentages were calculated.

```
select  
    ttw.lsoa as lsoa,  
    ttw.value as value,  
    round(100.0 * ttw.value::numeric / (  
        select sum(value)  
        from ttw_mode_lsoa_2021 i  
        where i.lsoa = ttw.lsoa  
        and ttw.metric_code != '12'  
    )::numeric, 3) as percent,  
    imd."IMD_Rank" as rank,  
    ttw.metric_code as mode_code  
into tmp  
from ttw_mode_lsoa_2021 ttw  
join imd_2019 imd on ttw.lsoa = imd.lsoa11cd  
where ttw.value is not null and ttw.metric_code != '12';
```

There may be LSOA areas that are not shared between the 2019 & 2021 data.

An R script is included to generate charts from the CSV files. 

Generated charts can be found in the images directory
