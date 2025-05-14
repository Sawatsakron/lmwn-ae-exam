{{ config(materialized = 'table', alias = 'model_mart_fact_driver_activity') }}

select 
    A_LogID,
    OrderID,   
    Status,
    StatusDatetime,
    current_timestamp as CreateDate,
    current_timestamp as UpdateDate,
    UpdatedBy as CreateBy,
    UpdatedBy
from {{ ref('model_stg_order_status') }}  