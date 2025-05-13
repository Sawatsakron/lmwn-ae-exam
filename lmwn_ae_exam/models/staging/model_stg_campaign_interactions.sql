
{{ config(materialized='view') }}

SELECT
    interaction_id       AS InteractionID,
    campaign_id          AS CampaignID,
    order_id             AS OrderID,
    customer_id          AS CustomerID,
    interaction_datetime AS InteractionDatetime,
    event_type           AS EventType,
    platform             AS Platform,
    device_type          AS DeviceType,
    ad_cost              AS AdCost,
    is_new_customer      AS IsNewCustomer,
    revenue              AS Revenue,
    session_id           AS SessionID  
FROM campaign_interactions
