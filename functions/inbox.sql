-- functions/inbox.sql
-- Inbox / recent sources and source creation helpers.

CREATE SCHEMA IF NOT EXISTS mre;

CREATE OR REPLACE FUNCTION mre.fn_inbox_recent_sources(
    p_workspace_id BIGINT,
    p_limit        INTEGER DEFAULT 20
)
    RETURNS TABLE (
                      source_id      BIGINT,
                      title          TEXT,
                      type           TEXT,
                      created_at     TIMESTAMPTZ,
                      fragment_count BIGINT
                  )
    LANGUAGE plpgsql
    STABLE
AS $$
BEGIN
    RETURN QUERY
        SELECT
            s.id,
            s.title,
            s.type,
            s.created_at,
            (SELECT COUNT(*) FROM fragments f WHERE f.source_id = s.id) AS fragment_count
        FROM sources s
        WHERE s.workspace_id = p_workspace_id
        ORDER BY s.created_at DESC, s.id DESC
        LIMIT p_limit;
END;
$$;


CREATE OR REPLACE FUNCTION mre.fn_create_source_with_fragments(
    p_workspace_id BIGINT,
    p_title        TEXT,
    p_type         TEXT,
    p_content      TEXT
)
    RETURNS BIGINT
    LANGUAGE plpgsql
    VOLATILE
AS $$
DECLARE
    v_source_id   BIGINT;
    v_fragments   TEXT[];
    v_fragment    TEXT;
    v_index       INTEGER := 1;
BEGIN
    INSERT INTO sources (workspace_id, title, type, content)
    VALUES (p_workspace_id, p_title, p_type, p_content)
    RETURNING id INTO v_source_id;

    IF p_content IS NOT NULL AND length(trim(p_content)) > 0 THEN
        v_fragments := regexp_split_to_array(p_content, E'(\r?\n){2,}');

        FOREACH v_fragment IN ARRAY v_fragments LOOP
                v_fragment := trim(v_fragment);

                IF length(v_fragment) > 0 THEN
                    INSERT INTO fragments (source_id, fragment_index, text)
                    VALUES (v_source_id, v_index, v_fragment);
                    v_index := v_index + 1;
                END IF;
            END LOOP;
    END IF;

    RETURN v_source_id;
END;
$$;
