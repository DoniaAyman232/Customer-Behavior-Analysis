with customer_purchase as (
select customer_id , count(invoice) as purchaces from tableretail 
group by customer_id ),
ranked_purchase as (
select customer_id , purchaces, dense_rank() over  (order by  purchaces desc ) as top_purchase
from customer_purchase )
select customer_id , purchaces  ,  top_purchase
from ranked_purchase 
where top_purchase = 1 ;

