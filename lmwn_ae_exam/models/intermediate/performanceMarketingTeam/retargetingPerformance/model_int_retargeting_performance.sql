{{ config(materialized = 'ephemeral') }}

with retarget_active_user as (
    select 
        fc.CampaignID,
        dca.Type as CampaignType,
        dca.TargetingStrategy,
        count(distinct dcu.CustomerID) filter (
            where dca.Type = 'retargeting' 
              and dcu.Status = 'inactive'
        ) as ActiveRetargetedCustomers
    from {{ ref('model_mart_fact_campaign') }} fc
    left join {{ ref('model_mart_dim_campaign') }} dca 
        on fc.CampaignID = dca.CampaignID
    left join {{ ref('model_mart_dim_customer') }} dcu 
        on fc.CustomerID = dcu.CustomerID
    where dca.Type = 'retargeting' 
    group by fc.CampaignID, dca.Type, dca.TargetingStrategy
),

first_order as (
    select 
        fc.CampaignID,
        fo.CustomerID,
        min(fo.OrderDatetime) as FirstOrderDatetime
    from {{ ref('model_mart_fact_campaign') }} fc
    join {{ ref('model_mart_fact_orders_campaign') }} fo
        on fc.OrderID = fo.OrderID
    where fo.OrderStatus = 'completed'
      and fo.OrderDatetime > fc.InteractionDatetime
    group by fc.CampaignID, fo.CustomerID
),

returned_and_purchase as (
    select 
        fc.CampaignID,
        dca.Type as CampaignType,
        dca.TargetingStrategy,
        count(distinct fo.CustomerID) filter (
            where dca.Type = 'retargeting' 
              and dcu.Status = 'inactive'
              and fo.OrderDatetime > first.FirstOrderDatetime
              and datediff('day', first.FirstOrderDatetime, fo.OrderDatetime) <= 7
        ) as ReturningCustomers,
        round(sum(fo.TotalAmount), 2) as TotalSpend,
        round(avg(datediff('day', first.FirstOrderDatetime, fo.OrderDatetime)), 2) as AvgDaysToReturn
    from {{ ref('model_mart_fact_campaign') }} fc
    join {{ ref('model_mart_dim_campaign') }} dca 
        on fc.CampaignID = dca.CampaignID
    join {{ ref('model_mart_dim_customer') }} dcu 
        on fc.CustomerID = dcu.CustomerID
    join {{ ref('model_mart_fact_orders_campaign') }} fo
        on fc.CustomerID = fo.CustomerID
    left join first_order first
        on fo.CustomerID = first.CustomerID 
        and fc.CampaignID = first.CampaignID
    where dca.Type = 'retargeting'
    group by fc.CampaignID, dca.Type, dca.TargetingStrategy
),

retention_behavior as (
    select 
        fc.CampaignID,
        dca.Type as CampaignType,
        dca.TargetingStrategy,
        count(distinct fo.CustomerID) as RetainedCustomers,
        count(distinct case when datediff('day', first.FirstOrderDatetime, fo.OrderDatetime) > 30 then fo.CustomerID end) as LongTermCustomers --asuming the I want to see users who return again within 30s days
    from {{ ref('model_mart_fact_campaign') }} fc
    join {{ ref('model_mart_dim_campaign') }} dca 
        on fc.CampaignID = dca.CampaignID
    join {{ ref('model_mart_fact_orders_campaign') }} fo 
        on fc.CustomerID = fo.CustomerID
    left join first_order first 
        on fo.CustomerID = first.CustomerID
        and fc.CampaignID = first.CampaignID
    where dca.Type = 'retargeting'
    group by fc.CampaignID, dca.Type, dca.TargetingStrategy
)

select 
    rau.CampaignID,
    dca.CampaignName,
    rau.CampaignType,
    rau.TargetingStrategy,
    rau.ActiveRetargetedCustomers,
    round(rap.ReturningCustomers, 2) as ReturnUserCount,
    round(rap.TotalSpend, 2) as TotalSpend,
    round(rap.AvgDaysToReturn, 2) as AvgDaysToReturn,
    round((rap.ReturningCustomers * 1.0 / nullif(rau.ActiveRetargetedCustomers, 0)), 2) as ReturnRate,
    round(rap.TotalSpend / nullif(rau.ActiveRetargetedCustomers, 0), 2) as AvgSpendPerCustomer,
    round(rb.LongTermCustomers / nullif(rau.ActiveRetargetedCustomers, 0), 2) as RetentionRate,
    round(rap.ReturningCustomers / nullif(rau.ActiveRetargetedCustomers, 0), 2) as ReturnUserPercentage,
    round(rap.TotalSpend / nullif(rap.ReturningCustomers, 0), 2) as AvgReturningCustomerSpend,
    round(rap.TotalSpend / nullif(rau.ActiveRetargetedCustomers, 0), 2) as AvgCampaignSpend
from retarget_active_user rau
join {{ ref('model_mart_dim_campaign') }} dca 
    on rau.CampaignID = dca.CampaignID
left join returned_and_purchase rap 
    on rau.CampaignID = rap.CampaignID 
    and rau.CampaignType = rap.CampaignType
    and rau.TargetingStrategy = rap.TargetingStrategy
left join retention_behavior rb
    on rau.CampaignID = rb.CampaignID 
    and rau.CampaignType = rb.CampaignType
    and rau.TargetingStrategy = rb.TargetingStrategy