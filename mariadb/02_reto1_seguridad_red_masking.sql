INSTALL SONAME 'auth_ed25519';

CREATE USER 'dba_core'@'172.18.0.1' IDENTIFIED VIA ed25519 USING PASSWORD('DbaCore_Ed25519!2024');
GRANT ALL PRIVILEGES ON *.* TO 'dba_core'@'172.18.0.1' WITH GRANT OPTION;

CREATE USER 'auditor_externo'@'172.18.0.%' IDENTIFIED BY 'AuditorExt_Pass!2024';
GRANT SELECT ON fintech_db.* TO 'auditor_externo'@'172.18.0.%';

CREATE OR REPLACE VIEW fintech_db.v_tarjetas_seguras AS
SELECT
    c.dni,
    c.nombre_completo AS nombre,
    c.nivel_riesgo,
    CONCAT('**** **** **** ', RIGHT(t.pan_tarjeta, 4)) AS pan_enmascarado
FROM fintech_db.tb_clientes c
INNER JOIN fintech_db.tb_tarjetas t ON c.id_cliente = t.id_cliente;

CREATE OR REPLACE VIEW fintech_db.panel_clientes AS SELECT * FROM fintech_db.v_tarjetas_seguras;