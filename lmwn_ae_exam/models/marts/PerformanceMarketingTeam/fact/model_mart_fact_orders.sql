{{ config(materialized = 'table', alias = 'model_mart_fact_orders') }}

SELECT
    ot.OrderID,
    ot.CustomerID,
    ot.OrderDatetime,
    ot.OrderStatus,
    ot.TotalAmount,
    ot.PaymentMethod,
    CURRENT_TIMESTAMP     AS CreateDate,
    CURRENT_TIMESTAMP     AS UpdateDate,
    'Bombadelo Crocadilo' AS CreateBy,
    'Bombadelo Crocadilo' AS UpdatedBy
FROM {{ ref('model_stg_order_transactions') }} ot
Left join {{ref("model_stg_customers_master")}} c
    ON ot.CustomerID = c.CustomerID