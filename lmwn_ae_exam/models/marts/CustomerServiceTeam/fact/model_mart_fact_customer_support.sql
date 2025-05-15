{{ config(materialized = 'table', alias = 'model_mart_fact_customer_support') }}

select
    TicketID,
    OrderID,
    IssueType,
    IssueSubType,
    Channel,
    OpenedDatetime,
    ResolvedDatetime,
    Status,
    CSAT ,
    CompensationAmount,
    ResolvedBy,
    CURRENT_TIMESTAMP     AS CreateDate,
    CURRENT_TIMESTAMP     AS UpdateDate,
    'Bombadelo Crocadilo' AS CreateBy,
    'Bombadelo Crocadilo' AS UpdatedBy
from {{ref('model_stg_support_tickets')}}
