{{ config(materialized = 'table', alias = 'report_complaint_summery') }}

select cs.*
from {{ ref('model_int_complaint_summery') }} cs
