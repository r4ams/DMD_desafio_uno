SELECT 
branch_name as departamento,
SUM(CAST(has_roses  AS INT)) AS total_rosas,
SUM(CAST(has_carnations AS INT)) AS total_claveles,
SUM(CAST(has_soil AS INT)) AS total_tierra,
SUM(CAST(has_sunflowers AS INT)) AS total_girasoles,
SUM(CAST(has_hydrangea AS INT)) AS total_hortensias,
SUM(CAST(has_balloons AS INT)) AS total_globos,
SUM(CAST(has_orchids AS INT)) AS total_orquideas,
SUM(CAST(has_crimson AS INT)) AS total_carmesi,
SUM(CAST(has_lilies AS INT)) AS total_lirios,
SUM(CAST(has_aurora AS INT)) AS total_aurora,
SUM(CAST(has_tulips AS INT)) AS total_tulipaness,
SUM(CAST(has_ribbon AS INT)) AS total_listones,
SUM(CAST(has_pots AS INT)) AS total_macetas,
SUM(
    CAST(has_roses AS INT) +
    CAST(has_carnations AS INT) +
    CAST(has_soil AS INT) +
    CAST(has_sunflowers AS INT) +
    CAST(has_hydrangea AS INT) +
    CAST(has_balloons AS INT) +
    CAST(has_orchids AS INT) +
    CAST(has_crimson AS INT) +
    CAST(has_lilies AS INT) +
    CAST(has_aurora AS INT) +
    CAST(has_tulips AS INT) +
    CAST(has_ribbon AS INT) +
    CAST(has_pots AS INT)
) AS ventas_totales
FROM 
    customer_activities    -- Asume que el nombre de la tabla es `sales_data`
GROUP BY 
    branch_name
ORDER BY 
    branch_name;



WITH Product_Sales AS (
    SELECT 
        branch_name,
        'Roses' AS product,
        SUM(CAST(has_roses  AS INT)) AS total_sales
    FROM customer_activities
    GROUP BY branch_name
    
    UNION ALL
    
    SELECT 
        branch_name,
        'Carnations' AS product,
        SUM(CAST(has_carnations AS INT)) AS total_sales
    FROM customer_activities
    GROUP BY branch_name
    
    UNION ALL
    
    SELECT 
        branch_name,
        'Soil' AS product,
        SUM(CAST(has_soil AS INT)) AS total_sales
    FROM customer_activities
    GROUP BY branch_name
    
    UNION ALL
    
    SELECT 
        branch_name,
        'Sunflowers' AS product,
        SUM(CAST(has_sunflowers AS INT)) AS total_sales
    FROM customer_activities
    GROUP BY branch_name
    
    UNION ALL
    
    SELECT 
        branch_name,
        'Hydrangea' AS product,
        SUM(CAST(has_hydrangea AS INT)) AS total_sales
    FROM customer_activities
    GROUP BY branch_name
    
    UNION ALL
    
    SELECT 
        branch_name,
        'Balloons' AS product,
        SUM(CAST(has_balloons AS INT)) AS total_sales
    FROM customer_activities
    GROUP BY branch_name
    
    UNION ALL
    
    SELECT 
        branch_name,
        'Orchids' AS product,
        SUM(CAST(has_orchids AS INT)) AS total_sales
    FROM customer_activities
    GROUP BY branch_name
    
    UNION ALL
    
    SELECT 
        branch_name,
        'Crimson' AS product,
        SUM(CAST(has_crimson AS INT)) AS total_sales
    FROM customer_activities
    GROUP BY branch_name
    
    UNION ALL
    
    SELECT 
        branch_name,
        'Lilies' AS product,
        SUM(CAST(has_lilies AS INT)) AS total_sales
    FROM customer_activities
    GROUP BY branch_name
    
    UNION ALL
    
    SELECT 
        branch_name,
        'Aurora' AS product,
        SUM(CAST(has_aurora AS INT)) AS total_sales
    FROM customer_activities
    GROUP BY branch_name
    
    UNION ALL
    
    SELECT 
        branch_name,
        'Tulips' AS product,
        SUM(CAST(has_tulips AS INT)) AS total_sales
    FROM customer_activities
    GROUP BY branch_name
    
    UNION ALL
    
    SELECT 
        branch_name,
        'Ribbon' AS product,
        SUM(CAST(has_ribbon AS INT)) AS total_sales
    FROM customer_activities
    GROUP BY branch_name
    
    UNION ALL
    
    SELECT 
        branch_name,
        'Pots' AS product,
        SUM(CAST(has_pots AS INT)) AS total_sales
    FROM customer_activities
    GROUP BY branch_name
),
Ranked_Products AS (
    SELECT
        branch_name,
        product,
        total_sales,
        ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY total_sales DESC) AS rank
    FROM Product_Sales
)
SELECT
    branch_name AS sucursal,
    product AS producto,
    total_sales AS ventas_totales,
	rank
FROM Ranked_Products
ORDER BY 
    branch_name, 
    rank;


