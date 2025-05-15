{{ config(materialized = 'table', alias = 'report_driver_complaint') }}

select dc.* , dd.Rating
from {{ ref('model_int_driver_complaint') }} dc
left join {{ ref('model_mart_dim_driver') }} dd
    on dc.DriverID = dd.DriverID
order by dc.TotalComplaints desc