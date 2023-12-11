--- A PROJECT ON DANNY'S DINER (Data sets: Sales Table, Menu Table & Members Table

--Create the 3 data sets and insert values them.
CREATE TABLE [SALES TABLE] (
Customer_Id VARCHAR(1), Order_Date DATE, Product_Id INT);

INSERT INTO [SALES TABLE] VALUES
('A', '2021-01-01', '1'),
('A', '2021-01-01', '2'),
('A', '2021-01-07', '2'),
('A', '2021-01-10', '3'),
('A', '2021-01-11', '3'),
('A', '2021-01-11', '3'),
('B', '2021-01-01', '2'),
('B', '2021-01-02', '2'),
('B', '2021-01-04', '1'),
('B', '2021-01-11', '1'),
('B', '2021-01-16', '3'),
('B', '2021-02-01', '3'),
('C', '2021-01-01', '3'),
('C', '2021-01-01', '3'),
('C', '2021-01-07', '3');

CREATE TABLE [MENU TABLE] (
Product_Id INT, Product_Name VARCHAR(5), Price INT);

INSERT INTO [MENU TABLE] VALUES
('1', 'Sushi', '10'),
('2', 'Curry', '15'),
('3', 'Ramen', '12');

CREATE TABLE [MEMBERS TABLE] (
Customer_Id VARCHAR(1), Join_Date DATE);

INSERT INTO [MEMBERS TABLE] VALUES
('A', '2021-01-07'),
('B', '2021-01-09');

