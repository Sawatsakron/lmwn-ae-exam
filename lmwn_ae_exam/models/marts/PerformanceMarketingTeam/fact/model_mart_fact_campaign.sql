{{ config(materialized = 'table', alias = 'model_mart_fact_campaign') }}

SELECT
    ci.InteractionID,
    ci.CampaignID,
    ci.OrderID,
    ci.CustomerID,
    ci.InteractionDatetime,
    ci.EventType,
    ci.Platform,
    ci.AdCost,
    ci.IsNewCustomer,
    ci.Revenue,
    CURRENT_TIMESTAMP     AS CreateDate,
    CURRENT_TIMESTAMP     AS UpdateDate,
    'Bombadelo Crocadilo' AS CreateBy,
    'Bombadelo Crocadilo' AS UpdatedBy

FROM {{ ref('model_stg_campaign_interactions') }} ci 
left join {{ref('model_stg_campaign_master')}} c
    ON ci.CampaignID = c.CampaignID
left join {{ref('model_stg_order_transactions')}} o
    ON ci.OrderID = o.OrderID
