#EJERCICIO 2
  #apartado 1
SELECT DISTINCT country,
 status, 
 COUNT(*) AS num_operaciones,
 AVG(amount) AS promedio_amount
FROM orders
WHERE created_at > '2015-07-01' 
AND country IN ('Francia', 'Portugal', 'España')
AND amount BETWEEN 100 AND 1500
GROUP BY country, status
ORDER BY promedio_amount DESC;

  #apartado 2
SELECT DISTINCT country , 
count(country IN (country)) as n_total_por_pais,
MAX(amount) AS mayor_cantidad,
MIN(amount) AS menor_cantidad
####MAX(CASE WHEN amount = (SELECT MAX(amount) FROM orders) THEN order_id END) AS order_id_maximo_amount
####(SELECT order_id
     #FROM orders 
     #WHERE amount=max(amount))
####He intentado sacar el order_id asociado al valor de amount(max y min) para cada linea, pero no
#he conseguido hacerlo con estos códigos de arriba, a ver si hay alguna forma mas facil o 
# soy yo que me he querido complicar:(
FROM orders
WHERE status NOT IN ('CANCELLED', 'DELINQUENT') AND amount>100
GROUP BY country
ORDER BY n_total_por_pais DESC
LIMIT 3;

#EJERCICIO 3
  #apartado 1
  
SELECT  M.merchant_id AS id_comercio,
M.name AS marca,
O.country as pais,
count(DISTINCT O.order_id) as operaciones_pais_marca,
ROUND(AVG(O.amount),3) AS valor_promedio,
count(DISTINCT R.order_id) as total_devoluciones,
IF(SUM(R.amount)>0,'Si','No') AS aceptacion_devolucion
FROM orders as O
INNER JOIN merchants as M ON O.merchant_id=M.merchant_id
LEFT JOIN refunds as R ON O.order_id=R.order_id
WHERE country IN ('España','Marruecos','Italia','Portugal')
GROUP BY id_comercio, marca, pais
HAVING operaciones_pais_marca > 10
ORDER BY operaciones_pais_marca ASC;


  #apartado 2
CREATE VIEW tarea_ucm.orders_view AS
SELECT
o.*,
m.name AS MARCA,
COUNT(DISTINCT r.order_id) AS devoluciones,
SUM(r.amount) AS suma_devoluciones
FROM orders o
INNER JOIN merchants m ON o.merchant_id = m.merchant_id
LEFT JOIN refunds r ON o.order_id = r.order_id
GROUP BY o.order_id, m.name;


#EJERCICIO 4

SELECT
M.name AS nombre_comercio,
O.country AS pais,
COUNT(DISTINCT O.order_id) AS total_ventas,
COUNT(DISTINCT R.order_id) AS total_devoluciones,
ROUND((COUNT(DISTINCT R.order_id) / NULLIF(COUNT(DISTINCT O.order_id), 0)) * 100, 2) AS tasa_devoluciones_porcentaje
FROM merchants M
LEFT JOIN orders O ON M.merchant_id = O.merchant_id
LEFT JOIN refunds R ON O.order_id = R.order_id
GROUP BY M.name, pais
HAVING total_ventas >0
ORDER BY nombre_comercio , tasa_devoluciones_porcentaje DESC;
  




