{{ config(materialized = 'table', alias = 'report_delivery_zone') }}

select *
from {{ ref('model_int_delivery_zone') }}

