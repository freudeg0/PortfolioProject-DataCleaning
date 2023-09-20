/*---Dropping uneccesary columns---*/
ALTER table sales
DROP column unnamed_22,
DROP column fulfilled_by,
DROP column ship_country,
DROP column currency,
DROP column SalesChannel;

/*---Remove Duplicates---*/
SELECT OrderID, ASIN, COUNT(*) AS DuplicateCount
FROM sales
GROUP BY OrderID, ASIN
HAVING COUNT(*) > 1;

CREATE VIEW keep_sales_view AS
SELECT MIN(Ind) AS keep_index
FROM sales
GROUP BY OrderID, ASIN;

DELETE FROM sales
WHERE Ind NOT IN (SELECT keep_index FROM keep_sales_view);

DROP view keep_sales_view;

/*---Fill null values---*/
UPDATE sales
SET 
    CourierStatus = CASE WHEN CourierStatus = '' THEN 'Unknown' ELSE CourierStatus END,
    promotion_ids = CASE WHEN  promotion_ids = '' THEN 'No promotion' ELSE  promotion_ids END,
    ship_city = CASE WHEN  ship_city = '' THEN 'Unknown' ELSE ship_city END,
	ship_state = CASE WHEN  ship_state = '' THEN 'Unknown' ELSE ship_state END;
    
SELECT * FROM sales WHERE CourierStatus='';
SELECT * FROM sales WHERE promotion_ids='';
SELECT * FROM sales WHERE ship_city='';
SELECT * FROM sales WHERE ship_state='';
    
/*--- Changing B2B column---*/
SELECT B2B FROM sales;
ALTER TABLE sales
CHANGE COLUMN B2B customer_type varchar(255);
UPDATE sales
SET customer_type = CASE
    WHEN customer_type = 'TRUE' THEN 'Business'
    WHEN customer_type = 'FALSE' THEN 'Customer'
END;
SELECT customer_type FROM sales;


/*---Changing column name of Amount and converting to $---*/

ALTER TABLE sales
CHANGE Amount order_amount_in_$ float4;

UPDATE sales
SET order_amount_in_$ = order_amount_in_$ * 0.012;
SELECT order_amount_in_$ FROM sales;

/*---Delete March data---*/
SELECT DISTINCT date FROM sales
ORDER BY date;

DELETE FROM sales
WHERE MONTH(Date) = 3;

/*---Add Month column---*/
ALTER TABLE sales
ADD COLUMN Month VARCHAR(20);

UPDATE sales
SET Month = DATE_FORMAT(date, '%M');

SELECT date,Month FROM sales;

/*---Ordering Size column---*/
SELECT *
FROM sales
ORDER BY FIELD(size, 'Free', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL', '4XL', '5XL', '6XL');

/*---Standardize the City and State names---*/
SELECT DISTINCT ship_state
FROM sales
Order by ship_state;

UPDATE sales
SET ship_state = 'Arunachal Pradesh'
WHERE ship_state IN ('AR', 'APO');

UPDATE sales
SET ship_state = 'Nagaland'
WHERE ship_state = 'NL';

UPDATE sales
SET ship_state = 'Odisha'
WHERE ship_state = 'orissa';

UPDATE sales
SET ship_state = 'Punjab'
WHERE ship_state IN ('PB','Punjab/Mohali/Zirakpur');

UPDATE sales
SET ship_state = 'Puducherry'
WHERE ship_state = 'Pondicherry';

UPDATE sales
SET ship_state = 'Rajasthan'
WHERE ship_state IN ('RJ','Rajshthan','rajsthan');

UPDATE sales
SET ship_state = UPPER(ship_state);

UPDATE sales
SET ship_state = REPLACE(ship_state, ' AND ', ' & ');

SELECT DISTINCT ship_city
FROM sales
Order by ship_city;

UPDATE sales
SET ship_city ='Kangra'
WHERE ship_city='53miles';

UPDATE sales
SET ship_city='Dehradun'
WHERE ship_city= '1';

UPDATE sales
SET ship_city='Ayodhya'
WHERE ship_city= ',raibarely road faizabad (Ayodhya)';

UPDATE sales
SET ship_city='NRpura'
WHERE ship_city= '(Chikmagalur disterict).     (N.R pur thaluku)';

UPDATE sales
SET ship_city='Uttarpara'
WHERE ship_city= '116  B. P. M. B SARANI, UTTARPARA KOTRUNG';

UPDATE sales
SET ship_city='Kolkata'
WHERE ship_city= '147/19 B Keshab Chandra Sen Street Kolkata nine ma';

UPDATE sales
SET ship_city='Quepem'
WHERE ship_city= '(Via Cuncolim)Quepem,South Goa';

UPDATE sales
SET ship_city='Tadong'
WHERE ship_city= '6th mile tadong';

UPDATE sales
SET ship_city='Barasat'
WHERE ship_city= '7BARASAT';

UPDATE sales
SET ship_city  = 'Lucknow'
WHERE ship_postal_code= '226002';

UPDATE sales
SET ship_city = REGEXP_REPLACE(ship_city, '[^a-zA-Z]', '');

UPDATE sales
SET ship_city = UPPER(ship_city);

/*---Standardize column names---*/
ALTER TABLE sales
RENAME COLUMN OrderID TO order_ID  ,
RENAME COLUMN Status TO ship_status ,
RENAME COLUMN Fulfilment TO fullfilment ,
RENAME COLUMN ship_service_level TO service_level ,
RENAME COLUMN Style TO style ,
RENAME COLUMN SKU TO sku ,
RENAME COLUMN Category TO product_category ,
RENAME COLUMN Size TO size ,
RENAME COLUMN ASIN TO asin ,
RENAME COLUMN CourierStatus TO courier_ship_status,
RENAME COLUMN Qty TO order_quantity,
RENAME COLUMN ship_city TO city,
RENAME COLUMN ship_state TO state,
RENAME COLUMN ship_postal_code TO zip,
RENAME COLUMN promotion_ids TO promotion,
RENAME COLUMN Month TO month;










































 
    

    
    
    







