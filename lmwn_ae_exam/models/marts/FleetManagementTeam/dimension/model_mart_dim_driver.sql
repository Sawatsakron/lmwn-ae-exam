{{ config(materialized = 'table', alias = 'model_mart_dim_driver') }}

select distinct
    dm.DriverID,
    dm.JoinDate,
    dm.VehicleType,
    dr.RegionID,
    dm.Status,
    dm.Rating,
    dm.BonusTier,
    current_timestamp as CreateDate,
    current_timestamp as UpdateDate,
    'Bombadelo Crocadilo' as CreateBy,
    'Bombadelo Crocadilo' as UpdatedBy
from {{ ref('model_stg_drivers_master') }} dm
left join {{ ref('model_mart_dim_region') }} dr
    on dm.Region = dr.RegionName