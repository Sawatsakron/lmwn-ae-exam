{{config(materialized='view')}}

select
    driver_id  as DriverID,
    join_date as JoinDate,
    vehicle_type as VehicleType,
    region as Region,
    active_status as Status,
    driver_rating as Rating,
    bonus_tier as BonusTier
from drivers_master







