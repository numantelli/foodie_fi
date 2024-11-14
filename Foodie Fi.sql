--1.How many customers has Foodie-Fi ever had?

select count(distinct customer_id) from subscriptions



--2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

select to_char(start_date, 'Month'),
count(distinct customer_id)
from subscriptions
where plan_id=0
group by 1



--3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

with tablo as
(
select to_char(start_date, 'YYYY') as year,
plan_id, count(plan_id)
from subscriptions 
group by 1,2
order by 1,2
)
select t.plan_id, plan_name, count as amount
from tablo as t
left join plans as p
on t.plan_id=p.plan_id
where year !='2020'


--4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

select count(distinct customer_id) from subscriptions = 1000

select count(customer_id) from subscriptions where plan_id=4 = 307

select 307/1000::float *100



--5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

with tablo as
(
select customer_id, plan_id, 
lead(plan_id,1,null) over(partition by customer_id order by plan_id)
from subscriptions
)
select count(customer_id) from tablo where plan_id=0 and lead=4 --  = 92

select count(distinct customer_id) from subscriptions -- = 1000

select round(92/1000::float *100)



--6. What is the number and percentage of customer plans after their initial free trial?


with tablo4 as
(
with tablo3 as
(
with tablo2 as
(
with tablo as
(
select customer_id, plan_id, 
lead(plan_id,1,null) over(partition by customer_id order by plan_id)
from subscriptions
)
select * from tablo where plan_id=0
)
select lead, count(customer_id)
from tablo2
group by 1
)
select *, sum(count) over()
from tablo3
)
select lead as plans, round(count/sum::float*100)
from tablo4
order by 1



--7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

with tablo as
(
select customer_id, count(plan_id)
from subscriptions 
where to_char(start_date,'YYYY') = '2020'
group by 1
having count(plan_id)=4
)
select count(customer_id) from tablo   =46

select 46/1000::float*100


--8. How many customers have upgraded to an annual plan in 2020?

select count(customer_id)
from subscriptions 
where to_char(start_date,'YYYY') = '2020' and plan_id=3   =195

select 195/1000::float*100


--9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

with tablo3 as
(
with tablo2 as
(
with tablo as
(
select customer_id, plan_id, start_date
from subscriptions 
where plan_id in(0,3)
)
select customer_id, plan_id,
lead(plan_id,1,null) over(partition by customer_id order by plan_id) as plan3,
start_date,
lead(start_date,1,null) over(partition by customer_id order by start_date) as plan3date
from tablo
)
select *, plan3date-start_date as time_dif
from tablo2
where plan3=3
)
select round(avg(time_dif)) from tablo3



--10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

with tablo4 as
(
with tablo3 as
(
with tablo2 as
(
with tablo as
(
select customer_id, plan_id, start_date
from subscriptions 
where plan_id in(0,3)
)
select customer_id, plan_id,
lead(plan_id,1,null) over(partition by customer_id order by plan_id) as plan3,
start_date,
lead(start_date,1,null) over(partition by customer_id order by start_date) as plan3date
from tablo
)
select *, plan3date-start_date as time_dif
from tablo2
where plan3=3
order by 6
)

select customer_id, time_dif,
case when time_dif between 0 and 30 then '0-30'
when time_dif between 31 and 60 then '31-60'
when time_dif between 61 and 90 then '61-90'
when time_dif between 91 and 120 then '91-120'
when time_dif between 121 and 150 then '121-150'
when time_dif between 151 and 180 then '151-180'
when time_dif between 181 and 210 then '181-210'
when time_dif between 211 and 240 then '210-240'
when time_dif between 241 and 270 then '241-270'
when time_dif between 271 and 300 then '271-300'
when time_dif between 301 and 330 then '301-330'
when time_dif between 331 and 360 then '331-360'
end as time_period
from tablo3
)
select time_period, count(customer_id)
from tablo4
group by 1



--11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

with tablo as
(
select customer_id, plan_id, 
lead(plan_id,1,null) over(partition by customer_id order by plan_id) as second
from subscriptions
where to_char(start_date,'YYYY') = '2020'
)
select * from tablo 
where plan_id=2 and second=1





