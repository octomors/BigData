-- 8) Пользователь(и) с самой длинной фамилией.
WITH ranked AS (
  SELECT
    c.customer_id,
    c.last_name,
    c.first_name,
    c.patronymic,
    LENGTH(c.last_name) AS last_name_len,
    MAX(LENGTH(c.last_name)) OVER () AS max_len
  FROM customer c
)
SELECT
  customer_id,
  last_name,
  first_name,
  patronymic,
  last_name_len
FROM ranked
WHERE last_name_len = max_len
ORDER BY last_name, first_name, patronymic;