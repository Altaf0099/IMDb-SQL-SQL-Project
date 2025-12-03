
create database day2project;

use day2project;

select * from customers;
select * from order_items;	
select * from partners;
select * from restaurants;


-- 1) Top 10. restaurants by total revenue.

select r.restaurant_id, r.name, sum(o.unit_price * o.quantity) as revenue
from restaurants r
join order_items o on r.restaurant_id = o.restaurant_id
group by r.restaurant_id, r.name
order by revenue desc
limit 10;

-- 2) Most loyal customers — customers with highest repeat orders.

select c.customer_id , c.name,  count(distinct o.order_id) as orders
from customers c 
join order_items o on c.customer_id = o.customer_id
group by c.customer_id, c.name
order by orders desc
limit 10;

-- 3) Delivery partners with fastest average delivery time.

SELECT p.partner_id, p.name, AVG(o.delivery_time_min) AS avg_delivery_min, COUNT(DISTINCT o.order_id) AS deliveries
FROM partners p
JOIN order_items o ON p.partner_id = o.partner_id
WHERE o.order_status = 'delivered'
GROUP BY p.partner_id, p.name
HAVING deliveries >= 10
ORDER BY avg_delivery_min ASC
LIMIT 15;


-- 4) Restaurants with the highest cancellation rate.

select r.restaurant_id, r.name, sum(case when o.order_status = "cancelled" then 1 else 0 end) * 1.0 / count(DISTINCT o.order_id) as cancel_rate, 
count(DISTINCT o.order_id) as total_orders
from order_items o 
join restaurants r on o.restaurant_id = r.restaurant_id
group by  r.restaurant_id, r.name
order by cancel_rate desc;

-- 5) Monthly order volume & revenue trend.

select month(order_date) , sum(unit_price * quantity) revenue,COUNT(DISTINCT order_id) AS orders
from order_items
group by month(order_date)
order by month(order_date);

-- 6) Peak ordering hours (time-based analysis).

select hour(order_time), count(DISTINCT order_id) as orders
from order_items
group by hour(order_time)
order by orders desc;
	
-- 7) Customers who ordered from more than 5 different restaurants.

select c.customer_id, c.name, count(distinct r.restaurant_id) as counts
from customers c
join order_items o on c.customer_id = o.customer_id
join restaurants r on r.restaurant_id = o.restaurant_id
group by c.customer_id, c.name
having count(distinct r.restaurant_id) > 5;

-- 8) Most popular cuisine by total orders.

select cuisine, sum(unit_price * quantity)  as revenue
from order_items
group by cuisine
order by revenue desc;

-- 9) Identify unhealthy orders — items with > 900 calories per order.

select order_id, SUM(calories * quantity) AS total_calories
from order_items
group by order_id
having total_calories > 900;

-- 10) Restaurants with the highest rating average.

select name, avg_rating
from restaurants
order by avg_rating desc;

-- 11) Delivery partners who delivered to more than 3 cities.

select p.partner_id, p.name, count(distinct r.city)
from partners p 
join order_items o on p.partner_id = o.partner_id
join restaurants r on o.restaurant_id = r.restaurant_id
group by p.partner_id, p.name
having count(distinct r.city) > 3;

-- 12) Customers who spent above the average monthly spend.

WITH monthly_spend AS (
  SELECT customer_id, DATE_FORMAT(order_date,'%Y-%m') AS ym, SUM(order_total) AS total_ord
  FROM order_items
  WHERE order_status NOT IN ('cancelled','returned')
  GROUP BY customer_id, ym
)
SELECT ms.customer_id, c.name, ms.ym AS month, ms.total_ord, ms.month_avg
FROM (
  SELECT customer_id, ym, total_ord,
         AVG(total_ord) OVER (PARTITION BY ym) AS month_avg
  FROM monthly_spend
) ms
JOIN customers c ON c.customer_id = ms.customer_id
WHERE ms.total_ord > ms.month_avg
ORDER BY ms.ym, ms.total_ord DESC;




