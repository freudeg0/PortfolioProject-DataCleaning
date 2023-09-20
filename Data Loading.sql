use amazon;

/*Creating the table*/
create table sales
(
Ind int,
OrderID	varchar(255),
Date date,
Status	varchar(255),
Fulfilment	varchar(255),
SalesChannel 	varchar(255),
ship_service_level	varchar(255),
Style	varchar(255),
SKU varchar(255),
Category	varchar(255),
Size	varchar(255),
ASIN	varchar(255),
CourierStatus	varchar(255),
Qty	int,
currency	varchar(255),
Amount	float4,
ship_city	varchar(255),
ship_state	varchar(255),
ship_postal_code	float4,
ship_country	varchar(255),
promotion_ids	varchar(255),
B2B	varchar(255),
fulfilled_by	varchar(255),
unnamed_22 varchar(255)
);

/*Loading the csv file*/
LOAD data local infile 'C:/Users/acer/Desktop/Amazon Sale Report.csv' 
into table sales
fields terminated by ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
ignore 1 rows;

/*Enable loading local files*/
show variables like "local_infile";
set global local_infile=1;

/*Counting the total number of values*/
select count(*) as DataCount from sales;


 