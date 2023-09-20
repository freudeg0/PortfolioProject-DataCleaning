# Amazon Sales-Data Cleaning in SQL

## Project Overview
In the modern data-driven business landscape, the quality of data is paramount. This project focuses on the crucial initial step of data cleaning for Amazon Sales dataset, laying the foundation for future data analysis and insights that can help address pressing business challenges.

## Tools

-MySQL Workbench

## Data Cleaning

Let's take a look at the data first.

![Capture](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/300df320-2a01-4cc9-8486-1f3f98bebcfb)

### Data Loading

`CREATE SCHEMA` amazon ;

`USE` amazon;

`CREATE TABLE` sales

(

Ind `int,`  

>Changed the name of the index column since "index" is a keyword in SQL

OrderID	`varchar(255),`

Date `date,`

Status	`varchar(255),`

Fulfilment	`varchar(255),`

SalesChannel 	`varchar(255),`

ship_service_level	`varchar(255),`

Style	`varchar(255),`

SKU `varchar(255),`

Category	`varchar(255),`

Size	`varchar(255),`

ASIN	`varchar(255),`

CourierStatus	`varchar(255),`

Qty	`int,`

currency	`varchar(255),`

Amount	`float4,`

ship_city	`varchar(255),`

ship_state	`varchar(255),`

ship_postal_code	`float4,`

ship_country	`varchar(255),`

promotion_ids	`varchar(255),`

B2B	`varchar(255),`

fulfilled_by	`varchar(255),`

unnamed_22 `varchar(255)`

);

`LOAD DATA LOCAL INFILE` 'C:/Users/acer/Desktop/Amazon Sale Report.csv' 

`INTO TABLE` sales

`FIELDS TERMINATED BY` ','

`ENCLOSED BY` '"'

`LINES TERMINATED BY` '\n'

`IGNORE` 1 rows;

Let us see if the data has loaded properly.

`SELECT * FROM` amazon.sales;

![Capture](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/a64b7b02-55eb-4334-aee3-eb83e83e9d15)

We can see at first glance that there are many null values and column names are not standardized.Also there many unnecessary columns which need to be dropped.We also need to create new columns and edit some rows to make this data suitable for analysis.

**Dropping unnecessary columns**

`ALTER TABLE` sales

`DROP COLUMN` unnamed_22,
>undeterminable data

`DROP COLUMN` fulfilled_by,
>only value was amazon courier "easy-ship" with no other relationship

`DROP COLUMN` ship_country,
>The shipping Country is India

`DROP COLUMN` currency,
>the currency is Indian Rupee (INR)

`DROP COLUMN` SalesChannel;
>assumed to be sold through amazon

Data after dropping columns:

![Capture](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/30a5f6b4-0c15-41c2-a0b5-1d7b76390283)

**Removing duplicates**

Data count before removing duplicates.

`SELECT COUNT(*)` as DataCount 

`FROM` sales;

![Capture](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/547bc22f-6dfa-4386-8116-053c722379bb)

`SELECT` OrderID, ASIN, COUNT(*) AS DuplicateCount

`FROM` sales

`GROUP BY` OrderID, ASIN

`HAVING` COUNT(*) > 1;

These are the duplicate values.

![Dup](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/9f2164ab-d5cc-4173-95e7-225ae91fda78)

>Creating a VIEW to save the data which have no dupliactes and then deleting the values which are not in the VIEW.

`CREATE VIEW` keep_sales_view AS
`SELECT` MIN(Ind) AS keep_index
`FROM` sales
`GROUP BY` OrderID, ASIN;

`DELETE FROM` sales
`WHERE` Ind NOT IN (SELECT keep_index FROM keep_sales_view);

>Dropping the view

`DROP VIEW` keep_sales_view;

Data count after removing the duplicates.

![Dup](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/dcd559a1-5542-4b01-b18a-4a63f5bc3400)

