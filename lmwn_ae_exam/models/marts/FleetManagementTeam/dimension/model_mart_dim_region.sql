{{ config(materialized = 'table', alias = 'model_mart_dim_region') }}

select distinct
    case 
        when Region = 'central' then 1
        when Region = 'north' then 2
        when Region = 'south' then 3
        when Region = 'east' then 4
        when Region = 'metro' then 5
        else 0
    end as RegionID,
    Region as RegionName,
    current_timestamp as CreateDate,
    current_timestamp as UpdateDate,
    'Bombadelo Crocadilo' as CreateBy,
    'Bombadelo Crocadilo' as UpdatedBy
from {{ ref('model_stg_intensive_driver') }}