--select all 3 tables
SELECT * FROM [Smart Joshua's Job]..[MEMBERS TABLE];
SELECT * FROM [Smart Joshua's Job]..[MENU TABLE];
SELECT * FROM [Smart Joshua's Job]..[SALES TABLE];

--What is the total amount each customer spent at the restaurant?
SELECT customer_id, SUM(price) Amount_Spent
FROM [Smart Joshua's Job]..[SALES TABLE] sa
JOIN [Smart Joshua's Job]..[MENU TABLE] me
ON sa.product_id = me.product_id
GROUP BY Customer_Id;

--How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(order_date) No_of_days
FROM [Smart Joshua's Job]..[SALES TABLE]
GROUP BY Customer_Id;

--What was the first item from the menu purchased by each customer?
SELECT TOP 1 customer_id, Product_Id
FROM [Smart Joshua's Job]..[SALES TABLE]
WHERE Customer_Id = 'A';
SELECT TOP 1 customer_id, Product_Id
FROM [Smart Joshua's Job]..[SALES TABLE]
WHERE Customer_Id = 'B';
SELECT TOP 1 customer_id, Product_Id
FROM [Smart Joshua's Job]..[SALES TABLE]
WHERE Customer_Id = 'C';

--What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT Customer_Id, (sa.Product_Id)Most_purchased_item, COUNT(sa.product_id) OVER (PARTITION BY sa.product_id) times_purchased
FROM [Smart Joshua's Job]..[SALES TABLE] sa
JOIN [Smart Joshua's Job]..[MENU TABLE] me
ON sa.product_id = me.product_id
ORDER BY times_purchased DESC;

--Which item was the most popular for each customer?
SELECT customer_id, product_id, COUNT(product_id) OVER (PARTITION BY product_id) AS Freq_of_Purchase
FROM [Smart Joshua's Job]..[SALES TABLE]
WHERE Customer_Id = 'A'
ORDER BY Freq_of_Purchase DESC;

SELECT customer_id, product_id, COUNT(product_id) OVER (PARTITION BY product_id) AS Freq_of_Purchase
FROM [Smart Joshua's Job]..[SALES TABLE]
WHERE Customer_Id = 'B'
ORDER BY Freq_of_Purchase DESC;

SELECT customer_id, product_id, COUNT(product_id) OVER (PARTITION BY product_id) AS Freq_of_Purchase
FROM [Smart Joshua's Job]..[SALES TABLE]
WHERE Customer_Id = 'C'
ORDER BY Freq_of_Purchase DESC;

--Which item was purchased first by the customer after they became a member?
SELECT top (1) sa.Customer_Id, Join_Date, Order_Date, sa.Product_Id, me.Product_Name first_product_bought
FROM [Smart Joshua's Job]..[SALES TABLE] sa
JOIN [Smart Joshua's Job]..[MEMBERS TABLE] mem
ON sa.customer_id=mem.customer_id
JOIN [Smart Joshua's Job]..[MENU TABLE] me
ON sa.Product_Id=me.Product_Id
WHERE Order_Date >= Join_Date AND sa.Customer_Id = 'A';

SELECT top (1) sa.Customer_Id, Join_Date, Order_Date, sa.Product_Id, me.Product_Name first_product_bought
FROM [Smart Joshua's Job]..[SALES TABLE] sa
JOIN [Smart Joshua's Job]..[MEMBERS TABLE] mem
ON sa.customer_id=mem.customer_id
JOIN [Smart Joshua's Job]..[MENU TABLE] me
ON sa.Product_Id=me.Product_Id
WHERE Order_Date >= Join_Date AND sa.Customer_Id = 'B'

--Which item was purchased just before the customer became a member?
SELECT top (1) sa.Customer_Id, Join_Date, Order_Date, sa.Product_Id, me.Product_Name first_product_bought
FROM [Smart Joshua's Job]..[SALES TABLE] sa
JOIN [Smart Joshua's Job]..[MEMBERS TABLE] mem
ON sa.customer_id=mem.customer_id
JOIN [Smart Joshua's Job]..[MENU TABLE] me
ON sa.Product_Id=me.Product_Id
WHERE Order_Date < Join_Date AND sa.Customer_Id = 'A'
ORDER BY order_date DESC;

SELECT top (1) sa.Customer_Id, Join_Date, Order_Date, sa.Product_Id, me.Product_Name first_product_bought
FROM [Smart Joshua's Job]..[SALES TABLE] sa
JOIN [Smart Joshua's Job]..[MEMBERS TABLE] mem
ON sa.customer_id=mem.customer_id
JOIN [Smart Joshua's Job]..[MENU TABLE] me
ON sa.Product_Id=me.Product_Id
WHERE Order_Date < Join_Date AND sa.Customer_Id = 'B'
ORDER BY order_date DESC;

--What is the total items and amount spent for each member before they became a member?
SELECT sa.Customer_Id, sa.Product_Id, Price, COUNT(sa.product_id) OVER (PARTITION BY sa.customer_id)Total_Product_bought,
		SUM(Price) OVER (PARTITION BY sa.Customer_id)Total_Amount_Spent
FROM [Smart Joshua's Job]..[SALES TABLE] sa
JOIN [Smart Joshua's Job]..[MEMBERS TABLE] mem
ON sa.customer_id=mem.customer_id
JOIN [Smart Joshua's Job]..[MENU TABLE] me
ON sa.Product_Id=me.Product_Id
WHERE Order_Date < Join_Date

--If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
---Sushi has 20 points per $1
SELECT sa.Product_Id, Customer_Id, Product_Name, Price, (price *20)Points
FROM [Smart Joshua's Job]..[MENU TABLE] me
JOIN [Smart Joshua's Job]..[SALES TABLE] sa
ON me.Product_Id=sa.Product_Id
WHERE Product_Name='Sushi';

--In the first week after a customer joins the program (including their join date) they earn 2x points on all items,
---not just sushi - how many points do customer A and B have at the end of January?
SELECT sa.Customer_Id, Join_date, Order_Date, Product_Name, Price, (price*20)points,
		SUM(price*20) OVER(PARTITION BY sa.customer_id)Total_Points
FROM [Smart Joshua's Job]..[SALES TABLE] sa
JOIN [Smart Joshua's Job]..[MENU TABLE] me
ON sa.Product_Id=me.Product_Id
JOIN [Smart Joshua's Job]..[MEMBERS TABLE]mem
ON sa.Customer_Id=mem.Customer_Id
WHERE Order_Date >= Join_Date AND Order_Date like '2021-01-%'

--Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking
---for non-member purchases so he expects null ranking values for the records when customers are not yet part of the
----loyalty program.

--Creating a general table
CREATE TABLE [GENERAL TABLE] (
Customer_Id VARCHAR(2), Order_Date DATE, Product_Name VARCHAR(5),
Price INT, Member VARCHAR(2))

INSERT INTO [GENERAL TABLE] VALUES
('A', '2021-01-01', 'Curry', '15', 'N'),
('A', '2021-01-01', 'Sushi', '10', 'N'),
('A', '2021-01-07', 'Curry', '15', 'Y'),
('A', '2021-01-10', 'Ramen', '12', 'Y'),
('A', '2021-01-11', 'Ramen', '12', 'Y'),
('A', '2021-01-11', 'Ramen', '12', 'Y'),
('B', '2021-01-01', 'Curry', '15', 'N'),
('B', '2021-01-02', 'Curry', '15', 'N'),
('B', '2021-01-04', 'Sushi', '10', 'N'),
('B', '2021-01-11', 'Sushi', '10', 'Y'),
('B', '2021-01-16', 'Ramen', '12', 'Y'),
('B', '2021-02-01', 'Ramen', '12', 'Y'),
('C', '2021-01-01', 'Ramen', '12', 'N'),
('C', '2021-01-01', 'Ramen', '12', 'N'),
('C', '2021-01-07', 'Ramen', '12', 'N')

SELECT *,
CASE
	WHEN Member = 'Y'
	THEN RANK() OVER(PARTITION BY customer_id, member ORDER BY order_date )
END AS Ranking
FROM [Smart Joshua's Job]..[GENERAL TABLE]