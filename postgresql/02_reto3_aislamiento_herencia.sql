-- Como estamos en Docker, el script se ejecuta por defecto en la BD "postgres".
-- Primero creamos la BD "finanzas_db" y luego nos conectamos a ella.
--CREATE DATABASE finanzas_db;
--\c finanzas_db

-- 1. Crear el grupo NOLOGIN
CREATE ROLE grp_lectura_analitica NOLOGIN;

-- 2. Flujo obligatorio de permisos (BD -> Schema -> Tablas -> Tablas Futuras)
GRANT CONNECT ON DATABASE finanzas_db TO grp_lectura_analitica;
GRANT USAGE ON SCHEMA public TO grp_lectura_analitica;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO grp_lectura_analitica;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO grp_lectura_analitica;

-- 3. Privilegios futuros
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
    GRANT SELECT ON TABLES TO grp_lectura_analitica;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
    GRANT SELECT ON SEQUENCES TO grp_lectura_analitica;

-- 4. Crear usuario analista y darle HERENCIA explícita
CREATE ROLE analista_datos LOGIN PASSWORD 'AnalistaData_Pass!2024';
GRANT grp_lectura_analitica TO analista_datos;
ALTER ROLE analista_datos INHERIT;

-- 5. Cuenta temporal (Caduca el 31/12/2026)
CREATE ROLE auditor_temporal_pg LOGIN PASSWORD 'AuditorTemp_Pass!2024' INHERIT VALID UNTIL '2026-12-31 23:59:59';
GRANT grp_lectura_analitica TO auditor_temporal_pg;