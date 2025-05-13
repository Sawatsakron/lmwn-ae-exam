{{ config(materialized = 'table', alias = 'model_mart_dim_customer') }}

select
    CustomerID,
    CustomerSegment,
    Gender,
    BirthYear,
    ReferralSource,
    PreferredDevice,
    Signup,
    Status,
    CURRENT_TIMESTAMP     AS CreateDate,
    CURRENT_TIMESTAMP     AS UpdateDate,
    'Bombadelo Crocadilo' AS CreateBy,
    'Bombadelo Crocadilo' AS UpdatedBy
from {{ ref('model_stg_customers_master') }}