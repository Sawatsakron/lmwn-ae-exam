{{config(materialized='view')}}

select
    customer_id as CustomerID,
    customer_segment as CustomerSegment,
    gender as Gender,
    birth_year as BirthYear,
    referral_source as ReferralSource,
    preferred_device as PreferredDevice,
    signup_date as Signup,
    status as Status
from customers_master