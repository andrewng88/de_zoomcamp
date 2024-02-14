{{ config(materialized='view') }}

select
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(['dispatching_base_num', 'pickup_datetime']) }} as tripid,
    cast(dispatching_base_num as string) as vendorid,
    cast(PUlocationID as integer) as  pickup_locationid,
    cast(DOlocationID as integer) as dropoff_locationid,

    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropoff_datetime as timestamp) as dropoff_datetime,

    -- trip info
    SR_Flag,
from {{ source('staging','fhv_tripdata_np') }}
where dispatching_base_num is not null 

{% if var('is_test_run', default=false) %}

    limit 100

{% endif %}