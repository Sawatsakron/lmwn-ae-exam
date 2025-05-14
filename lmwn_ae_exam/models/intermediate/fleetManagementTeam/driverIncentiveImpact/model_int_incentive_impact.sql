{{ config(materialized = 'ephemeral') }}

with incentive_impact as (
    select 
        fp.IncentiveProgram,
        count(fp.driverID) as DriverCount,
        sum(fp.ActualDeliveries) as CompletedDeliveries,
        sum(fp.DeliveryTarget)  as TargetDeliveries
    from {{ ref('model_mart_fact_program') }} fp
    group by fp.IncentiveProgram
)

select * 
from incentive_impact