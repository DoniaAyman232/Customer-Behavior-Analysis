with cust_row as (
select cust_id , calendar_dt , row_number() over (partition by cust_id order by calendar_dt ) as rn 
from customers ),
cons_days as ( 
select cust_id , calendar_dt , rn,
calendar_dt - row_number() over (partition by cust_id order by calendar_dt ) as gap_days
 from cust_row ) ,
 consecutive as ( 
 select cust_id , gap_days , count (*) as consecutive_days
 from cons_days 
 group by cust_id , gap_days)
 select cust_id , max(consecutive_days) as max_consecutive_days
 from consecutive
 group by cust_id;