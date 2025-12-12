-- schema/01_tables.sql
-- Core tables for the Modular Research Engine (MRE) database.

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
    user_id     BIGINT NOT NULL,       -- FK to users.id (@02_constraints.sql)
    name        TEXT NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE workspace_files (
    id           BIGSERIAL PRIMARY KEY,
    workspace_id BIGINT NOT NULL,
    file_key     TEXT NOT NULL,  -- S3 key like workspace-1/uuid-name.jpg
    file_name    TEXT NOT NULL,  -- original filename
    content_type TEXT,
    size_bytes   BIGINT,
    public_url   TEXT NOT NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS sources (
    id            BIGSERIAL PRIMARY KEY,
    workspace_id  BIGINT NOT NULL,     -- FK to workspaces.id (@02_constraints.sql)
    title         TEXT NOT NULL,
    type          TEXT NOT NULL,       -- e.g. 'report', 'article', 'web_page'
    url           TEXT,
    content       TEXT,                -- optional raw content or full text
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS fragments (
    id             BIGSERIAL PRIMARY KEY,
    source_id      BIGINT NOT NULL,    -- FK to sources.id (@02_constraints.sql)
    fragment_index INTEGER NOT NULL,   -- position of fragment inside source (1, 2, 3…)
    text           TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS concepts (
    id            BIGSERIAL PRIMARY KEY,
    workspace_id  BIGINT NOT NULL,     -- FK to workspaces.id (@02_constraints.sql)
    name          TEXT NOT NULL,
    description   TEXT,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS fragment_concepts (
    fragment_id   BIGINT NOT NULL,     -- FK to fragments.id (@02_constraints.sql)
    concept_id    BIGINT NOT NULL      -- FK to concepts.id (@02_constraints.sql)
);

CREATE TABLE IF NOT EXISTS notes (
    id            BIGSERIAL PRIMARY KEY,
    workspace_id  BIGINT NOT NULL,     -- FK to workspaces.id (@02_constraints.sql)
    title         TEXT NOT NULL,
    body          TEXT NOT NULL,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);