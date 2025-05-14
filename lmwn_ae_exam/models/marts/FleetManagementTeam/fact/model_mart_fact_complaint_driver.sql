{{ config(materialized = 'table', alias = 'model_mart_fact_complaint_driver') }}

select 
    TicketID,
    OrderID,
    DriverID,
    IssueType,
    IssueSubType,
    OpenedDatetime,
    ResolvedDatetime,
    Status,
    current_timestamp as CreateDate,
    current_timestamp as UpdateDate,
    'Bombadelo Crocadilo' as CreateBy,
    'Bombadelo Crocadilo' as UpdatedBy 
from  {{ ref('model_stg_support_tickets') }}
where IssueType = 'rider'