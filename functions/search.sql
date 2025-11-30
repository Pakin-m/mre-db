-- functions/search.sql
-- Search helpers for fragments and concepts.

CREATE SCHEMA IF NOT EXISTS mre;

CREATE OR REPLACE FUNCTION mre.fn_search_fragments_text(
    p_workspace_id BIGINT,
    p_query_text   TEXT
)
    RETURNS TABLE (
                      fragment_id        BIGINT,
                      fragment_index     INTEGER,
                      source_id          BIGINT,
                      source_title       TEXT,
                      snippet            TEXT,
                      source_created_at  TIMESTAMPTZ
                  )
    LANGUAGE plpgsql
    STABLE
AS $$
BEGIN
    RETURN QUERY
        SELECT
            f.id                   AS fragment_id,
            f.fragment_index       AS fragment_index,
            s.id                   AS source_id,
            s.title                AS source_title,
            CASE
                WHEN length(f.text) > 200 THEN substr(f.text, 1, 200) || '…'
                ELSE f.text
                END                AS snippet,
            s.created_at           AS source_created_at
        FROM fragments f
                 JOIN sources   s ON s.id = f.source_id
        WHERE s.workspace_id = p_workspace_id
          AND f.text ILIKE '%' || p_query_text || '%'
        ORDER BY s.created_at DESC, s.id DESC, f.fragment_index;
END;
$$;


CREATE OR REPLACE FUNCTION mre.fn_search_concepts_by_name(
    p_workspace_id BIGINT,
    p_query_text   TEXT
)
    RETURNS TABLE (
                      concept_id      BIGINT,
                      name            TEXT,
                      description     TEXT,
                      fragments_count BIGINT
                  )
    LANGUAGE plpgsql
    STABLE
AS $$
BEGIN
    RETURN QUERY
        SELECT
            c.id,
            c.name,
            c.description,
            COUNT(fc.fragment_id) AS fragments_count
        FROM concepts c
                 LEFT JOIN fragment_concepts fc
                           ON fc.concept_id = c.id
        WHERE c.workspace_id = p_workspace_id
          AND c.name ILIKE '%' || p_query_text || '%'
        GROUP BY c.id, c.name, c.description
        ORDER BY fragments_count DESC, c.name;
END;
$$;
