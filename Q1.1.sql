select customer_id ,total_revenue  , rank() over (order by total_revenue desc  ) as top_customer from (
select  customer_id , sum(Quantity*price) as total_revenue 
from tableRetail
group by customer_id  );
