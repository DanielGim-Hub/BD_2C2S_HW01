CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE,
    status VARCHAR(20)
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_name VARCHAR(100),
    quantity INT,
    price NUMERIC(10,2)
);

-- Таблица клиентов
INSERT INTO customers (name, city) VALUES 
('Иван Иванов', 'Moscow'),
('Петр Петров', 'Saint Petersburg'),
('Мария Смирнова', 'Moscow');

-- Таблица заказов
INSERT INTO orders (customer_id, order_date, status) VALUES 
(1, '2024-01-15', 'Completed'),
(1, '2024-02-10', 'Pending'),
(2, '2024-01-20', 'Completed'),
(3, '2024-03-05', 'Completed');

-- Таблица товаров в заказах
INSERT INTO order_items (order_id, product_name, quantity, price) VALUES 
(1, 'Телефон', 3, 15000.00),
(1, 'Наушники', 1, 3000.00),
(2, 'Клавиатура', 2, 4000.00),
(3, 'Ноутбук', 1, 70000.00),
(4, 'Монитор', 5, 12000.00);

-- Соединяем три таблицы: customers, orders, order_items
-- И применяем фильтры:
-- 1. Только клиенты из Москвы
-- 2. Только заказы со статусом 'Completed'
-- 3. Только те позиции, где quantity >= 2
SELECT 
    c.customer_id,
    c.name AS customer_name,
    c.city,
    o.order_id,
    o.order_date,
    o.status,
    oi.product_name,
    oi.quantity,
    oi.price
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id -- Соединяем клиентов с заказами по customer_id
JOIN 
    order_items oi ON o.order_id = oi.order_id -- Соединяем заказы с товарами по order_id
WHERE 
    c.city = 'Moscow' 
    AND o.status = 'Completed'
    AND oi.quantity >= 2;

-- Анализ плана выполнения 
EXPLAIN (ANALYZE, VERBOSE)
SELECT 
    c.customer_id,
    c.name AS customer_name,
    c.city,
    o.order_id,
    o.order_date,
    o.status,
    oi.product_name,
    oi.quantity,
    oi.price
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
WHERE 
    c.city = 'Moscow' 
    AND o.status = 'Completed'
    AND oi.quantity >= 2;
