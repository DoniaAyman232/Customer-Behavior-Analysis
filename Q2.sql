WITH RFMData AS (
    SELECT
        CUSTOMER_ID,
      (SELECT MAX(TO_DATE(INVOICEDATE, 'MM/DD/YYYY HH24:MI')) FROM tableretail) - MAX(TO_DATE(INVOICEDATE, 'MM/DD/YYYY HH24:MI')) AS Recency,
        COUNT(INVOICE) AS Frequency,
       SUM(QUANTITY * PRICE)AS Monetary
    FROM
        tableretail
    GROUP BY
        CUSTOMER_ID
),
rfm_score AS (
    SELECT
        customer_id,
        recency,
        Frequency,
        Monetary,
       NTILE(5) OVER (ORDER BY recency desc ) AS r_score,
         NTILE(5) OVER (ORDER BY frequency)AS f_score,
        NTILE(5) OVER (ORDER BY monetary) AS m_score
    FROM
        RFMData
),
fm_avg AS (
    SELECT
        customer_id,
        recency,
        Frequency,
        Monetary,
        r_score,
        f_score,
        m_score,
     round( (F_score + M_score) / 2) AS FM_score
    FROM
        rfm_score
),
seg_cust AS (
    SELECT
        customer_id,
        recency,
        Frequency,
        Monetary,
        r_score,
        f_score,
        m_score,
        FM_score,
        CASE
            WHEN R_score = 5 AND FM_score = 5 THEN 'Champions'
            WHEN R_score = 5 AND FM_score = 4 THEN 'Champions'
            WHEN R_score = 4 AND FM_score = 5 THEN 'Champions'
            WHEN R_score = 5 AND FM_score = 2 THEN 'Potential Loyalists'
            WHEN R_score = 4 AND FM_score = 2 THEN 'Potential Loyalists'
            WHEN R_score = 3 AND FM_score = 3 THEN 'Potential Loyalists'
            WHEN R_score = 4 AND FM_score = 3 THEN 'Potential Loyalists'
            WHEN R_score = 5 AND FM_score = 3 THEN 'Loyal Customers'
            WHEN R_score = 4 AND FM_score = 4 THEN 'Loyal Customers'
            WHEN R_score = 3 AND FM_score = 5 THEN 'Loyal Customers'
            WHEN R_score = 3 AND FM_score = 4 THEN 'Loyal Customers'
            WHEN R_score = 5 AND FM_score = 1 THEN 'Recent Customers'
            WHEN R_score = 4 AND FM_score = 1 THEN 'Promising'
            WHEN R_score = 3 AND FM_score = 1 THEN 'Promising'
            WHEN R_score = 3 AND FM_score = 2 THEN 'Customers Needing Attention'
            WHEN R_score = 2 AND FM_score = 3 THEN 'Customers Needing Attention'
            WHEN R_score = 2 AND FM_score = 2 THEN 'Customers Needing Attention'
            WHEN R_score = 2 AND FM_score = 5 THEN 'At Risk'
            WHEN R_score = 2 AND FM_score = 4 THEN 'At Risk'
            WHEN R_score = 1 AND FM_score = 3 THEN 'At Risk'
            WHEN R_score = 1 AND FM_score = 5 THEN 'Cant Lose Them'
            WHEN R_score = 1 AND FM_score = 4 THEN 'Cant Lose Them'
            WHEN R_score = 1 AND FM_score = 2 THEN 'Hibernating'
            WHEN R_score = 1 AND FM_score = 1 THEN 'Lost'
        END AS cust_segment
    FROM
        fm_avg
)
SELECT
    CUSTOMER_ID,
    Recency,
    Frequency,
    Monetary,
    R_score,
    FM_score,
    cust_segment
FROM
    seg_cust
      
      ;
