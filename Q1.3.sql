SELECT DISTINCT TO_CHAR(TO_DATE(InvoiceDate, 'MM/DD/YYYY HH24:MI'), 'MM/DD/YYYY HH24:MI') AS month,
       SUM(quantity * price) OVER (PARTITION BY TO_CHAR(TO_DATE(InvoiceDate, 'MM/DD/YYYY HH24:MI'), 'MM/YYYY')) AS Monthly_Revenue
FROM tableRetail;
