{{ config(materialized = 'table', alias = 'model_mart_dim_restauant') }}

select
    RestaurantID,
    RestaurantName,
    Category,
    City,
    AverageRating,
    ActiveStatus,
    CURRENT_TIMESTAMP     AS CreateDate,
    CURRENT_TIMESTAMP     AS UpdateDate,
    'Bombadelo Crocadilo' AS CreateBy,
    'Bombadelo Crocadilo' AS UpdatedBy
from {{ ref('model_stg_restaurant_master') }}

