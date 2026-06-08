create database mydatabase;
use mydatabase;

select * from mytable;

-- 1. What is the total revenue generate by male vs female customers?
select gender , sum(purchase_amount)
from mytable
group by gender;

-- 2. which customer used a discount but still spent more than an average purchase amount?
select customer_id , purchase_amount
from mytable
where purchase_amount > (select avg(purchase_amount) from mytable)
and discount_applied = 'Yes';


-- 3. Which are the top 5 products with average review rating?
select item_purchased, round(avg(review_rating)) as avg_rating
from mytable
group by item_purchased
order by avg(review_rating) desc
limit 5;

-- 4. Compare the average purchase amounts between Standard and Express Shipping.
select shipping_type, avg(purchase_amount)
from mytable
where shipping_type in ('Standard' ,'Express')
group by shipping_type;

-- 5. do subscribed customers spend more? Compare average spent and total revenue between
-- subscribers and non- subscribers.
select count(customer_id) as total_customers, subscription_status, 
avg(purchase_amount) as avg_spend, sum(purchase_amount) as total_spend
from mytable
group by subscription_status
order by avg(purchase_amount), sum(purchase_amount) desc;

-- 6. Which 5 products have high purchase percentage with discount coupon applied
select item_purchased ,
round(sum(case when discount_applied = 'Yes' then 1 else 0 end)/count(*) * 100,2) as discount_rate
from mytable
group by item_purchased
order by discount_rate desc
limit 5;


-- 7. Segment customers into new, returning and loyal based on their total previous purchases
-- and show the count of each segment
with customer_type as (
select customer_id, previous_purchases,
case 
when previous_purchases = 1 then 'New'
when previous_purchases between 2 and 10 then 'Returning'
else 'Loyal'
end as customer_segment
from mytable
)

SELECT customer_segment, count(*) as 'Number of customers'
FROM customer_type
group by customer_segment;

-- 8. What are the top 3 purchased products within each category
with item_counts as (
select category, item_purchased,
count(customer_id) as total_orders,
row_number() over (partition by category order by count(customer_id) desc) as item_rank
from mytable
group by category, item_purchased
)

select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <= 3;


-- 9. Are customers who are repeat buyers (with more than 5 previous purchases) also likely to subscribe?
select subscription_status,
count(customer_id) as repeat_buyers
from mytable
where previous_purchases > 5
group by subscription_status;

-- 10. What is the revenue contribution of each age group?
select age_group,
sum(purchase_amount) as total_revenue
from mytable
group by age_group
order by total_revenue desc;


