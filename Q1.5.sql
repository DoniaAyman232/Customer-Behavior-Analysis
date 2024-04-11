select stockcode , total_quantity , rank() over ( order by total_quantity desc )  as most_ordered 
from (
select stockcode , sum(quantity) as total_quantity 
from tableretail
group by stockcode );

