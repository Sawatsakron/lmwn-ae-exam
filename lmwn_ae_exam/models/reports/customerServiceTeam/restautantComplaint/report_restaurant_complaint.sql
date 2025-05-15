{{ config(materialized = 'table', alias = 'report_restaurant_complaint') }}

select rc.*
from {{ ref('model_int_restaurant_complaint') }} rc
