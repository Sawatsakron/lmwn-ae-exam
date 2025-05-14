{{ config(materialized = 'ephemeral') }}

with amount_paid_driver as (
    select 
        fp.DriverID,
        round(sum(fp.BonusAmount),2) as TotalAmountPaid
    from {{ ref('model_mart_fact_program') }} fp
    group by fp.DriverID
)

select * 
from amount_paid_driver
