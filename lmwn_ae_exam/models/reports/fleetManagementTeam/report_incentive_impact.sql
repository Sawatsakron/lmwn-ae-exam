{{ config(materialized = 'table', alias = 'report_incentive_impact') }}

select *
from {{ ref('model_int_incentive_impact') }}
