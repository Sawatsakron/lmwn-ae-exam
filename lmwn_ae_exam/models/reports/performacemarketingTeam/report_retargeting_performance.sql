{{ config(materialized = 'table', alias = 'report_retargeting_performance') }}

select *
from {{ ref('model_int_retargeting_performance') }}
order by CampaignType, TargetingStrategy, CampaignID