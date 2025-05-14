{{ config(materialized = 'table', alias = 'model_mart_fact_orders_fleet') }}

select
    ot.OrderID,
    ot.DriverID,
    ot.PickupDatetime,
    ot.DeliveryDatetime,
    ot.OrderStatus,
    dr.RegionID as DeliveryZone,
    ot.TotalAmount,
    ot.IsLateDelivery,
    ot.DeliveryDistanceKM,
    current_timestamp as CreateDate,
    current_timestamp as UpdateDate,
    'Bombadelo Crocadilo' as CreateBy,
    'Bombadelo Crocadilo' as UpdatedBy

from {{ ref('model_stg_order_transactions') }} ot
left join {{ ref('model_mart_dim_region') }} dr
    on ot.DeliveryZone = dr.RegionName