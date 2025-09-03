-- 1. total number of customers
select count(*) as total_customers
from customers;

-- 2. total number of sellers
select count(*) as total_sellers
from sellers;

-- 3. total number of orders
select count(*) as total_orders
from orders;

-- 4. orders per customer (top 10)
select customer_id, count(order_id) as total_orders
from orders
group by customer_id
order by total_orders desc
limit 10;

-- 5. average order value
select round(avg(payment_value),2) as avg_order_value
from payments;

-- 6. top 10 most sold products
select product_id, count(order_item_id) as total_sold
from order_items
group by product_id
order by total_sold desc
limit 10;

-- 7. revenue per seller (top 10)
select seller_id, sum(price) as total_revenue
from order_items
group by seller_id
order by total_revenue desc
limit 10;

-- 8. payment type distribution
select payment_type, count(*) as total_payments
from payments
group by payment_type
order by total_payments desc;

-- 9. number of orders by status
select order_status, count(*) as total
from orders
group by order_status
order by total desc;

-- 10. monthly order trend
select date_format(order_purchase_timestamp, '%Y-%m') as month,
       count(*) as total_orders
from orders
group by month
order by month;

-- 11. average delivery time in days
select round(avg(datediff(order_delivered_customer_date, order_purchase_timestamp)),2) as avg_delivery_days
from orders
where order_delivered_customer_date is not null;

-- 12. customers with most cancellations
select customer_id, count(*) as cancellations
from orders
where order_status = 'canceled'
group by customer_id
order by cancellations desc
limit 10;

-- 13. sellers with fastest average delivery
select seller_id,
       round(avg(datediff(order_delivered_customer_date, order_approved_at)),2) as avg_delivery_days
from orders o
join order_items oi on o.order_id = oi.order_id
where order_delivered_customer_date is not null
group by seller_id
order by avg_delivery_days
limit 10;

-- 14. top 5 states with most customers
select substring_index(customer_zip_code_prefix, '-', 1) as state,
       count(*) as total_customers
from customers
group by state
order by total_customers desc
limit 5;

-- 15. top 10 revenue generating products
select product_id, sum(price) as revenue
from order_items
group by product_id
order by revenue desc
limit 10;

-- 16. orders with multiple payments
select order_id, count(*) as payment_count
from payments
group by order_id
having payment_count > 1
order by payment_count desc;

-- 17. highest value single order
select order_id, sum(payment_value) as order_value
from payments
group by order_id
order by order_value desc
limit 1;

-- 18. number of unique customers per year
select year(order_purchase_timestamp) as year, count(distinct customer_id) as unique_customers
from orders
group by year
order by year;

-- 19. top 5 cities by order count
select substring_index(customer_zip_code_prefix, '-', 1) as city,
       count(*) as order_count
from customers c
join orders o on c.customer_id = o.customer_id
group by city
order by order_count desc
limit 5;

-- 20. repeat customers (placed more than 1 order)
select customer_id, count(order_id) as total_orders
from orders
group by customer_id
having total_orders > 1
order by total_orders desc
limit 10;
