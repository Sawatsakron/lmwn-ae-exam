{{ config(materialized = 'table', alias = 'report_amount_paid_incentive') }}

select *
from {{ ref('model_int_incentive_paid') }} 