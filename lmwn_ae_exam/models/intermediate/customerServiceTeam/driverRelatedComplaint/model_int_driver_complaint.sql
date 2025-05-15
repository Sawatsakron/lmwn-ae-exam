{{ config(materialized = 'ephemeral') }}

with driver_complaints as (
    select
        fco.DriverID,
        count(distinct fcs.TicketID) as TotalComplaints,
        avg(extract(epoch from (fcs.ResolvedDatetime - fcs.OpenedDatetime))) filter (where fcs.Status = 'resolved') as AvgResolutionTimeSeconds,
        count(distinct fcs.TicketID) filter (where fcs.IssueSubType = 'rude') as Rude,
        count(distinct fcs.TicketID) filter (where fcs.IssueSubType = 'no_mask') as NoMask,
        round(avg(fcs.CSAT) filter (where Status = 'resolved'),2) as AvgCSATResolved
    from {{ ref('model_mart_fact_customer_support') }} fcs
    inner join {{ ref('model_mart_fact_complaint_orders') }} fco
        on fcs.OrderID = fco.OrderID
    where fcs.IssueType = 'rider'
    group by fco.DriverID
),

driver_order_counts as (
    select
        DriverID,
        count(distinct OrderID) as TotalOrders
    from {{ ref('model_mart_fact_complaint_orders') }}
    group by DriverID
)

select 
    dc.DriverID,
    dc.TotalComplaints,
    dc.Rude,
    dc.NoMask,
    concat(
        floor(dc.AvgResolutionTimeSeconds/3600)::int::text, 
        ':', 
        lpad(floor((dc.AvgResolutionTimeSeconds % 3600) / 60)::text, 2, '0')
    ) as AvgResolutionTime,
    dc.AvgCSATResolved,
    doc.TotalOrders,
    dc.TotalComplaints / doc.TotalOrders as ComplaintToOrderRatio
from driver_complaints dc
left join driver_order_counts doc on dc.DriverID = doc.DriverID