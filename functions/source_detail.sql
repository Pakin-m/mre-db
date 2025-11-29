-- functions/source_detail.sql
-- Source detail screen helpers.

CREATE SCHEMA IF NOT EXISTS mre;

CREATE OR REPLACE FUNCTION mre.fn_get_source_with_fragments(
    p_source_id BIGINT
)
    RETURNS TABLE (
                      source_id          BIGINT,
                      source_title       TEXT,
                      source_type        TEXT,
                      source_created_at  TIMESTAMPTZ,
                      fragment_id        BIGINT,
                      fragment_index     INTEGER,
                      fragment_text      TEXT
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
            f.id,
            f.fragment_index,
            f.text
        FROM sources s
                 LEFT JOIN fragments f
                           ON f.source_id = s.id
        WHERE s.id = p_source_id
        ORDER BY f.fragment_index;
END;
$$;
