{{ config(materialized='table') }}

select 
    locationid, 
    borough, 
    zone, 
    replace(service_zone,'Boro','Green') as service_zone  --replace Boro with Green
from {{ ref('taxi_zone_lookup') }} --refer to seed file