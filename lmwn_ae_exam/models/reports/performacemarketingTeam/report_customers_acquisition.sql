{{ config(materialized = 'table', alias = 'report_customer_acquisition') }}

select *
from {{ ref('model_int_customer_acquisition') }}
order by CampaignID