**Filling null values**

  `SELECT` * 
  
  `FROM` sales 
  
  `WHERE` CourierStatus=' ' `OR` promotion_ids=' ' `OR` ship_city=' ' `OR` ship_state=' ';

  ![Capture3](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/a32a234b-714c-4e0b-811f-85c64144ce86)


`UPDATE` sales

`SET`

  CourierStatus = `CASE WHEN` CourierStatus = ' ' `THEN` 'Unknown' `ELSE` CourierStatus `END`,
  
  promotion_ids = `CASE WHEN`  promotion_ids = ' ' `THEN` 'No promotion' `ELSE` promotion_ids `END`,
  
  ship_city = `CASE WHEN`  ship_city = ' ' `THEN` 'Unknown' `ELSE` ship_city `END`,
  
  ship_state = `CASE WHEN`  ship_state = ' ' `THEN` 'Unknown' `ELSE` ship_state `END`;

  `SELECT` * 
  
  `FROM` sales 
  
  `WHERE` CourierStatus=' ' `OR` promotion_ids=' ' `OR` ship_city=' ' `OR` ship_state=' ';

![Capture](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/652e2364-6120-4dc3-b42b-5aeed215279f)

`SELECT` * 
`FROM` amazon.sales;
  
![null](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/f5d1a954-369d-4ae4-a320-545bc0a8dc9a)

**Changing B2B column**

`SELECT` B2B 

`FROM` sales;

![Capture](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/0badc4fe-f495-4a60-b6bc-f81019243809)

>Changing the column name to **customer_type** and changing the values to **business** and **customer**

`ALTER TABLE` sales

`CHANGE COLUMN` B2B customer_type varchar(255);

`UPDATE` sales

`SET` customer_type = `CASE`

  `WHEN` customer_type = 'TRUE' `THEN` 'Business'
    
  ` WHEN` customer_type = 'FALSE' `THEN` 'Customer'
   
`END`;

`SELECT` customer_type 

`FROM` sales;

![Capture](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/ec22c039-19ac-495b-b45f-5e45762b9bca)

**Changing column name of Amount and converting to $**

`ALTER TABLE` sales

`CHANGE COLUMN` Amount order_amount_in_$ float4;

UPDATE sales

`SET`  order_amount_in_$ =  order_amount_in_$ * 0.012;
>Multiplying with the current exchange rate

`SELECT` order_amount_in_$ 

`FROM` sales;

![Capture](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/c7571291-06b8-42e9-9c8a-91ff61bcb1e0)

**Deleting March data**

`SELECT` DISTINCT date 

`FROM` sales

`ORDER BY` date;

![Capture](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/b0c90ecd-2250-4b5d-81b8-863f246bc855)
>There is only data of 1 day for the month of March,so it better to remove all the data for the month of March.

`DELETE` 

`FROM` sales

`WHERE` MONTH(Date) = 3;

`SELECT` DISTINCT date 

`FROM` sales

`ORDER BY` date;

![Capture](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/994e1f98-404e-47bd-86bf-af97caa6bc27)

**Creating a Month column**
>Extracting the **month** part from the date column and inserting it into the new **Month** column.This Month column will be really useful during analyzing the data.

`ALTER` TABLE sales

`ADD COLUMN` Month VARCHAR(20);

`UPDATE` sales

`SET` Month = DATE_FORMAT(date, '%M');

`SELECT` date,Month 

`FROM` sales;

![Capture](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/59d5c39d-4389-467d-a799-0648087d92d1)

**Standarzing the Ship City and State column values**

`SELECT DISTINCT` ship_state
`FROM` sales
`ORDER BY` ship_state;

![Capture](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/f2ddf806-b80f-4c0f-8278-909e26da9362)
![Capture2](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/13015d2f-5841-4bb4-8604-8e425451a3f0)
>**AR** and **APO** is Arunachal Pradesh.**NL** is Nagaland.Corrected the name of **orissa** to **Odisha** and **Pondicherry** to **Puducherry**.**RJ,rajshthan and Rajshthan** is Rajashthan.**PB** is Punjab.**Punjab/Mohali/Zirakpur** is also Punjab.

