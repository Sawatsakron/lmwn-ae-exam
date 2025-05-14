{{ config(materialized = 'ephemeral') }}

with driver_performance as (
    select 
        fof.DriverID,
        dd.VehicleType,
        count(fof.OrderStatus) as TaskAssigned,
        count(fof.*) filter (where fof.OrderStatus = 'completed') as CompletedDeliveries,
        avg(extract(epoch FROM (fof.DeliveryDatetime - fof.PickupDatetime) / 60)) filter ( where fof.OrderStatus = 'completed' ) as AvgMinDeliveryTime,
        count(fof.*) filter (where fof.IsLateDelivery = True) as LateDelivery,
        count(fcd.*) filter (where fcd.IssueSubType = 'rude') as RudeComplaint,
        count(fcd.*) filter (where fcd.IssueSubType = 'no_mask') as NoMaskComplaint
    from {{ ref('model_mart_fact_orders_fleet') }} fof
    left join {{ ref('model_mart_dim_driver') }} dd 
        on fof.DriverID = dd.DriverID
    left join {{ ref('model_mart_fact_complaint_driver') }} fcd
        on dd.DriverID = fcd.DriverID
    group by fof.DriverID, dd.VehicleType
)

select 
    DriverID,
    VehicleType,
    TaskAssigned,
    CompletedDeliveries,
    round(AvgMinDeliveryTime,2) as AvgMinDeliveryTime,
    LateDelivery,
    RudeComplaint,
    NoMaskComplaint,
from driver_performance