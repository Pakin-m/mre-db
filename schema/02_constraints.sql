-- schema/02_constraints.sql
-- Referential integrity and key constraints for MRE database.

-- ===== Foreign keys =====

-- Each workspace belongs to exactly one user.
ALTER TABLE workspaces
    ADD CONSTRAINT workspaces_user_id_fk
        FOREIGN KEY (user_id)
            REFERENCES users(id)
            ON DELETE CASCADE;

-- Each source belongs to one workspace.
ALTER TABLE sources
    ADD CONSTRAINT sources_workspace_id_fk
        FOREIGN KEY (workspace_id)
            REFERENCES workspaces(id)
            ON DELETE CASCADE;

-- Each fragment belongs to one source.
ALTER TABLE fragments
    ADD CONSTRAINT fragments_source_id_fk
        FOREIGN KEY (source_id)
            REFERENCES sources(id)
            ON DELETE CASCADE;

-- Each concept belongs to one workspace.
ALTER TABLE concepts
    ADD CONSTRAINT concepts_workspace_id_fk
        FOREIGN KEY (workspace_id)
            REFERENCES workspaces(id)
            ON DELETE CASCADE;

-- Notes belong to a workspace.
ALTER TABLE notes
    ADD CONSTRAINT notes_workspace_id_fk
        FOREIGN KEY (workspace_id)
            REFERENCES workspaces(id)
            ON DELETE CASCADE;

-- Links between fragments and concepts.
ALTER TABLE fragment_concepts
    ADD CONSTRAINT fragment_concepts_fragment_id_fk
        FOREIGN KEY (fragment_id)
            REFERENCES fragments(id)
            ON DELETE CASCADE;

ALTER TABLE fragment_concepts
    ADD CONSTRAINT fragment_concepts_concept_id_fk
        FOREIGN KEY (concept_id)
            REFERENCES concepts(id)
            ON DELETE CASCADE;

-- Avoid duplicate links by using a composite primary key.
ALTER TABLE fragment_concepts
    ADD CONSTRAINT fragment_concepts_pkey
        PRIMARY KEY (fragment_id, concept_id);


-- ===== Uniqueness and validation =====

-- Users: emails and usernames must be unique.
ALTER TABLE users
    ADD CONSTRAINT users_email_uniq
        UNIQUE (email);

ALTER TABLE users
    ADD CONSTRAINT users_username_uniq
        UNIQUE (username);

-- Concepts: avoid duplicate concept names within the same workspace.
ALTER TABLE concepts
    ADD CONSTRAINT concepts_workspace_name_uniq
        UNIQUE (workspace_id, name);

-- Fragments: fragment_index must be positive.
ALTER TABLE fragments
    ADD CONSTRAINT fragments_fragment_index_positive
        CHECK (fragment_index > 0);
