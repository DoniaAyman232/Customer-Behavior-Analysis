WITH cust_amt AS (
    SELECT
        cust_id,
        calendar_dt,
        SUM(amt_le) OVER (PARTITION BY cust_id ORDER BY calendar_dt) AS total,
         calendar_dt - FIRST_VALUE(calendar_dt) OVER (PARTITION BY cust_id ORDER BY calendar_dt) 
         AS total_days
    FROM
        customers
),
amt_threshold AS (
    SELECT
        cust_id,
        calendar_dt,
        total , total_days
    FROM
        cust_amt
    WHERE
        total >= 250 
) ,
 

threshold_days as (
SELECT 
    min(total_days) as total_days_threshold  , cust_id 
   
FROM
    amt_threshold
    group by cust_id )
    
    select   
 round(avg (total_days_threshold) ) as threshold
       from threshold_days ;