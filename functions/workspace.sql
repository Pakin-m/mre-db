-- functions/workspace.sql
-- Workspace-level summary functions.

CREATE SCHEMA IF NOT EXISTS mre;

CREATE OR REPLACE FUNCTION mre.fn_workspace_overview(
    p_workspace_id BIGINT
)
    RETURNS TABLE (
                      workspace_id        BIGINT,
                      workspace_name      TEXT,
                      owner_user_id       BIGINT,
                      owner_username      TEXT,
                      sources_count       BIGINT,
                      fragments_count     BIGINT,
                      concepts_count      BIGINT,
                      notes_count         BIGINT,
                      last_activity_at    TIMESTAMPTZ
                  )
    LANGUAGE plpgsql
    STABLE
AS $$
BEGIN
    RETURN QUERY
        SELECT
            w.id                             AS workspace_id,
            w.name                           AS workspace_name,
            u.id                             AS owner_user_id,
            u.username                       AS owner_username,
            (SELECT COUNT(*) FROM sources  s WHERE s.workspace_id = w.id) AS sources_count,
            (SELECT COUNT(*) FROM fragments f
                                      JOIN sources s2 ON s2.id = f.source_id
             WHERE s2.workspace_id = w.id)                              AS fragments_count,
            (SELECT COUNT(*) FROM concepts c WHERE c.workspace_id = w.id) AS concepts_count,
            (SELECT COUNT(*) FROM notes    n WHERE n.workspace_id = w.id) AS notes_count,
            GREATEST(
                    w.created_at,
                    COALESCE((SELECT MAX(s.created_at) FROM sources s WHERE s.workspace_id = w.id), w.created_at),
                    COALESCE((SELECT MAX(n.created_at) FROM notes   n WHERE n.workspace_id = w.id), w.created_at)
            ) AS last_activity_at
        FROM workspaces w
                 JOIN users u ON u.id = w.user_id
        WHERE w.id = p_workspace_id;
END;
$$;
