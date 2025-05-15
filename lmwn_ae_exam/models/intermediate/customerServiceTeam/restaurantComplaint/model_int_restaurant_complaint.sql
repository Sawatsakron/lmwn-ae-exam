{{ config(materialized = 'ephemeral') }}

with restaurant_complaints as (
    select
        fco.RestaurantID,
        count(distinct fcs.TicketID) as TotalComplaints,
        avg(extract(epoch from (fcs.ResolvedDatetime - fcs.OpenedDatetime))) filter (where fcs.Status = 'resolved') as AvgResolutionTimeSeconds,
        count(distinct fcs.TicketID) filter (where fcs.IssueSubType = 'wrong_item') as WrongItem,
        count(distinct fcs.TicketID) filter (where fcs.IssueSubType = 'cold') as Cold,
        sum(fcs.CompensationAmount) as TotalCompensation,
    from {{ ref('model_mart_fact_customer_support') }} fcs
    inner join {{ ref('model_mart_fact_complaint_orders') }} fco
        on fcs.OrderID = fco.OrderID
    where fcs.IssueType = 'food'
    group by fco.RestaurantID
),

restaurant_order_counts as (
    select
        RestaurantID,
        count(distinct OrderID) as TotalOrders
    from {{ ref('model_mart_fact_complaint_orders') }}
    group by RestaurantID
)

select 
    rc.RestaurantID,
    r.RestaurantName,
    rc.TotalComplaints,
    rc.WrongItem,
    rc.Cold,
    concat(
        floor(rc.AvgResolutionTimeSeconds/3600)::int::text, 
        ':', 
        lpad(floor((rc.AvgResolutionTimeSeconds % 3600) / 60)::text, 2, '0')
    ) as AvgResolutionTime,
    rc.TotalCompensation,
    roc.TotalOrders,
    rc.TotalComplaints / roc.TotalOrders as ComplaintToOrderRatio,
    r.AverageRating
from restaurant_complaints rc
left join restaurant_order_counts roc on rc.RestaurantID = roc.RestaurantID
left join {{ ref('model_mart_dim_restauant') }} r on rc.RestaurantID = r.RestaurantID
