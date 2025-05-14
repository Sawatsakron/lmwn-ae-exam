{{config(materialized='view')}}

select 
    order_id as OrderID,
    customer_id as CustomerID,
    restaurant_id as RestaurantID,
    driver_id as DriverID,
    order_datetime as OrderDatetime,
    pickup_datetime as PickupDatetime,
    delivery_datetime as DeliveryDatetime,
    order_status as OrderStatus,
    delivery_zone as DeliveryZone,
    total_amount as TotalAmount,
    payment_method as PaymentMethod,
    is_late_delivery as IsLateDelivery,
    delivery_distance_km as DeliveryDistanceKM
from order_transactions