-- Create Database
CREATE DATABASE OnlineBookStore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
Book_ID	SERIAL PRIMARY KEY,
Title VARCHAR(100),
Author VARCHAR(100),
Genre VARCHAR(50),	
Published_Year INT,
Price NUMERIC(10,2),	
Stock INT);

DROP TABLES IF EXISTS Customers;
CREATE TABLE Customers (
Customer_ID	SERIAL PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(100),
Phone VARCHAR(15),
City VARCHAR(150),
Country VARCHAR(150));

DROP TABLES IF EXISTS orders;
CREATE TABLE Orders (
Order_ID serial PRIMARY KEY,
Customer_ID	INT REFERENCES Customers(Customer_ID),
Book_ID INT REFERENCES Customers(Book_ID),
Order_Date DATE,
Quantity INT,
Total_Amount NUMERIC(10,2));

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- 1) Retrieve all books in the "Fiction" genre:
select * from Books
where Genre="Fiction";

-- 2) Find books published after the year 1950:
select* from Books
where Published_Year>1950; 

-- 3) List all customers from Canada:
select * from Customers
where Country = "Canada";

-- 4) Show orders placed in November 2023:
select* from Orders
where Order_Date between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available:
select SUM(stock) AS Total_Stock
from Books;

-- 6) Find the details of the most expensive book:
select * from Books
ORDER BY Price DESC LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
select* from Orders
WHERE Quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
select* from Orders
WHERE Total_Amount>20;

-- 9) List all the genres available in the Books table:
select DISTINCT Genre from Books;

-- 10) Find the book with the lowest stock:
select * from Books
ORDER BY Stock ASC LIMIT 5;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(Total_Amount) AS Revenue FROM Orders;

-- 12)  Retrieve the total number of books sold for each  genre:
SELECT * FROM Orders;
SELECT B.Genre , SUM(O.Quantity) AS Total_Books_Sold
FROM Orders O
JOIN Books B ON O.Book_ID = B.Book_ID
GROUP BY B.Genre;

-- 13) Find the average price of books in the 'Fantasy' genre:
SELECT AVG(Price) AS Average_Price
FROM Books
WHERE Genre='Fantasy';

-- 14) List customers who have placed atleast two orders:
SELECT O.Customer_ID, C.Name, COUNT(O.Order_ID) AS ORDER_COUNT
FROM Orders O
JOIN Customers C ON O.Customer_ID = C.Customer_ID
GROUP BY O.Customer_ID, C.Name
HAVING COUNT(Order_ID) >=2;

-- 15) Find the most frequently ordered book:
SELECT O.Book_ID, B.Title, COUNT(O.Order_ID) AS ORDER_COUNT
FROM Orders O
JOIN Books B ON O.Book_ID = B.Book_ID
GROUP BY O.Book_ID, B.Title
ORDER BY ORDER_COUNT DESC LIMIT 7;

-- 16) Show the top 3 most expensive books of 'Fantasy' genre:
SELECT * FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC LIMIT 3;

-- 17) Retrieve the total quantity of books sold by each author:
SELECT B.Author, SUM(O.Quantity) AS TOTAL_BOOKS_SOLD
FROM Orders O 
JOIN Books B ON O.Book_ID = B.Book_ID
GROUP BY B.Author;

-- 18) List the cities where customers who spent over $30 are located:
SELECT DISTINCT C.City, Total_Amount
FROM Orders O
JOIN Customers C ON O.Customer_ID = C.Customer_ID
WHERE O.Total_Amount >30;

-- 19) Find the customer who spent the most on orders:
SELECT C.Customer_ID, C.Name, SUM(O.Total_Amount) AS Total_Spent
FROM  Orders O
JOIN Customers C ON O.Customer_ID = C.Customer_ID
GROUP BY C.Customer_ID, C.Name
ORDER BY Total_Spent DESC LIMIT 1;

-- 20) Calculate the stock remaining after fulfilling all orders:
SELECT B.Book_ID, B.Title, B.Stock, COALESCE(SUM(O.Quantity),0) AS Order_Qty,
	B.Stock - COALESCE(SUM(O.Quantity),0) AS Remaining_Qty
FROM Books B
LEFT JOIN Orders O ON B.Book_ID = O.Book_ID
GROUP BY B.Book_ID,B.Title,B.Stock;

