-- schema/03_indexes.sql
-- Indexes to speed up common queries in MRE.

-- Find workspaces by user.
CREATE INDEX IF NOT EXISTS idx_workspaces_user_id
    ON workspaces(user_id);

-- List recent sources in a workspace (Inbox screen).
CREATE INDEX IF NOT EXISTS idx_sources_workspace_created_at
    ON sources(workspace_id, created_at DESC);

-- Get fragments by source in order.
CREATE INDEX IF NOT EXISTS idx_fragments_source_fragment_index
    ON fragments(source_id, fragment_index);

-- Find concepts by workspace and name (for search/autocomplete).
CREATE INDEX IF NOT EXISTS idx_concepts_workspace_name
    ON concepts(workspace_id, name);

-- Fast joins from fragment -> concepts and concept -> fragments.
CREATE INDEX IF NOT EXISTS idx_fragment_concepts_fragment_id
    ON fragment_concepts(fragment_id);

CREATE INDEX IF NOT EXISTS idx_fragment_concepts_concept_id
    ON fragment_concepts(concept_id);

-- List notes per workspace by most recent.
CREATE INDEX IF NOT EXISTS idx_notes_workspace_created_at
    ON notes(workspace_id, created_at DESC);
