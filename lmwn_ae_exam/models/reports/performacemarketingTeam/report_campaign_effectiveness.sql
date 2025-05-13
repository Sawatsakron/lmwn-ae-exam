{{ config(materialized = 'table', alias = 'report_campaign_effectiveness') }}

select * 
from {{ ref('model_int_campaign_effectiveness') }}
order by CampaignID