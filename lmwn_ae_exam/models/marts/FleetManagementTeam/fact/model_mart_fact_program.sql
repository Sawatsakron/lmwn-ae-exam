{{ config(materialized = 'table', alias = 'model_mart_fact_program') }}

select
    id.P_LogID,
    id.DriverID,
    id.IncentiveProgram,
    id.BonusAmount,
    id.AppliedDate,
    id.DeliveryTarget,
    id.ActualDeliveries,
    id.BonusQualified,
    dr.RegionID,
    current_timestamp as CreateDate,
    current_timestamp as UpdateDate,
    'Bombadelo Crocadilo' as CreateBy,
    'Bombadelo Crocadilo' as UpdatedBy  
from {{ ref('model_stg_intensive_driver') }} id
left join {{ ref('model_mart_dim_region') }} dr
    on id.Region = dr.RegionName
