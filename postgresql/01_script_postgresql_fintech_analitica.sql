CREATE DATABASE finanzas_db;
\c finanzas_db
CREATE TABLE tb_transacciones_historicas (
    id_transaccion SERIAL PRIMARY KEY,
    id_cliente_origen INT NOT NULL,
    fecha_operacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_operacion VARCHAR(50) NOT NULL,
    importe DECIMAL(12,2) NOT NULL,
    divisa VARCHAR(3) DEFAULT 'EUR',
    pais_origen VARCHAR(50) DEFAULT 'ESPAÑA',
    estado VARCHAR(20) DEFAULT 'COMPLETADA'
);

CREATE TABLE tb_alertas_fraude (
    id_alerta SERIAL PRIMARY KEY,
    id_transaccion_sospechosa INT NOT NULL,
    nivel_severidad VARCHAR(20) NOT NULL,
    motivo_alerta TEXT NOT NULL,
    fecha_deteccion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    revisado_por VARCHAR(50) DEFAULT NULL,
    FOREIGN KEY (id_transaccion_sospechosa) REFERENCES tb_transacciones_historicas(id_transaccion) ON DELETE CASCADE
);

INSERT INTO tb_transacciones_historicas (id_cliente_origen, fecha_operacion, tipo_operacion, importe, divisa, pais_origen, estado) VALUES
(1, '2023-01-15 10:23:00', 'PAGO_TPV', 45.50, 'EUR', 'ESPAÑA', 'COMPLETADA'),
(1, '2023-01-18 19:45:00', 'TRANSFERENCIA', 1500.00, 'EUR', 'ESPAÑA', 'COMPLETADA'),
(2, '2023-02-10 08:15:00', 'RETIRO_CAJERO', 300.00, 'EUR', 'ESPAÑA', 'COMPLETADA'),
(3, '2023-03-22 14:30:00', 'PAGO_ONLINE', 1250.00, 'USD', 'EEUU', 'COMPLETADA'),
(4, '2023-04-05 03:12:00', 'TRANSFERENCIA_INT', 8500.00, 'EUR', 'ESPAÑA', 'RETENIDA'),
(4, '2023-04-05 03:15:00', 'PAGO_ONLINE', 2500.00, 'RUB', 'RUSIA', 'RECHAZADA'),
(5, '2023-05-11 11:00:00', 'PAGO_TPV', 12.90, 'EUR', 'ESPAÑA', 'COMPLETADA');

INSERT INTO tb_alertas_fraude (id_transaccion_sospechosa, nivel_severidad, motivo_alerta, fecha_deteccion) VALUES
(5, 'ALTA', 'Transferencia internacional inusual en horario de madrugada.', '2023-04-05 03:13:00'),
(6, 'CRÍTICA', 'Intento de pago desde IP geolocalizada en país de alto riesgo tras operación inusual.', '2023-04-05 03:16:00'),
(4, 'MEDIA', 'Gasto elevado en divisa extranjera. Requiere verificación rutinaria.', '2023-03-22 14:35:00');

-- Forzar la asignación de permisos a las tablas ya creadas
GRANT SELECT ON ALL TABLES IN SCHEMA public TO grp_lectura_analitica;

-- ==========================================
-- RETO 3: Aislamiento, Herencia y Caducidad
-- ==========================================
CREATE ROLE grp_lectura_analitica NOLOGIN;

GRANT CONNECT ON DATABASE finanzas_db TO grp_lectura_analitica;
GRANT USAGE ON SCHEMA public TO grp_lectura_analitica;

-- IMPORTANTE: Esto se ejecuta DESPUÉS de crear las tablas
GRANT SELECT ON ALL TABLES IN SCHEMA public TO grp_lectura_analitica;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO grp_lectura_analitica;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
    GRANT SELECT ON TABLES TO grp_lectura_analitica;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
    GRANT SELECT ON SEQUENCES TO grp_lectura_analitica;

CREATE ROLE analista_datos LOGIN PASSWORD 'AnalistaData_Pass!2024';
GRANT grp_lectura_analitica TO analista_datos;
ALTER ROLE analista_datos INHERIT;

CREATE ROLE auditor_temporal_pg LOGIN PASSWORD 'AuditorTemp_Pass!2024' INHERIT VALID UNTIL '2026-12-31 23:59:59';
GRANT grp_lectura_analitica TO auditor_temporal_pg;