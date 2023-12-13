use DeliveryOnlineMS

CREATE TABLE Shop (
    id_shop INT PRIMARY KEY IDENTITY(1,1),
    name_shop VARCHAR(50) NOT NULL UNIQUE,
    address_shop VARCHAR(100) NOT NULL,
    phone_shop VARCHAR(20) NOT NULL CHECK (phone_shop LIKE '8-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')
);

INSERT INTO Shop (name_shop, address_shop, phone_shop)
VALUES ('Пятёрочка', 'Улица Пушкина, 189', '8-999-123-45-67'),
       ('Перекрёсток', 'Улица Лермонтова, 89', '8-987-654-32-10'),
       ('Магнит', 'Улица Толстого, 289', '8-912-345-67-89');

select * from Shop;

CREATE TABLE Category (
    id_category INT PRIMARY KEY IDENTITY(1,1),
    name_category VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO Category (name_category) 
VALUES ('Фрукты'),
	   ('Овощи'),
	   ('Напитки');

select * from Category;

CREATE TABLE Product (
    id_product INT PRIMARY KEY IDENTITY(1,1),
    name_product VARCHAR(50) NOT NULL,
    description_product VARCHAR(255) NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Category(id_category)
);

ALTER TABLE Product
ADD price DECIMAL(10, 2);

INSERT INTO Product (name_product, description_product, category_id) 
VALUES ('Огурец', 'Сладкий', 2),
('Банан', 'Жёлтый', 1),
('Сок яблочный', 'Натуральные фрукты', 3);

INSERT INTO Product (name_product, description_product, category_id, price) 
VALUES ('????????', '???????', 1, 20),
('?????', '??????', 1, 50),
('??????', '???????????', 3, 35);

UPDATE Product
SET price = 30
WHERE name_product = '?????';

UPDATE Product
SET price = 20
WHERE name_product = '??????';

UPDATE Product
SET price = 25
WHERE name_product = '??? ????????';


select * from Product;

CREATE TABLE Photo (
    id_photo INT PRIMARY KEY IDENTITY(1,1),
    link_photo TEXT NOT NULL,
    product_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Product(id_product)
);

CREATE TABLE StoreProducts (
    id_store_product INT PRIMARY KEY IDENTITY(1,1),
    available_quantity INT NOT NULL CHECK (available_quantity >= 0),
    product_id INT NOT NULL,
    shop_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Product(id_product),
    FOREIGN KEY (shop_id) REFERENCES Shop(id_shop)
);

INSERT INTO StoreProducts (available_quantity, product_id, shop_id)
VALUES (78, 1, 1),
       (33, 2, 2),
       (25, 3, 3);

select * from StoreProducts;

CREATE TABLE Client (
    id_client INT PRIMARY KEY IDENTITY(1,1),
    name_client VARCHAR(30) NOT NULL,
    surname_client VARCHAR(30) NOT NULL,
    email_client VARCHAR(50) NOT NULL UNIQUE,
    phone_client VARCHAR(20) NOT NULL UNIQUE CHECK (phone_client LIKE '8-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'),
    login_client VARCHAR(50) NOT NULL CHECK (LEN(login_client) >= 6),
    password_client VARCHAR(50) NOT NULL CHECK (LEN(password_client) >= 6 AND password_client LIKE '%[0-9]%' AND password_client LIKE '%[!@#$%^&*()]%')
);

INSERT INTO Client (name_client, surname_client, email_client, phone_client, login_client, password_client)
VALUES ('Закир', 'Магомедов', 'zakir@mpt.com', '8-999-123-45-67', 'zakir123', 'zakir123!'),
       ('Глеб', 'Патрикеев', 'gleb@mpt.com', '8-999-234-56-78', 'gleb123', 'gleb123!'),
	   ('Кира', 'Аванская', 'kira@mpt.com', '8-999-234-58-78', 'kira123', 'kira123!');


ALTER TABLE Client
DROP CONSTRAINT CK__Client__password__4CA06362;
ALTER TABLE Client
ADD salt VARCHAR(50) NULL;

select * from Client;

CREATE TABLE Token (
    TokenId INT PRIMARY KEY IDENTITY(1,1),
    Token1 VARCHAR(MAX) NOT NULL,
    TokenDatetime DATETIME NOT NULL
);

CREATE TABLE Post (
    id_post INT PRIMARY KEY IDENTITY(1,1),
    name_post VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO Post (name_post)
VALUES ('Администратор'),
       ('Менеджер по заказам');

select * from Post;

CREATE TABLE Employee (
    id_employee INT PRIMARY KEY IDENTITY(1,1),
    name_employee VARCHAR(30) NOT NULL,
    surname_employee VARCHAR(30) NOT NULL,
    email_employee VARCHAR(50) NOT NULL UNIQUE,
    phone_employee VARCHAR(20) NOT NULL UNIQUE CHECK (phone_employee LIKE '8-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'),
    login_employee VARCHAR(50) NOT NULL CHECK (LEN(login_employee) >= 6),
    password_employee VARCHAR(50) NOT NULL CHECK (LEN(password_employee) >= 6 AND password_employee LIKE '%[0-9]%' AND password_employee LIKE '%[!@#$%^&*()]%'),
    post_id INT NOT NULL,
    FOREIGN KEY (post_id) REFERENCES Post(id_post)
);


INSERT INTO Employee (name_employee, surname_employee, email_employee, phone_employee, login_employee, password_employee, post_id)
VALUES ('Илья', 'Салов', 'ilya@mpt.com', '8-999-123-45-67', 'ilya123', 'ilya123!!', 1),
       ('Илья', 'Ефремов', 'efremov@mpt.com', '8-999-234-56-78', 'efromov123', 'efremov123!', 2);

select * from Employee;

CREATE TABLE Review (
    id_review INT PRIMARY KEY IDENTITY(1,1),
    grade INT CHECK (grade >= 1 AND grade <= 5) NOT NULL,
    text_review TEXT,
    date_review DATE NOT NULL,
    product_id INT NOT NULL,
    client_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Product(id_product),
    FOREIGN KEY (client_id) REFERENCES Client(id_client)
);

INSERT INTO Review (grade, text_review, date_review, product_id, client_id)
VALUES (5, 'Отличный продукт!', '2023-10-09', 1, 4),
       (2, 'Гнилые бананы', '2023-10-10', 2, 5);

select * from Review;

CREATE TABLE DeliveryMethod (
    id_deliveryMethod INT PRIMARY KEY IDENTITY(1,1),
    name_deliveryMethod VARCHAR(50) NOT NULL UNIQUE,
    price_deliveryMethod DECIMAL(10, 2) NOT NULL CHECK (price_deliveryMethod >= 0)
);

INSERT INTO DeliveryMethod (name_deliveryMethod, price_deliveryMethod)
VALUES ('Курьером', 100),
       ('Самовывоз', 0);

select * from DeliveryMethod;

CREATE TABLE StatusOrder (
    id_statusOrder INT PRIMARY KEY IDENTITY(1,1),
    name_statusOrder VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO StatusOrder (name_statusOrder)
VALUES ('В обработке'),
       ('В пути'),
       ('Доставлен');

select * from StatusOrder;

CREATE TABLE Orders (
    id_order INT PRIMARY KEY IDENTITY(1,1),
    amount_order DECIMAL(10, 2) NOT NULL CHECK (amount_order >= 0),
    code_order VARCHAR(50) NOT NULL UNIQUE,
    client_id INT NOT NULL,
    employee_id INT NOT NULL,
    deliveryMethod_id INT NOT NULL,
    statusOrder_id INT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES Client(id_client),
    FOREIGN KEY (employee_id) REFERENCES Employee(id_employee),
    FOREIGN KEY (deliveryMethod_id) REFERENCES DeliveryMethod(id_deliveryMethod),
    FOREIGN KEY (statusOrder_id) REFERENCES StatusOrder(id_statusOrder)
);

ALTER TABLE Orders
ADD order_date DATE NOT NULL DEFAULT GETDATE();

INSERT INTO Orders (amount_order, code_order, client_id, employee_id, deliveryMethod_id, statusOrder_id)
VALUES (150.75, 'ORDER123', 4, 2, 1, 1),
       (200.50, 'ORDER124', 5, 2, 2, 2),
       (75.20, 'ORDER125', 5, 2, 1, 3);

INSERT INTO Orders (amount_order, code_order, client_id, employee_id, deliveryMethod_id, statusOrder_id)
VALUES (150.75, 'ORDER123', 15, 2, 1, 1)

DELETE FROM Checks
WHERE order_id < 1017;

DELETE FROM Orders
WHERE id_order < 1017;

select * from Orders;

CREATE TABLE OrderList (
    id_orderList INT PRIMARY KEY IDENTITY(1,1),
    quantity INT NOT NULL CHECK (quantity > 0), 
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    product_id INT NOT NULL,
    order_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Product(id_product),
    FOREIGN KEY (order_id) REFERENCES Orders(id_order)
);


INSERT INTO OrderList (quantity, price, product_id, order_id)
VALUES (3, 50.00, 1, 1),
       (2, 30.00, 2, 1),
       (5, 25.50, 3, 2);

SELECT name
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('OrderList') AND referenced_object_id = OBJECT_ID('Orders');
ALTER TABLE OrderList
DROP CONSTRAINT FK__OrderList__order__6FE99F9F;

ALTER TABLE OrderList
ALTER COLUMN order_id INT NULL;

INSERT INTO OrderList (quantity, price, product_id)
VALUES (3, 50.00, 1)

select * from OrderList;

CREATE TABLE Checks (
    id_check INT PRIMARY KEY IDENTITY(1,1),
    number_check VARCHAR(50) NOT NULL UNIQUE,
    date_check DATE NOT NULL,
    order_id INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(id_order)
);

INSERT INTO Checks (number_check, date_check, order_id)
VALUES ('CHK12345', '2023-10-09', 1),
       ('CHK67890', '2023-10-10', 2);

select * from Checks;

CREATE TABLE Logs (
    id_log INT PRIMARY KEY IDENTITY(1,1),
    user_log varchar(255) NOT NULL,
    action_log VARCHAR(255) NOT NULL,
    log_date DATE NOT NULL
);

select * from Logs;





-- Представления --

CREATE VIEW ProductView AS
SELECT p.id_product AS [Идентификатор продукта], 
       p.name_product AS [Название продукта], 
       p.description_product AS [Описание продукта], 
       c.name_category AS [Название категории]
FROM Product p
JOIN Category c ON p.category_id = c.id_category;

SELECT * FROM ProductView;

CREATE VIEW PhotoView AS
SELECT p.id_photo AS [Идентификатор фото], 
       p.link_photo AS [Ссылка на фото], 
       pr.name_product AS [Название продукта]
FROM Photo p
JOIN Product pr ON p.product_id = pr.id_product;

SELECT * FROM PhotoView;

CREATE VIEW EmployeeView AS
SELECT e.id_employee AS [Идентификатор сотрудника], 
       e.name_employee AS [Имя], 
       e.surname_employee AS [Фамилия], 
       e.email_employee AS [Электронная почта], 
       e.phone_employee AS [Телефон], 
       p.name_post AS [Должность]
FROM Employee e
JOIN Post p ON e.post_id = p.id_post;

SELECT * FROM EmployeeView;

CREATE VIEW ReviewView AS
SELECT r.id_review AS [Идентификатор отзыва], 
       r.grade AS [Оценка], 
       r.text_review AS [Текст отзыва], 
       r.date_review AS [Дата отзыва],
       p.name_product AS [Название продукта], 
       c.surname_client AS [Фамилия клиента]
FROM Review r
JOIN Product p ON r.product_id = p.id_product
JOIN Client c ON r.client_id = c.id_client;

SELECT * FROM ReviewView;

CREATE VIEW OrdersView AS
SELECT o.id_order AS [Идентификатор заказа], 
       o.amount_order AS [Сумма заказа], 
       o.code_order AS [Код заказа], 
       c.surname_client AS [Фамилия клиента], 
       e.surname_employee AS [Фамилия сотрудника],
       d.name_deliveryMethod AS [Способ доставки], 
       s.name_statusOrder AS [Статус заказа]
FROM Orders o
JOIN Client c ON o.client_id = c.id_client
JOIN Employee e ON o.employee_id = e.id_employee
JOIN DeliveryMethod d ON o.deliveryMethod_id = d.id_deliveryMethod
JOIN StatusOrder s ON o.statusOrder_id = s.id_statusOrder;

SELECT * FROM OrdersView;

CREATE VIEW OrderListView AS
SELECT ol.id_orderList AS [Идентификатор позиции заказа], 
       ol.price AS [Стоимость], 
       p.name_product AS [Название продукта], 
       o.code_order AS [Код заказа]
FROM OrderList ol
JOIN Product p ON ol.product_id = p.id_product
JOIN Orders o ON ol.order_id = o.id_order;

SELECT * FROM OrderListView;

CREATE VIEW StoreProductsView AS
SELECT sp.id_store_product AS [Идентификатор товара в магазине], 
       sp.available_quantity AS [Доступное количество], 
       p.name_product AS [Название продукта], 
       s.name_shop AS [Название магазина]
FROM StoreProducts sp
JOIN Product p ON sp.product_id = p.id_product
JOIN Shop s ON sp.shop_id = s.id_shop;

SELECT * FROM StoreProductsView;

CREATE VIEW ChecksView AS
SELECT c.id_check AS [Идентификатор чека], 
       c.number_check AS [Номер чека], 
       c.date_check AS [Дата чека], 
       o.code_order AS [Код заказа]
FROM Checks c
JOIN Orders o ON c.order_id = o.id_order;

SELECT * FROM ChecksView;


-- ТРИГЕРЫ --

CREATE TRIGGER generate_unique_code_trigger
ON Orders
AFTER INSERT
AS
BEGIN
    UPDATE Orders
    SET code_order = 'CODE_' + CAST(INSERTED.id_order AS NVARCHAR(10))
    FROM INSERTED
    WHERE Orders.id_order = INSERTED.id_order;
END;

DROP TRIGGER IF EXISTS generate_unique_code_trigger;


CREATE TRIGGER LogUserActions_Orders
ON Orders
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ActionType VARCHAR(50);

    IF EXISTS (SELECT * FROM INSERTED) AND EXISTS (SELECT * FROM DELETED)
    BEGIN
        SET @ActionType = 
            CASE 
                WHEN NOT EXISTS (
                    SELECT * FROM INSERTED i
                    FULL JOIN DELETED d ON i.id_order = d.id_order
                    WHERE NOT EXISTS (
                        SELECT i.amount_order, i.client_id, i.code_order, i.statusOrder_id 
                        EXCEPT
                        SELECT d.amount_order, d.client_id, d.code_order, d.statusOrder_id
                    )
                )
                THEN '????? ???????'
                ELSE '?????? ????? ?????'
            END;
    END
    ELSE IF EXISTS (SELECT * FROM INSERTED)
    BEGIN
        SET @ActionType = '?????? ????? ?????';
    END
    ELSE IF EXISTS (SELECT * FROM DELETED)
    BEGIN
        SET @ActionType = '????? ??????';
    END

    INSERT INTO Logs (user_log, action_log, log_date)
    SELECT DISTINCT c.login_client, @ActionType, GETDATE()
    FROM INSERTED i
    JOIN Client c ON i.client_id = c.id_client
    WHERE i.client_id IS NOT NULL
          AND NOT EXISTS (SELECT 1 FROM DELETED d WHERE d.client_id = i.client_id);
END;


DROP TRIGGER IF EXISTS LogUserActions_Orders;

INSERT INTO Orders (amount_order, code_order, client_id, employee_id, deliveryMethod_id, statusOrder_id)
VALUES (1205.50, 'ORDER126', 15, 1, 1, 1);

UPDATE Orders
SET amount_order = 130.00
WHERE id_order = 1;

select*from Logs

CREATE TRIGGER GenerateCheckNumber
ON Checks
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE c
    SET number_check = 'CHK' + CAST(c.id_check AS NVARCHAR(50))
    FROM Checks c
    INNER JOIN INSERTED i ON c.id_check = i.id_check;
END;


CREATE TRIGGER CalculateOrderAmount
ON OrderList
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    WITH OrderTotals AS (
        SELECT ol.order_id, SUM(ol.quantity * ol.price) AS orderTotal
        FROM OrderList ol
        GROUP BY ol.order_id
    )
    UPDATE o
    SET amount_order = ot.orderTotal + d.price_deliveryMethod
    FROM Orders o
    INNER JOIN INSERTED i ON o.id_order = i.order_id
    INNER JOIN OrderTotals ot ON o.id_order = ot.order_id
    INNER JOIN DeliveryMethod d ON o.deliveryMethod_id = d.id_deliveryMethod
    WHERE o.id_order = i.order_id;
END;

DROP TRIGGER IF EXISTS CalculateOrderAmount;

UPDATE OrderList 
SET quantity = 5, price = 30.00 
WHERE id_orderList = 7;

select * from Orders
select * from OrderList


-- ПРОЦЕДУРЫ --

CREATE PROCEDURE GetProductsInShop
    @shop_id INT
AS
BEGIN
    SELECT p.name_product, p.description_product, sp.available_quantity
    FROM Product p
    INNER JOIN StoreProducts sp ON p.id_product = sp.product_id
    WHERE sp.shop_id = @shop_id;
END;

EXEC GetProductsInShop @shop_id = 1;


CREATE PROCEDURE SetOrderStatus
    @order_id INT,
    @statusOrder_id INT
AS
BEGIN
    UPDATE Orders
    SET statusOrder_id = @statusOrder_id
    WHERE id_order = @order_id;
END;

EXEC SetOrderStatus @order_id = 1, @statusOrder_id = 2;

select * from Orders;


CREATE PROCEDURE GetTotalOrderAmount
    @order_id INT
AS
BEGIN
    DECLARE @total_amount DECIMAL(10, 2);

    SELECT @total_amount = SUM(ol.quantity * ol.price)
    FROM OrderList ol
    WHERE ol.order_id = @order_id;

    SELECT @total_amount;
END;

DECLARE @order_id INT;
SET @order_id = 1; 
EXEC GetTotalOrderAmount @order_id; 


CREATE PROCEDURE DeleteProductFromShop
    @product_id INT,
    @shop_id INT
AS
BEGIN
    DELETE FROM StoreProducts
    WHERE product_id = @product_id AND shop_id = @shop_id;
END;

DECLARE @product_id INT;
DECLARE @shop_id INT;

SET @product_id = 1; 
SET @shop_id = 1;   

EXEC DeleteProductFromShop @product_id, @shop_id; 

SELECT * FROM StoreProducts WHERE product_id = @product_id AND shop_id = @shop_id;


CREATE PROCEDURE UpdateProduct
    @product_id INT,
    @name_product VARCHAR(50),
    @description_product VARCHAR(255),
    @category_id INT
AS
BEGIN
    UPDATE Product
    SET name_product = @name_product, description_product = @description_product, category_id = @category_id
    WHERE id_product = @product_id;
END;

DECLARE @product_id INT;
DECLARE @name_product VARCHAR(50);
DECLARE @description_product VARCHAR(255);
DECLARE @category_id INT;

SET @product_id = 2;                     
SET @name_product = 'Банан';    
SET @description_product = 'Сладкие';  
SET @category_id = 1;                  

EXEC UpdateProduct @product_id, @name_product, @description_product, @category_id;

SELECT * FROM Product WHERE id_product = @product_id;



-- ФУНКЦИИ --

CREATE FUNCTION dbo.GetProductsInShops (@shop_id INT)
RETURNS TABLE
AS
RETURN (
    SELECT p.name_product, p.description_product, sp.available_quantity
    FROM Product p
    INNER JOIN StoreProducts sp ON p.id_product = sp.product_id
    WHERE sp.shop_id = @shop_id
);

SELECT * FROM dbo.GetProductsInShops(2);

CREATE FUNCTION dbo.GetOrdersForClient (@client_id INT)
RETURNS TABLE
AS
RETURN (
    SELECT o.id_order, o.code_order, o.amount_order, os.name_statusOrder
    FROM Orders o
    INNER JOIN StatusOrder os ON o.statusOrder_id = os.id_statusOrder
    WHERE o.client_id = @client_id
);

SELECT * FROM dbo.GetOrdersForClient(4);

CREATE FUNCTION dbo.GetAverageRatingForProduct (@product_id INT)
RETURNS DECIMAL(3, 2)
AS
BEGIN
    DECLARE @average_rating DECIMAL(3, 2);
    SELECT @average_rating = AVG(grade * 1.0) FROM Review WHERE product_id = @product_id;
    RETURN @average_rating;
END;

SELECT dbo.GetAverageRatingForProduct(1);


CREATE FUNCTION dbo.GetProductsInCategory (@category_id INT)
RETURNS TABLE
AS
RETURN (
    SELECT p.name_product, p.description_product
    FROM Product p
    WHERE p.category_id = @category_id
);

SELECT * FROM dbo.GetProductsInCategory(2);


CREATE FUNCTION dbo.GetTotalOrderAmounts (@order_id INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @total_amount DECIMAL(10, 2);
    SELECT @total_amount = SUM(ol.quantity * ol.price)
    FROM OrderList ol
    WHERE ol.order_id = @order_id;
    RETURN @total_amount;
END;


SELECT dbo.GetTotalOrderAmounts(1);