{{config(materialized='view')}}

select
    log_id as A_LogID,
    order_id as OrderID,
    status as Status,
    status_datetime as StatusDatetime,
    updated_by as UpdatedBy
from order_log_incentive_sessions_order_status_logs