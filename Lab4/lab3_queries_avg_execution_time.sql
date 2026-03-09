-- Запуск каждого запроса из Lab3 10 раз и расчет среднего времени выполнения.
-- Результат: таблица "запрос" / "Среднее время выполнения" (мс).

DROP TABLE IF EXISTS pg_temp.query_timings;
CREATE TEMP TABLE query_timings (
  query_name TEXT NOT NULL,
  run_number INTEGER NOT NULL,
  duration_ms NUMERIC NOT NULL
);

DO $do$
DECLARE
  query_record RECORD;
  run_idx INTEGER;
  started_at TIMESTAMPTZ;
  finished_at TIMESTAMPTZ;
BEGIN
  FOR query_record IN
    SELECT * FROM (VALUES
      ('queries_01_most_expensive_and_cheapest_product', $sql$
        WITH latest_price AS (
          SELECT
            ppc.product_id,
            ppc.new_price,
            ROW_NUMBER() OVER (PARTITION BY ppc.product_id ORDER BY ppc.date_price_change DESC) AS rn
          FROM product_price_change ppc
        ),
        priced AS (
          SELECT
            pr.product_id,
            pr.product_name,
            lp.new_price
          FROM product pr
          JOIN latest_price lp
            ON lp.product_id = pr.product_id
           AND lp.rn = 1
        ),
        ranked AS (
          SELECT
            priced.*,
            RANK() OVER (ORDER BY new_price DESC) AS r_desc,
            RANK() OVER (ORDER BY new_price ASC)  AS r_asc
          FROM priced
        )
        SELECT
          CASE
            WHEN r_desc = 1 THEN 'most_expensive'
            WHEN r_asc  = 1 THEN 'cheapest'
          END AS price_rank,
          product_id,
          product_name,
          new_price
        FROM ranked
        WHERE r_desc = 1 OR r_asc = 1
        ORDER BY new_price DESC, product_name
      $sql$),
      ('queries_02_delivered_items_count_from_2021_05_05_to_today', $sql$
        SELECT
          COALESCE(SUM(pi.product_count), 0) AS delivered_items_count
        FROM purchase p
        JOIN purchase_item pi ON pi.purchase_id = p.purchase_id
        WHERE p.delivery_date >= DATE '2021-05-05'
          AND p.delivery_date <= CURRENT_DATE
      $sql$),
      ('queries_03_manufacturers_name_pattern_A__O__M', $sql$
        SELECT
          m.manufacturer_id,
          m.manufacturer_name
        FROM manufacturer m
        WHERE UPPER(m.manufacturer_name) LIKE 'A_O%M'
        ORDER BY m.manufacturer_name
      $sql$),
      ('queries_04_top3_longest_product_names_sorted_alpha', $sql$
        WITH top3 AS (
          SELECT
            p.product_id,
            p.product_name,
            LENGTH(p.product_name) AS name_len
          FROM product p
          ORDER BY name_len DESC, p.product_name
          LIMIT 3
        )
        SELECT
          product_id,
          product_name,
          name_len
        FROM top3
        ORDER BY name_len
      $sql$),
      ('queries_05_products_with_price_changed_since_november_current_year', $sql$
        SELECT DISTINCT
          p.product_id,
          p.product_name
        FROM product_price_change ppc
        JOIN product p ON p.product_id = ppc.product_id
        WHERE ppc.date_price_change >= make_date(EXTRACT(YEAR FROM CURRENT_DATE)::int, 11, 1)
        ORDER BY p.product_name
      $sql$),
      ('queries_05_products_with_price_changed_since_november_current_year_Version2', $sql$
        SELECT DISTINCT
          p.product_id,
          p.product_name
        FROM product_price_change ppc
        JOIN product p ON p.product_id = ppc.product_id
        WHERE ppc.date_price_change >= make_timestamp(EXTRACT(YEAR FROM CURRENT_DATE)::int, 11, 1, 0, 0, 0)
        ORDER BY p.product_name
      $sql$),
      ('queries_06_categories_produced_by_bosch_subquery', $sql$
        SELECT
          c.category_id,
          c.category_name
        FROM category c
        WHERE c.category_id IN (
          SELECT DISTINCT p.category_id
          FROM product p
          WHERE p.manufacturer_id IN (
            SELECT m.manufacturer_id
            FROM manufacturer m
            WHERE m.manufacturer_name ILIKE 'b%sch'
               OR m.manufacturer_name ILIKE 'bosh'
          )
        )
        ORDER BY c.category_name
      $sql$),
      ('queries_07_addresses_of_samsung_branches_subquery', $sql$
        SELECT DISTINCT
          s.store_id,
          s.store_addr,
          m.manufacturer_name
        FROM store s
        JOIN purchase pch ON s.store_id = pch.store_id
        JOIN purchase_item pi ON pch.purchase_id = pi.purchase_id
        JOIN product pr ON pi.product_id = pr.product_id
        JOIN manufacturer m ON pr.manufacturer_id = m.manufacturer_id
        WHERE m.manufacturer_name = 'Samsung'
        ORDER BY s.store_addr
      $sql$),
      ('queries_08_customers_with_longest_last_name_Version2', $sql$
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
        ORDER BY last_name, first_name, patronymic
      $sql$),
      ('queries_09_most_expensive_and_cheapest_purchase', $sql$
        WITH totals AS (
          SELECT
            p.purchase_id,
            p.purchase_date,
            p.delivery_date,
            p.customer_id,
            p.store_id,
            SUM(pi.product_count * pi.product_price) AS total_before_discount
          FROM purchase p
          JOIN purchase_item pi ON pi.purchase_id = p.purchase_id
          GROUP BY p.purchase_id, p.purchase_date, p.delivery_date, p.customer_id, p.store_id
        ),
        ranked AS (
          SELECT
            t.*,
            RANK() OVER (ORDER BY total_before_discount DESC) AS r_desc,
            RANK() OVER (ORDER BY total_before_discount ASC)  AS r_asc
          FROM totals t
        )
        SELECT
          CASE
            WHEN r_desc = 1 THEN 'most_expensive'
            WHEN r_asc  = 1 THEN 'cheapest'
          END AS purchase_rank,
          purchase_id,
          store_id,
          customer_id,
          purchase_date,
          delivery_date,
          total_before_discount
        FROM ranked
        WHERE r_desc = 1 OR r_asc = 1
        ORDER BY total_before_discount DESC, purchase_id
      $sql$),
      ('queries_10_count_customers_with_same_first_name_Version2', $sql$
        SELECT
          c.first_name,
          COUNT(*) AS customers_count
        FROM customer c
        GROUP BY c.first_name
        HAVING COUNT(*) > 1
        ORDER BY customers_count DESC, c.first_name
      $sql$),
      ('queries_11_products_and_delivered_quantities_desc_alpha', $sql$
        SELECT
          pr.product_id,
          pr.product_name,
          SUM(pi.product_count) AS delivered_qty
        FROM purchase p
        JOIN purchase_item pi ON pi.purchase_id = p.purchase_id
        JOIN product pr ON pr.product_id = pi.product_id
        WHERE p.delivery_date IS NOT NULL
        GROUP BY pr.product_id, pr.product_name
        ORDER BY pr.product_name DESC
      $sql$),
      ('queries_12_customers_bought_more_than_10_items_since_march_current_year_Version2', $sql$
        WITH since_march AS (
          SELECT
            p.customer_id,
            SUM(pi.product_count) AS items_bought
          FROM purchase p
          JOIN purchase_item pi ON pi.purchase_id = p.purchase_id
          WHERE p.purchase_date >= make_date(EXTRACT(YEAR FROM CURRENT_DATE)::int, 3, 1)
          GROUP BY p.customer_id
        )
        SELECT
          c.customer_id,
          c.last_name,
          c.first_name,
          c.patronymic,
          sm.items_bought
        FROM since_march sm
        JOIN customer c ON c.customer_id = sm.customer_id
        WHERE sm.items_bought > 10
        ORDER BY sm.items_bought DESC, c.last_name, c.first_name, c.patronymic
      $sql$),
      ('queries_13_categories_not_produced_by_samsung', $sql$
        SELECT
          c.category_id,
          c.category_name
        FROM category c
        WHERE c.category_id NOT IN (
          SELECT DISTINCT p.category_id
          FROM product p
          WHERE p.manufacturer_id IN (
            SELECT m.manufacturer_id
            FROM manufacturer m
            WHERE m.manufacturer_name = 'Samsung'
          )
        )
        ORDER BY c.category_name
      $sql$),
      ('queries_14_products_and_manufacturers_delivered_from_mira25_jun_to_aug_2021', $sql$
        SELECT DISTINCT
          pr.product_name,
          m.manufacturer_name,
          p.purchase_id,
          p.delivery_date
        FROM purchase p
        JOIN store s ON s.store_id = p.store_id
        JOIN purchase_item pi ON pi.purchase_id = p.purchase_id
        JOIN product pr ON pr.product_id = pi.product_id
        JOIN manufacturer m ON m.manufacturer_id = pr.manufacturer_id
        WHERE (s.store_name ILIKE '%Мира 25%' OR s.store_addr ILIKE '%Мира 25%')
          AND p.delivery_date >= DATE '2021-06-01'
          AND p.delivery_date <  DATE '2021-09-01'
        ORDER BY p.delivery_date, pr.product_name
      $sql$),
      ('queries_15_total_sales_per_product', $sql$
        SELECT
          pr.product_id,
          pr.product_name,
          SUM(pi.product_count * pi.product_price) AS total_sales
        FROM purchase_item pi
        JOIN product pr ON pr.product_id = pi.product_id
        GROUP BY pr.product_id, pr.product_name
        ORDER BY total_sales DESC, pr.product_name
      $sql$),
      ('queries_16_manufacturer_and_sold_items_count', $sql$
        SELECT
          m.manufacturer_id,
          m.manufacturer_name,
          COALESCE(SUM(pi.product_count), 0) AS sold_items_count
        FROM manufacturer m
        LEFT JOIN product pr ON pr.manufacturer_id = m.manufacturer_id
        LEFT JOIN purchase_item pi ON pi.product_id = pr.product_id
        GROUP BY m.manufacturer_id, m.manufacturer_name
        ORDER BY sold_items_count DESC, m.manufacturer_name
      $sql$),
      ('queries_17_total_items_sold_per_store', $sql$
        SELECT
          s.store_id,
          s.store_name,
          s.store_addr,
          COALESCE(SUM(pi.product_count), 0) AS sold_items_count
        FROM store s
        LEFT JOIN purchase p ON p.store_id = s.store_id
        LEFT JOIN purchase_item pi ON pi.purchase_id = p.purchase_id
        GROUP BY s.store_id, s.store_name, s.store_addr
        ORDER BY sold_items_count DESC, s.store_name
      $sql$)
    ) AS queries(query_name, query_text)
  LOOP
    FOR run_idx IN 1..10 LOOP
      started_at := clock_timestamp();
      EXECUTE query_record.query_text;
      finished_at := clock_timestamp();

      INSERT INTO query_timings (query_name, run_number, duration_ms)
      VALUES (
        query_record.query_name,
        run_idx,
        EXTRACT(EPOCH FROM finished_at - started_at) * 1000
      );
    END LOOP;
  END LOOP;
END;
$do$;

SELECT
  query_name AS "запрос",
  ROUND(AVG(duration_ms)::numeric, 3) AS "Среднее время выполнения"
FROM query_timings
GROUP BY query_name
ORDER BY query_name;
