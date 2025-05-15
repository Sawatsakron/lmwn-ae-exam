{{ config(materialized = 'table', alias = 'model_mart_fact_complaint_orders') }}

select 
    OrderID,
    DriverID,
    RestaurantID,
    OrderStatus,
    Islatedelivery,
    CURRENT_TIMESTAMP     AS CreateDate,
    CURRENT_TIMESTAMP     AS UpdateDate,
    'Bombadelo Crocadilo' AS CreateBy,
    'Bombadelo Crocadilo' AS UpdatedBy
from {{ ref('model_stg_order_transactions') }} 