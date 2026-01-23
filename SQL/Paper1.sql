CREATE DATABASE Sportswear;

CREATE TABLE color (
    id INT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    extra_fee DECIMAL(6,2) CHECK (extra_fee >= 0)
);

INSERT INTO color VALUES
(1,'Red',50),
(2,'Green',30),
(3,'Blue',0),
(4,'Black',20),
(5,'White',0),
(6,'Yellow',0);

CREATE TABLE customer (
    id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    favorite_color_id INT,
    FOREIGN KEY (favorite_color_id) REFERENCES color(id)
);

INSERT INTO customer VALUES
(101,'Jay','Patel',1),
(102,'Dhruv','Shah',2),
(103,'Amit','Joshi',3),
(104,'Neha','Mehta',4),
(105,'Priya','Desai',5),
(106,'Rahul','Modi',6),
(107,'Riya','Kapoor',3);

CREATE TABLE category (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    parent_id INT NULL,
    FOREIGN KEY (parent_id) REFERENCES category(id)
);
INSERT INTO category VALUES
(1,'Top Wear',NULL),
(2,'Bottom Wear',NULL),
(3,'T-Shirt',1),
(4,'Jacket',1),
(5,'Joggers',2),
(6,'Shorts',2);

CREATE TABLE clothing (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    size VARCHAR(10) CHECK (size IN ('S','M','L','XL','2XL','3XL')),
    price DECIMAL(8,2) CHECK (price > 0),
    color_id INT NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (color_id) REFERENCES color(id),
    FOREIGN KEY (category_id) REFERENCES category(id)
);

INSERT INTO clothing VALUES
(201,'Sports T-Shirt','M',800,1,3),
(202,'Sports T-Shirt','L',850,2,3),
(203,'Sports T-Shirt','XL',900,3,3),
(204,'Winter Jacket','XL',2000,4,4),
(205,'Training Joggers','M',1200,5,5),
(206,'Training Joggers','L',1300,3,5),
(207,'Training Joggers','XL',1400,2,5),
(208,'Running Shorts','M',700,6,6),
(209,'Running Shorts','XL',750,1,6);

CREATE TABLE clothing_order (
    id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    clothing_id INT NOT NULL,
    items INT CHECK (items > 0),
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (clothing_id) REFERENCES clothing(id)
);

INSERT INTO clothing_order VALUES
(301,101,201,2,'2024-04-10'),
(302,101,203,1,'2024-05-12'),
(303,102,205,3,'2024-03-22'),
(304,103,204,1,'2024-06-18'),
(305,104,207,2,'2024-04-25'),
(306,105,208,4,'2024-07-02'),
(307,101,205,1,'2025-01-10');


SELECT * FROM color
SELECT * FROM customer
SELECT * FROM clothing
SELECT * FROM category
SELECT * FROM clothing_order

--1.List the customers whose favorite color is Red or Green and name is Jay or Dhruv
    SELECT * FROM CUSTOMER
    WHERE favorite_color_id IN (1,2) AND first_name IN ('Jay','Dhruv')

--2.List the different types of Joggers with their sizes.
    SELECT NAME,SIZE FROM clothing
    WHERE NAME LIKE '%JOGGERS%'

--3.List the orders of Jay of T-Shirt after 1st April 2024.
    SELECT CL.NAME,CO.clothing_id,CU.first_name
    FROM clothing CL INNER JOIN clothing_order CO
    ON CL.ID = CO.clothing_id
    INNER JOIN CUSTOMER CU
    ON CU.ID = CO.customer_id
    WHERE CL.NAME LIKE '%T-SHIRT%' AND CU.ID = 101 AND CO.order_date >'2024-04-01'

--4.List the customer whose favorite color is charged extra.
    SELECT CUS.first_name 
    FROM COLOR COL INNER JOIN CUSTOMER CUS
    ON COL.ID = CUS.favorite_color_id
    WHERE EXTRA_FEE >0

--5.List category wise clothing’s maximum price, minimum price, average price and number of clothing items.
    SELECT MAX(CLO.PRICE) AS MAX_PRICE,
          MIN(CLO.PRICE) AS MIN_PRICE,
          AVG(CLO.PRICE) AS AVG_PRICE,
          COUNT(CLO.ID) AS TOTAL_ITEMS,CAT.name
    FROM  clothing CLO INNER JOIN category CAT
    ON CLO.category_id = CAT.id
    GROUP BY CAT.name

--6.List the customers with no purchases at all.
    SELECT * FROM customer
    WHERE ID NOT IN (SELECT CUSTOMER_ID FROM clothing_order)

--7.List the orders of favorite color with all the details.
    SELECT CUS.first_name,COL.name AS favorite_color,CLO.name AS clothing_name,CLO.size,CLO.price,C_O.items,C_O.order_date
    FROM clothing_order C_O
    JOIN customer CUS ON C_O.customer_id = CUS.id
    JOIN clothing CLO ON C_O.clothing_id = CLO.id
    JOIN color COL ON CUS.favorite_color_id = COL.id
    WHERE CLO.color_id = CUS.favorite_color_id;


--8.List the customers with total purchase value, number of orders and number of items purchased.
    SELECT CUS.FIRST_NAME,SUM(CLO.PRICE * C_O.ITEMS) AS TOTAL_PURCHASE_VALUES,COUNT(C_O.ID) AS TOTAL_ORDERS,SUM(C_O.ITEMS) AS TOTAL_ITEMS
    FROM clothing_order C_O INNER JOIN clothing CLO
    ON C_O.clothing_id = CLO.id
    INNER JOIN customer CUS
    ON C_O.customer_id = CUS.ID
    GROUP BY CUS.first_name


--9.List the Clothing item, Size, Order Value and Number of items sold during financial year 2024-25
    SELECT CLO.NAME, CLO.SIZE,SUM(C_O.ITEMS*CLO.PRICE) AS ORDER_VALUE,SUM(C_O.ITEMS) AS TOTAL_ITEMS
    FROM clothing CLO INNER JOIN clothing_order C_O
    ON CLO.id = C_O.clothing_id
    WHERE order_date  BETWEEN  '2024-04-01' AND '2025-03-31'
    GROUP BY CLO.NAME,CLO.SIZE

--10.List the customers who wears XL size.
     SELECT DISTINCT CUS.FIRST_NAME 
     FROM customer CUS INNER JOIN clothing_order C_O
     ON CUS.id = C_O.customer_id
     INNER JOIN clothing CLO
     ON C_O.clothing_id = CLO.id
     WHERE SIZE = 'XL'