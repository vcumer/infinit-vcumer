CREATE TABLE cars (
    car_id INT PRIMARY KEY,
    car_make VARCHAR(100),
    car_model VARCHAR(100),
    price DECIMAL(10, 2)
);

INSERT INTO cars (car_id, car_make, car_model, price) VALUES
(101, 'Peugeot', '208', 16199.99),
(102, 'Peugeot', '207', 13652.99),
(103, 'Toyota', 'Corolla', 18999.99),
(104, 'Ford', 'Focus', 19999.99),
(105, 'Honda', 'Civic', 20500.00),
(106, 'Nissan', 'Altima', 23000.90),
(107, 'Nissan', 'Qashqai', 25000.50),
(108, 'Chevrolet', 'Malibu', 21000.75),
(109, 'Volkswagen', 'Passat', 24899.95),
(110, 'Volkswagen', 'Polo', 17500.00);