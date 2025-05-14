{{config(materialized='view')}}


select 
    log_id as P_LogID,
    driver_id as DriverID,
    incentive_program as IncentiveProgram,
    bonus_amount as BonusAmount,
    applied_date as AppliedDate,
    delivery_target as DeliveryTarget,
    actual_deliveries as ActualDeliveries,
    bonus_qualified as BonusQualified,
    region as Region
from order_log_incentive_sessions_driver_incentive_logs
