-- 15) Суммарные продажи по каждому товару (стоимость * количество),
-- вывести наименование товара и итоговую сумму.
SELECT
  pr.product_id,
  pr.product_name,
  SUM(pi.product_count * pi.product_price) AS total_sales
FROM purchase_item pi
JOIN product pr ON pr.product_id = pi.product_id
GROUP BY pr.product_id, pr.product_name
ORDER BY total_sales DESC, pr.product_name;