-- schema/01_tables.sql
-- Core tables for the Modular Research Engine (MRE) database.
-- Foreign keys, UNIQUE, and extra CHECK constraints will be added
-- later in schema/02_constraints.sql.

CREATE TABLE IF NOT EXISTS users (
    id             BIGSERIAL PRIMARY KEY,
    name           TEXT NOT NULL,
    username       TEXT NOT NULL,
    email          TEXT NOT NULL,
    password_hash  TEXT NOT NULL,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS workspaces (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT NOT NULL,       -- FK to users.id (will be added in 02_constraints.sql)
    name        TEXT NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
