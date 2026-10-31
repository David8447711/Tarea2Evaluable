DROP DATABASE IF EXISTS fintech_db;
CREATE DATABASE fintech_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE fintech_db;

CREATE TABLE tb_clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    dni VARCHAR(15) NOT NULL UNIQUE,
    nombre_completo VARCHAR(150) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    nivel_riesgo ENUM('BAJO', 'MEDIO', 'ALTO') DEFAULT 'BAJO',
    fecha_alta DATE NOT NULL
);

CREATE TABLE tb_tarjetas (
    id_tarjeta INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    pan_tarjeta VARCHAR(16) NOT NULL UNIQUE,
    fecha_caducidad VARCHAR(5) NOT NULL,
    cvv VARCHAR(3) NOT NULL,
    limite_credito DECIMAL(10,2) NOT NULL,
    estado ENUM('ACTIVA', 'BLOQUEADA', 'CADUCADA') DEFAULT 'ACTIVA',
    FOREIGN KEY (id_cliente) REFERENCES tb_clientes(id_cliente) ON DELETE CASCADE
);

INSERT INTO tb_clientes (dni, nombre_completo, telefono, email, nivel_riesgo, fecha_alta) VALUES
('12345678A', 'Lucía Fernández Ramos', '+34600111222', 'lucia.fr@email.com', 'BAJO', '2020-01-15'),
('87654321B', 'Marcos Toledo Ortiz', '+34600333444', 'marcos.toledo@email.com', 'MEDIO', '2021-06-20'),
('11223344C', 'Sara Medina Valdés', '+34600555666', 'sara.medina@email.com', 'BAJO', '2019-11-10'),
('55667788D', 'Javier Romero Silva', '+34600777888', 'jromero.silva@email.com', 'ALTO', '2022-03-05'),
('99887766E', 'Carmen Vega López', '+34600999000', 'cvega.lopez@email.com', 'BAJO', '2018-08-30');

INSERT INTO tb_tarjetas (id_cliente, pan_tarjeta, fecha_caducidad, cvv, limite_credito, estado) VALUES
(1, '4532111122223333', '12/26', '123', 3000.00, 'ACTIVA'),
(1, '5412333344445555', '05/27', '456', 1500.00, 'ACTIVA'),
(2, '4532999988887777', '10/24', '789', 5000.00, 'CADUCADA'),
(3, '4532555566667777', '08/28', '321', 12000.00, 'ACTIVA'),
(4, '5412111100009999', '01/25', '654', 1000.00, 'BLOQUEADA'),
(5, '4532444433332222', '11/27', '987', 4500.00, 'ACTIVA');