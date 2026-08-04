-- Consultas de negocio
-- Base de datos: Ventas_Tech_DB
 
USE Ventas_Tech_DB;
GO
-- Consulta 1
-- Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio
SELECT 
MONTH(fecha_venta) AS mes,
SUM(cantidad * precio_unitario) AS total_facturado,
COUNT(*) AS cantidad_pedidos,
AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH (fecha_venta)
ORDER BY mes;
GO

-- Consulta 2
-- Ranking Top 5 productos, mostrando las unidades vendidas y total facturado
SELECT TOP(5)
id_producto,
SUM(cantidad) AS unidades_vendidas,
SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;
GO
-- Consulta 3
-- Clientes recurrentes(más de 1 pedido>1)
SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;
GO

-- Consulta 4
-- Meses por encima / por debajo del promedio
WITH ventas_mensuales AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)

SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado >
            (SELECT AVG(total_facturado) FROM ventas_mensuales)
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion
FROM ventas_mensuales
ORDER BY mes;
GO


--Comentarios: 
--El producto con id_producto = 1 es el que genera la mayor facturación del períod0: 3.600
--Los clientes 1, 2, 3, 4 y 5 realizaron más de un pedido durante el período analizado.Todos los clientes realizaron 2 pedidos en total. 
-- El resultado se debe a que tu base de datos solo tiene un mes. La base de datos contiene únicamente ventas del mes de marzo de 2024, por lo que el análisis mensual corresponde a un único período.



