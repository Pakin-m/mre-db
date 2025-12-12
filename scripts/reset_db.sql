-- scripts/reset_db.sql
-- Clear all data and reseed the MRE demo database.

TRUNCATE TABLE
    workspace_files,
    fragment_concepts,
    fragments,
    concepts,
    notes,
    sources,
    workspaces,
    users
    RESTART IDENTITY CASCADE;
