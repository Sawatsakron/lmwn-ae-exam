{{ config(materialized = 'ephemeral') }}

with first_interactions as (
    select 
        fc.CampaignID,
        fc.InteractionID,
        fc.OrderID,
        fc.Platform,
        dca.Channel,
        fc.IsNewCustomer
    from {{ ref('model_mart_fact_campaign') }} fc
    join {{ ref('model_mart_dim_campaign') }} dca on fc.CampaignID = dca.CampaignID
    where fc.IsNewCustomer = true
    group by fc.CampaignID, fc.InteractionID, fc.OrderID, fc.Platform, dca.Channel, fc.IsNewCustomer
),

customer_mapping as (
    select distinct
        fi.CampaignID,
        fo.CustomerID,
        fi.Platform,
        fi.Channel
    from first_interactions fi
    join {{ ref('model_mart_fact_orders') }} fo on fi.OrderID = fo.OrderID
),

purchase_behavior as (
    select
        cm.CustomerID,
        cm.CampaignID,
        count(fo.OrderID) as TotalOrders,
        count(fo.OrderID) - 1 as RepeatOrders,
        sum(fo.TotalAmount) as TotalSpend,
        avg(fo.TotalAmount) as AvgOrderValue
    from customer_mapping cm
    join {{ ref('model_mart_fact_orders') }} fo on cm.CustomerID = fo.CustomerID
    where fo.OrderStatus = 'completed'
    group by cm.CustomerID, cm.CampaignID
),

acquisition_costs as (
    select
        fc.CampaignID,
        sum(fc.AdCost) as TotalAcquisitionCost
    from {{ ref('model_mart_fact_campaign') }} fc
    where fc.IsNewCustomer = true
    group by fc.CampaignID
)

select
    cm.CampaignID,
    dca.CampaignName,
    cm.Channel,
    cm.Platform,
    count(distinct cm.CustomerID) as NewCustomersAcquired,
    ac.TotalAcquisitionCost,
    case 
        when count(distinct cm.CustomerID) = 0 then null
        else round(ac.TotalAcquisitionCost / count(distinct cm.CustomerID), 2)
    end as CostPerAcquisition,
    round(avg(pb.TotalOrders),2) as AvgOrdersPerCustomer,
    round(avg(pb.RepeatOrders),2) as AvgRepeatOrders,
    round(avg(pb.TotalSpend),2) as AvgCustomerSpend,
    round(avg(pb.AvgOrderValue),2) as AvgOrderValue
from customer_mapping cm
join {{ ref('model_mart_dim_campaign') }} dca on cm.CampaignID = dca.CampaignID
left join purchase_behavior pb on cm.CustomerID = pb.CustomerID and cm.CampaignID = pb.CampaignID
left join acquisition_costs ac on cm.CampaignID = ac.CampaignID
group by cm.CampaignID, dca.CampaignName, cm.Channel, cm.Platform, ac.TotalAcquisitionCost