`UPDATE` sales

`SET` ship_state = 'Arunachal Pradesh'

`WHERE` ship_state `IN` ('AR', 'APO');

`UPDATE` sales

`SET` ship_state = 'Nagaland'

`WHERE` ship_state = 'NL';

`UPDATE` sales

`SET` ship_state = 'Odisha'

`WHERE` ship_state = 'orissa';

`UPDATE` sales

`SET` ship_state = 'Punjab'

`WHERE` ship_state `IN` ('PB','Punjab/Mohali/Zirakpur');

`UPDATE` sales

`SET` ship_state = 'Puducherry'

`WHERE` ship_state = 'Pondicherry';

`UPDATE` sales

`SET` ship_state = 'Rajasthan'

`WHERE` ship_state `IN` ('RJ','Rajshthan','rajsthan');

`UPDATE` sales

`SET` ship_state = UPPER(ship_state);
>Further standardizing by capitalizing all the values.

`UPDATE` sales
`SET` ship_state = REPLACE(ship_state, ' AND ', ' & ');
>Replacing all the **AND** in between strings with **&**.Like ANDAMAN AND NICOBAR to ANDAMAN & NICOBAR.

`SELECT DISTINCT` ship_state

`FROM` sales

`ORDER BY` ship_state;

![Capture](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/2fa5eaff-e960-44b1-a756-1fc3a3cec84d)


>We need to strategize this part of the data cleaning to standardize the ship city names.

`SELECT` DISTINCT ship_city

`FROM` sales

`ORDER BY` ship_city;


![Capture](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/a465752a-67ce-4fc7-bee8-eb98da6748fd)
![Capture2](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/071323bf-0934-46d0-aaaf-8ca376dd2796)

>It is kind of impossible to standardize the value for each and every city name.So we will get rid of the special characters,but before that we will assign the correct city name for the values with special characters whose name are specified correctly with the help of the postal codes.

`UPDATE` sales

`SET` ship_city ='Kangra'

`WHERE` ship_city='53miles';

`UPDATE` sales

`SET` ship_city='Dehradun'

`WHERE` ship_city= '1';

`UPDATE` sales

`SET` ship_city='Ayodhya'

`WHERE` ship_city= ',raibarely road faizabad (Ayodhya)';

`UPDATE` sales

`SET` ship_city='NRpura'

`WHERE` ship_city= '(Chikmagalur disterict).     (N.R pur thaluku)';

`UPDATE` sales

`SET` ship_city='Uttarpara'

`WHERE` ship_city= '116  B. P. M. B SARANI, UTTARPARA KOTRUNG';

`UPDATE` sales

`SET` ship_city='Kolkata'

`WHERE` ship_city= '147/19 B Keshab Chandra Sen Street Kolkata nine ma';

`UPDATE` sales

`SET` ship_city='Quepem'

`WHERE` ship_city= '(Via Cuncolim)Quepem,South Goa';

`UPDATE` sales

`SET` ship_city='Tadong'

`WHERE` ship_city= '6th mile tadong';

`UPDATE` sales

`SET` ship_city='Barasat'

`WHERE` ship_city= '7BARASAT';

`UPDATE` sales

`SET` ship_city  = 'Lucknow'

`WHERE` ship_postal_code= '226002';

>Now we remove the special characters and capitalize the names.

`UPDATE` sales

`SET` ship_city = REGEXP_REPLACE(ship_city, '[^a-zA-Z]', '');

`UPDATE` sales

`SET` ship_city = UPPER(ship_city);

`SELECT` DISTINCT ship_city

`FROM` sales

`ORDER BY` ship_city;

![Capture5](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/1b9ead2e-b12a-4b77-b045-fd8a838737ea)

`SELECT` *
`FROM` amazon.sales;

![Capture](https://github.com/freudeg0/PortfolioProject-DataCleaning/assets/93113869/d64a2960-a63d-4b2c-a4fb-a3246766d9de)


**Now this table is more usable for analysis.**











