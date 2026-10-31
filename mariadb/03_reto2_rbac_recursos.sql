CREATE ROLE rol_gestor_fraude;
CREATE ROLE rol_atencion_cliente;

GRANT SELECT, INSERT, UPDATE, DELETE ON fintech_db.tb_clientes TO rol_gestor_fraude;
GRANT SELECT, INSERT, UPDATE, DELETE ON fintech_db.tb_tarjetas TO rol_gestor_fraude;

GRANT SELECT ON fintech_db.panel_clientes TO rol_atencion_cliente;

CREATE USER 'jefe_seguridad'@'%' IDENTIFIED BY 'JefeSeg_Pass!2024';
CREATE USER 'agente_sara'@'%' IDENTIFIED BY 'AgenteSara_Pass!2024';

GRANT rol_gestor_fraude TO 'jefe_seguridad'@'%';
SET DEFAULT ROLE rol_gestor_fraude FOR 'jefe_seguridad'@'%';

GRANT rol_atencion_cliente TO 'agente_sara'@'%';
SET DEFAULT ROLE rol_atencion_cliente FOR 'agente_sara'@'%';

CREATE USER 'bot_extraccion'@'%' IDENTIFIED BY 'BotExt_Pass!2024';
GRANT rol_atencion_cliente TO 'bot_extraccion'@'%';
SET DEFAULT ROLE rol_atencion_cliente FOR 'bot_extraccion'@'%';
ALTER USER 'bot_extraccion'@'%' WITH MAX_USER_CONNECTIONS 3;