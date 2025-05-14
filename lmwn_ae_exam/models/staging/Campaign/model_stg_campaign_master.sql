{{config(meteralize='view')}}

select 
    campaign_id AS CampaignID,
    campaign_name AS CampaignName,
    campaign_type AS Type,
    objective AS Objective,
    channel AS Channel,
    budget AS Budget,
    cost_model AS CostModel,
    targeting_strategy AS TargetingStrategy,
    start_date AS StartDate,
    end_date AS EndDate,
    is_active AS IsActive
from campaign_master