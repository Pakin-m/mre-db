-- schema/05_security.sql
-- Security and privilege configuration for the MRE database.

-- Create an application role with limited privileges.
-- This role has NOLOGIN so we can create a real DB user on Render
-- that INHERITS from this role (e.g. mre_app_user).

DO $$
    BEGIN
        IF NOT EXISTS (
            SELECT 1 FROM pg_roles WHERE rolname = 'mre_app'
        ) THEN
            CREATE ROLE mre_app NOLOGIN;
        END IF;
    END;
$$;

-- Revoke default public privileges on tables and functions in the public schema.

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA mre    FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA mre FROM PUBLIC;

-- Grant only what the application needs to mre_app:
-- the schemas, all tables, the id-generating sequences, and all MRE functions.

GRANT USAGE ON SCHEMA public TO mre_app;
GRANT USAGE ON SCHEMA mre    TO mre_app;

GRANT SELECT, INSERT, UPDATE, DELETE
    ON ALL TABLES IN SCHEMA public
    TO mre_app;

GRANT USAGE
    ON ALL SEQUENCES IN SCHEMA public
    TO mre_app;

GRANT EXECUTE
    ON ALL FUNCTIONS IN SCHEMA mre
    TO mre_app;

-- Default privileges

ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO mre_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT USAGE ON SEQUENCES TO mre_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA mre
    GRANT EXECUTE ON FUNCTIONS TO mre_app;
