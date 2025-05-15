{{ config(materialized = 'view', alias = 'model_stg_restaurant_master') }}

select
    restaurant_id as RestaurantID,
    name as RestaurantName,
    category as Category,
    city as City,
    average_rating as AverageRating,
    active_status as ActiveStatus,
    prep_time_min as PrepTimeMin
from restaurants_master
