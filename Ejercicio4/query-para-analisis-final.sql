 /*  
  La siguiente query nos ayudara a conocer la información mas importante de cada sucursal:
   *Total de clientes que han visitado cada sucursal
   *Ingresos promedio de los clientes que visitan cada sucursal
   *Edad promedio de los clientes que visitan cada sucursal
   *Visitas promedio de los clientes que visitan cada sucursal
   *Promedio de usuo de cada servicio por sucursal

  Esta información nos ayudara para ampliar el analisis y poder segmentar los clientes y de esta manera generar propuestas de mejora
  para el negocio en general asi como para cada una de nuestras sucursales
*/ 
SELECT 
    branch_name AS sucursal,                                              -- Agrupar por sucursal
	COUNT(*) AS total_clientes,                                           -- Total de clientes
    CEILING(AVG(income)) AS ingresos_promedios,                           -- Promedio de ingresos redondeado hacia arriba
    CEILING(AVG(age)) AS edad_promedio,                                   -- Promedio de edad redondeado hacia arriba
    CEILING(AVG(average_visits)) AS visitas_promedio,                    -- Promedio de visitas
    ROUND(AVG(CAST(use_sauna  AS INT)), 2) AS promedio_uso_sauna,        -- Promedio de uso de sauna
    ROUND(AVG(CAST(use_hidro  AS INT)), 2) AS promedio_uso_hidro,        -- Promedio de uso de hidroterapia
    ROUND(AVG(CAST(use_yoga  AS INT)), 2) AS promedio_uso_yoga,          -- Promedio de uso de yoga
   ROUND(AVG(CAST(use_massage  AS INT)), 2) AS promedio_uso_masaje       -- Promedio de uso de masaje
FROM customer_activities                                                  -- Tabla con los datos
GROUP BY branch_name;                                                     -- Agrupar por sucursal

/*
	En la siguiente consulta vamos a agrupar según visitas a los clientes, lo cual nos permitira segmentarlos en clases por cada sucursal, nos ayudará a conocer lo siguiente:
	1)Como queda segmentado nuestro total de clientes
	2)Cuantos clientes tenemos en cada categoria
	3)Cuanto es el promedio de visitas por categoria
	4)Edad promedio de cada categoria
	5)Genero que predomina en cada categoria y cuantas personas son
*/

WITH Categorized_Customers AS (
    SELECT 
        branch_name,                                      -- Agrupar por sucursal
        CASE 
            WHEN average_visits < 2 THEN 'C'
            WHEN average_visits BETWEEN 2 AND 5 THEN 'B'
            WHEN average_visits >= 5 THEN 'A'
        END AS categoria_clientes,                            -- Clasificación en Grupo A, B o C
        sex,                                              -- Sexo del cliente
        average_visits,                                  -- Visitas promedio
        age                                              -- Edad del cliente
    FROM customer_activities
),
Class_Counts AS (
    SELECT 
        branch_name, 
        categoria_clientes,
        COUNT(*) AS cantidad_clientes,
        CEILING(AVG(average_visits)) AS promedio_visitas,         -- Promedio de visitas por clase
        CEILING(AVG(age)) AS edad_promedio                        -- Edad promedio por clase
    FROM Categorized_Customers
    GROUP BY 
        branch_name,
        categoria_clientes
),
Sex_Counts AS (
    SELECT 
        branch_name, 
        categoria_clientes,
        sex,
        COUNT(*) AS cantidad_sexo
    FROM Categorized_Customers
    GROUP BY 
        branch_name,
        categoria_clientes,
        sex
),
Dominant_Sex AS (
    SELECT 
        branch_name,
        categoria_clientes,
        sex,
        cantidad_sexo,
        ROW_NUMBER() OVER (PARTITION BY branch_name, categoria_clientes ORDER BY cantidad_sexo DESC) AS rn
    FROM Sex_Counts
)
SELECT 
    cs.branch_name as Sucursal,
    cs.categoria_clientes,
    cs.promedio_visitas,
    cs.edad_promedio,
    ds.sex AS sexo_predominante,
    ds.cantidad_sexo
FROM Class_Counts cs
LEFT JOIN Dominant_Sex ds
    ON cs.branch_name = ds.branch_name
    AND cs.categoria_clientes = ds.categoria_clientes
    AND ds.rn = 1
ORDER BY 
    cs.branch_name, 
    cs.categoria_clientes ASC;

/*
	En la siguiente consulta vamos a evaluar por cada clase de cliente de cada sucursal cuales son los servicios mas utilizados y los menos utilizados,
	esto nos permitira crear promociones en base a la clase de cliente, a los productos que ya sabemos que mas utiliza y a los servicios que nos iteresa que consuma mas cada clase de cliente.
*/


WITH Categorized_Customers AS (
    SELECT 
        branch_name,                                      -- Agrupar por sucursal
        CASE 
            WHEN average_visits < 2 THEN 'C'
            WHEN average_visits BETWEEN 2 AND 5 THEN 'B'
            WHEN average_visits >= 5 THEN 'A'
        END AS clase_cliente,                            -- Clasificación en Grupo A, B o C
        use_sauna,                                       -- Uso del sauna
        use_hidro,                                       -- Uso de hidroterapia
        use_yoga,                                        -- Uso de yoga
        use_massage                                      -- Uso de masaje
    FROM customer_activities
),
Service_Usage AS (
    SELECT
        branch_name,
        clase_cliente,
        'Sauna' AS service,
        SUM(CAST(use_sauna AS INT)) AS usage_count
    FROM Categorized_Customers
    GROUP BY branch_name, clase_cliente

    UNION ALL

    SELECT
        branch_name,
        clase_cliente,
        'Hidroterapia' AS service,
        SUM(CAST(use_hidro AS INT)) AS usage_count
    FROM Categorized_Customers
    GROUP BY branch_name, clase_cliente

    UNION ALL

    SELECT
        branch_name,
        clase_cliente,
        'Yoga' AS service,
        SUM(CAST(use_yoga AS INT)) AS usage_count
    FROM Categorized_Customers
    GROUP BY branch_name, clase_cliente

    UNION ALL

    SELECT
        branch_name,
        clase_cliente,
        'Masaje' AS service,
        SUM(CAST(use_massage AS INT)) AS usage_count
    FROM Categorized_Customers
    GROUP BY branch_name, clase_cliente
),
Ranked_Services AS (
    SELECT
        branch_name,
        clase_cliente,
        service,
        usage_count,
        ROW_NUMBER() OVER (PARTITION BY branch_name, clase_cliente ORDER BY usage_count DESC) AS rank_desc,
        ROW_NUMBER() OVER (PARTITION BY branch_name, clase_cliente ORDER BY usage_count ASC) AS rank_asc
    FROM Service_Usage
)
SELECT 
    branch_name as Sucursal,
    clase_cliente as categoria_cliente,
    service as servicios,
    usage_count as uso
FROM Ranked_Services
WHERE rank_desc <= 2 OR rank_asc <= 2
ORDER BY 
    branch_name, 
    clase_cliente,
    rank_desc, 
    rank_asc;
