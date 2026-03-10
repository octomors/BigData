BEGIN;

-- Удаление индексов, созданных для ускорения запросов Lab3.
DROP INDEX IF EXISTS public.product_price_change_product_date_idx;
DROP INDEX IF EXISTS public.product_price_change_date_product_idx;
DROP INDEX IF EXISTS public.purchase_delivery_date_idx;
DROP INDEX IF EXISTS public.purchase_purchase_date_customer_idx;
DROP INDEX IF EXISTS public.purchase_store_id_idx;
DROP INDEX IF EXISTS public.purchase_item_purchase_id_idx;
DROP INDEX IF EXISTS public.purchase_item_product_id_idx;
DROP INDEX IF EXISTS public.product_manufacturer_category_idx;
DROP INDEX IF EXISTS public.manufacturer_name_upper_idx;
DROP INDEX IF EXISTS public.manufacturer_name_trgm_idx;
DROP INDEX IF EXISTS public.product_name_length_idx;
DROP INDEX IF EXISTS public.customer_last_name_length_idx;
DROP INDEX IF EXISTS public.customer_first_name_idx;
DROP INDEX IF EXISTS public.store_name_trgm_idx;
DROP INDEX IF EXISTS public.store_addr_trgm_idx;

COMMIT;
