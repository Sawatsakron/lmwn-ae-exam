{{ config(materialized = 'ephemeral') }}

with delivery_zone as (
    select
        dr.RegionName,
        count(fof.*) as TotalOrders,
        round(count(fof.*) filter (where fof.OrderStatus = 'completed') * 100/ count(*),2) as CompletedRate,
        avg(extract(epoch FROM (fof.DeliveryDatetime - fof.PickupDatetime) / 60)) filter ( where fof.OrderStatus = 'completed' ) as AvgMinDeliveryTime,
        round(count(fof.*) filter (where fof.OrderStatus = 'failed' or fof.OrderStatus = 'canceled') * 100 / count(*) ,2) as OrderFailedRate,
        round(count(fof.*)  /  count(distinct dd.DriverID),0) as RequestPerDriver
    from {{ ref('model_mart_fact_orders_fleet') }} fof
    left join {{ ref('model_mart_dim_region') }} dr
        on fof.DeliveryZone = dr.RegionID
    left join {{ ref('model_mart_dim_driver') }} dd
        on fof.DriverID = dd.DriverID
    group by dr.RegionName
)
select * from delivery_zone



