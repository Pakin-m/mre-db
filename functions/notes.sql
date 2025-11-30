-- functions/notes.sql
-- Notes listing and detail helpers.

CREATE SCHEMA IF NOT EXISTS mre;

CREATE OR REPLACE FUNCTION mre.fn_list_notes(
    p_workspace_id BIGINT
)
    RETURNS TABLE (
                      note_id     BIGINT,
                      title       TEXT,
                      created_at  TIMESTAMPTZ,
                      preview     TEXT
                  )
    LANGUAGE plpgsql
    STABLE
AS $$
BEGIN
    RETURN QUERY
        SELECT
            n.id       AS note_id,
            n.title    AS title,
            n.created_at,
            CASE
                WHEN length(n.body) > 160 THEN substr(n.body, 1, 160) || '…'
                ELSE n.body
                END    AS preview
        FROM notes n
        WHERE n.workspace_id = p_workspace_id
        ORDER BY n.created_at DESC, n.id DESC;
END;
$$;


CREATE OR REPLACE FUNCTION mre.fn_get_note(
    p_note_id BIGINT
)
    RETURNS TABLE (
                      note_id         BIGINT,
                      workspace_id    BIGINT,
                      workspace_name  TEXT,
                      owner_user_id   BIGINT,
                      owner_username  TEXT,
                      title           TEXT,
                      body            TEXT,
                      created_at      TIMESTAMPTZ
                  )
    LANGUAGE plpgsql
    STABLE
AS $$
BEGIN
    RETURN QUERY
        SELECT
            n.id              AS note_id,
            w.id              AS workspace_id,
            w.name            AS workspace_name,
            u.id              AS owner_user_id,
            u.username        AS owner_username,
            n.title,
            n.body,
            n.created_at
        FROM notes n
                 JOIN workspaces w ON w.id = n.workspace_id
                 JOIN users      u ON u.id = w.user_id
        WHERE n.id = p_note_id;
END;
$$;


CREATE OR REPLACE FUNCTION mre.fn_create_note(
    p_workspace_id BIGINT,
    p_title        TEXT,
    p_body         TEXT
)
    RETURNS BIGINT
    LANGUAGE plpgsql
    VOLATILE
AS $$
DECLARE
    v_note_id BIGINT;
BEGIN
    INSERT INTO notes (workspace_id, title, body)
    VALUES (p_workspace_id, p_title, p_body)
    RETURNING id INTO v_note_id;

    RETURN v_note_id;
END;
$$;
