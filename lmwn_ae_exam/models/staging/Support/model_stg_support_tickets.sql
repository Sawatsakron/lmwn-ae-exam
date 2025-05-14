{{config(materialized='view')}}

select
    ticket_id as TicketID,
    order_id as OrderID,
    customer_id as CustomerID,
    driver_id as DriverID,
    restaurant_id as RestaurantID,
    issue_type as IssueType,
    issue_sub_type as IssueSubType,
    channel as Channel,
    opened_datetime as OpenedDatetime,
    resolved_datetime as ResolvedDatetime,
    status as Status,
    csat_score as CSAT ,
    compensation_amount as CompensationAmount,
    resolved_by_agent_id as ResolvedBy
from support_tickets