select customer_id , avg_invoice, rank() over (order by  avg_invoice desc )as top_invocie  from (
select  customer_id , avg(quantity*price)  as avg_invoice
from tableRetail 
group by customer_id );
