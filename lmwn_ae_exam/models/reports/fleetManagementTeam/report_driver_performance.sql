{{ config(materialized = 'table', alias = 'report_driver_performance') }}

select *
from {{ ref('model_int_driver_performance') }}