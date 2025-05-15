{{ config(materialized = 'ephemeral') }}

with most_common_complaints as (
    select IssueType as MostCommonComplaint
        from {{ ref('model_mart_fact_customer_support') }} 
        group by IssueType
        having count(*) = (
            select max(c) from (
                select count(IssueType) as c from {{ ref('model_mart_fact_customer_support') }}  group by IssueType
            ) 
)

),
complaint_summery as (
    select
        count(*) as TotalComplaints,
        avg(extract(epoch from (ResolvedDatetime - OpenedDatetime))) filter (where Status = 'resolved') as AvgResolutionTimeSeconds,
        count(distinct TicketID) filter (where Status != 'resolved') as Unresolved,
        sum(CompensationAmount) as TotalCompensation
    from {{ ref('model_mart_fact_customer_support') }} 
)

select
    cs.TotalComplaints,
    mc.MostCommonComplaint,
    concat(
    floor(cs.AvgResolutionTimeSeconds/3600)::int::text, 
    ':', 
    lpad(floor((cs.AvgResolutionTimeSeconds % 3600) / 60)::text, 2, '0')
    ) as AvgResolutionTime,
    cs.Unresolved,
    cs.TotalCompensation,
from complaint_summery cs , most_common_complaints mc
