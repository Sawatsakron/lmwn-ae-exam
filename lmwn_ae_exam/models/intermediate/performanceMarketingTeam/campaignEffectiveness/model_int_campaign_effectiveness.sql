{{ config(materialized = 'ephemeral') }}

with exposure as (
    select  
        fc.CampaignID, 
        count(*) filter (where fc.EventType = 'impression') as Exposure
    from {{ ref('model_mart_fact_campaign') }} fc
    group by fc.CampaignID
),

interactions as (
    select  
        fc.CampaignID, 
        count(*) filter (where fc.EventType = 'click') as Clicks,
        count(*) filter (where fc.EventType = 'conversion') as Conversions
    from {{ ref('model_mart_fact_campaign') }} fc
    group by fc.CampaignID
),

users_complete_purchase as (
    select 
        fc.CampaignID, 
        count(distinct fo.CustomerID) as CompletedPurchase
    from {{ ref('model_mart_fact_campaign') }} fc
    inner join {{ ref('model_mart_fact_orders_campaign') }} fo 
        on fc.OrderID = fo.OrderID
    where fc.EventType in ('click', 'conversion') 
        and fo.OrderStatus = 'completed'
    group by fc.CampaignID
),

campaign_cost_n_revenue as (
    select 
        fc.CampaignID, 
        round(sum(fc.AdCost), 2) as CampaignCost,
        round(sum(fc.Revenue), 2) as CampaignRevenue
    from {{ ref('model_mart_fact_campaign') }} fc
    group by fc.CampaignID
)

select 
    e.CampaignID, 
    e.Exposure,
    i.Clicks,
    i.Conversions,
    ucp.CompletedPurchase,
    cc.CampaignCost,
    cc.CampaignRevenue,
    case 
        when ucp.CompletedPurchase = 0 then null
        else round(cc.CampaignCost / ucp.CompletedPurchase, 2) 
    end as CPA,
    case 
        when cc.CampaignCost = 0 then null
        else round(cc.CampaignRevenue / cc.CampaignCost, 2)
    end as ROAS
from exposure e
left join interactions i on e.CampaignID = i.CampaignID
left join users_complete_purchase ucp on i.CampaignID = ucp.CampaignID
left join campaign_cost_n_revenue cc on e.CampaignID = cc.CampaignID