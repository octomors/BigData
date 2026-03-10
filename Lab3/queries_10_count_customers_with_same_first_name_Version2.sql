-- 10) Количество покупателей с одинаковым именем.
SELECT
  c.first_name,
  COUNT(*) AS customers_count
FROM customer c
GROUP BY c.first_name
HAVING COUNT(*) > 1
ORDER BY customers_count DESC, c.first_name;