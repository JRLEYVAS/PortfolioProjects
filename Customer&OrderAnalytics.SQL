
/*1. How many orders were placed in January? 


SELECT COUNT(orderid)
FROM BIT_DB.JanSales
WHERE length(orderid) = 6 and orderid IS NOT NULL;



/*#2. How many of those orders were for an iPhone? 

SELECT COUNT(orderid)
FROM BIT_DB.JanSales
WHERE Product='iPhone'
AND length(orderid) = 6 
AND orderid <> 'Order ID';


/*#3. Select the customer account numbers for all the orders that were placed in February. 

SELECT distinct acctnum
FROM BIT_DB.FebSales as Feb
LEFT JOIN BIT_DB.customers as Cus
ON Feb.orderID = Cus.order_id
WHERE length(orderid) = 6 and orderid IS NOT NULL;


/*#4. Which product was the cheapest one sold in January, and what was the price? 

SELECT DISTINCT Product, price
FROM BIT_DB.JanSales
ORDER BY price
LIMIT 1;


/*#5. What is the total revenue for each product sold in January? (Revenue can be calculated using the number of products sold and the price of the products).

SELECT Product, (SUM( Quantity)* price) AS REVENUE
FROM BIT_DB.JanSales
GROUP BY Product;


/*#6. Which products were sold in February at 548 Lincoln St, Seattle, WA 98101, how many of each were sold, and what was the total revenue?

SELECT Product, Quantity,Price, (SUM( Quantity)* price) AS REVENUE
FROM BIT_DB.FebSales
WHERE length(orderid) = 6 and orderid IS NOT NULL
AND location = '548 Lincoln St, Seattle, WA 98101';



/*#7. How many customers ordered more than 2 products at a time in February, and what was the average amount spent for those customers?

SELECT Count(DISTINCT cus.acctnum) as CountOfCustOrders, AVG(Quantity * price) as AVGPrice
FROM BIT_DB.FebSales Feb
LEFT JOIN BIT_DB.customers cus
ON FEB.orderid=cus.order_id
WHERE Feb.Quantity > 2
AND length(orderid) = 6 
AND orderid <> 'Order ID';


/*#7. List all the products sold in Los Angeles in February, and include how many of each were sold.

SELECT Product, SUM(Quantity)
FROM BIT_DB.FebSales
WHERE location LIKE '%Los Angeles%'
GROUP BY Product; 
