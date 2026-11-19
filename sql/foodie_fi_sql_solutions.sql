with a as ( 
	select 
		p.plan_id as plan_id, 
		p.plan_name as plan_name,
		p.price as price,
		s.customer_id as customer_id,
		s.start_date as start_date
	from 
		plans p 
	join 
		subscriptions s
	on 
		p.plan_id = s.plan_id
),

annual_upgrade as (
	select
		b.customer_id customer_id,
        datediff(c.start_date, b.start_date) days_to_upgrade
    from 
		a b
	join
		a c
	on 
		b.customer_id = c.customer_id
	where 
		b.plan_id = 0 and c.plan_id = 3
)
-- Question-1
-- How many customers has Foodie-Fi ever had?
-- 1000 
select count(distinct a.customer_id) as no_of_customers
from a;

-- -- Question-2
-- What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value 
select monthname(a.start_date) as `month`,
		count(*) as no_of_customers
from a 
where a.plan_id = 0
group by month(a.start_date), 1
order by month(a.start_date), 1;
-- month 		no. of customers
-- January		88
-- February		68
-- March		94
-- April		81
-- May			88
-- June			79
-- July			89
-- August		88
-- September	87
-- October		79
-- November		75
-- December		84

-- -- Question-3
-- What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
select a.plan_name as plan,
		count(*) as cnt
from a
where year(a.start_date) > 2020
group by 1
order by 2 desc;
-- plan  			 cnt
-- churn			71
-- pro annual		63
-- pro monthly		60
-- basic monthly	8

-- -- Question-4
-- What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
select count(case when a.plan_id = 4 then a.customer_id end) as churn_customer_count,
		round((count(case when a.plan_id = 4 then a.customer_id end) / count(distinct a.customer_id) * 100),1) as churn_customer_percentage
from a;
-- count of churn customer = 307
-- percentage of churn customer = 30.7

-- -- Question-5
-- How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number? 
select 
	count(case when b.position = 2 and b.plan_name = 'churn' then customer_id end) as straight_churned,
	round(abs((count(case when b.position = 2 and b.plan_name = 'churn' then customer_id end) / count(distinct customer_id) * 100)),1) as straight_churned_percentage
from (select a.customer_id,
			a.plan_name,
            rank() over (partition by a.customer_id order by a.start_date asc) as position
	from a) b;
-- straight churn customers = 92
-- percentage of straight churn customers = 9.2%

-- -- Question-6
-- What is the number and percentage of customer plans after their initial free trial?
select b.plan_name,
		count(*) as cnt,
        round((count(*) / (select count(distinct a.customer_id) from a) * 100),2) as percentage
from (select a.customer_id,
			a.plan_name as plan_name,
            lag(a.plan_name) over (partition by a.customer_id order by a.start_date asc) as previous_plan
		from a) b
where b.previous_plan = 'trial'
group by 1
order by 2;
-- pro annual cnt= 37, percentage = 3.7%
-- churn cnt = 92, percentage = 9.20
-- pro monthly	cnt = 325, percentage = 32.50
-- basic monthly cnt =546, percentage = 54.60

-- -- Question-7
-- What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
select b.plan,
		count(*) as cnt,
        round((count(*) / (select count(distinct a.customer_id) from a) * 100),2) as percentage
from (select  a.customer_id,
		a.plan_name as plan,
		ROW_NUMBER() over (partition by customer_id order by a.start_date desc) as rn
	from a 
	where a.start_date <= '2020-12-31') b
where b.rn = 1
group by 1
order by 2;
-- plan			cnt		percentage
-- trial			19		1.90
-- pro annual		195		19.50
-- basic monthly	224		22.40
-- churn			236		23.60
-- pro monthly		326		32.60

-- -- Question-8
-- How many customers have upgraded to an annual plan in 2020?
select a.plan_name,
		count(*) as cnt_of_annual_plan
from a  
where a.plan_name = 'pro annual' and year(a.start_date) = 2020
group by 1;
-- 195

-- -- Question-9
-- How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
-- 105 days 
select 
	concat(ceiling(avg(datediff(c.start_date,b.start_date))),' ', 'days') average_days_to_annual
from 
	a b
join
	a c
on
	b.customer_id = c.customer_id
where 
	b.plan_id = 0 and c.plan_id = 3;

-- -- Question-10
--  Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
-- bucket_no	day_bucket	customer_count
-- 	0				0-30		48
-- 	1				30-60		25
-- 	2				60-90		33
-- 	3				90-120		35
-- 	4				120-150		43
-- 	5				150-180		35
-- 	6				180-210		27
-- 	7				210-240		4
-- 	8				240-270		5
-- 	9				270-300		1
-- 	10				300-330		1
-- 	11				330-360		1
 SELECT
	floor(days_to_upgrade / 30) bucket_no,
    concat(floor(days_to_upgrade / 30.0) * 30, '-' , FLOOR(days_to_upgrade / 30.0) * 30 + 30 ) AS day_bucket,
    COUNT(*) AS customer_count
FROM 
	annual_upgrade
GROUP BY
	1, 2
ORDER BY 
	1;
    
-- -- Question-11
-- How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
-- count_of_downgraded_customers
-- 	0
select 
	count(*) count_of_downgraded_customers
from (
	select 
		a.customer_id customer_id, 
		a.plan_id plan_id,
		lag(a.plan_id) over(partition by a.customer_id order by a.start_date asc) as previous_plan
	from 
		a
) b
where 
	b.plan_id = 1 and b.previous_plan = 2;
