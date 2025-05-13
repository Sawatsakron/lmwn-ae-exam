{{ config(materialized = 'table',alias = 'model_mart_dim_campaign') }}

select
    CampaignID,
    CampaignName,
    Type,
    Objective,
    Channel,
    Budget,
    CostModel,
    TargetingStrategy,
    StartDate,
    EndDate,
    IsActive,
    CURRENT_TIMESTAMP     AS CreateDate,
    CURRENT_TIMESTAMP     AS UpdateDate,
    'Bombadelo Crocadilo' AS CreateBy,
    'Bombadelo Crocadilo' AS UpdatedBy
from {{ ref('model_stg_campaign_master') }}